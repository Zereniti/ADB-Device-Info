#!/usr/bin/env python3
# Author: Zerenity
# License: MIT
# Project: https://github.com/Zereniti/ADB-Device-Info
# Requires: Python 3.8+, ADB in PATH or set ADB env variable

import os
import re
import subprocess
import sys
import shutil

# ====== Windows ANSI support ======
if sys.platform == "win32":
    import ctypes
    kernel32 = ctypes.windll.kernel32
    kernel32.SetConsoleMode(kernel32.GetStdHandle(-11), 7)

# ====== Config ======
ADB = os.environ.get("ADB", "adb")

# ====== ANSI Colors ======
C_TITLE  = "\033[1;36m"
C_LABEL  = "\033[1;32m"
C_VALUE  = "\033[1;33m"
C_WARN   = "\033[1;33m"
C_RED    = "\033[1;31m"
C_GREEN  = "\033[1;32m"
C_YELLOW = "\033[1;33m"
C_BLUE   = "\033[1;34m"
C_NA     = "\033[0;90m"
C_RESET  = "\033[0m"

# ====== Android ASCII logo (compact, centers between info lines 8-25) ======
ANDROID_LOGO = [
    "⠀⠀⠀⠀⢀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠙⢷⣤⣤⣴⣶⣶⣦⣤⣤⡾⠋⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⣼⣿⣿⣉⣹⣿⣿⣿⣿⣏⣉⣿⣿⣧⠀⠀⠀⠀",
    "⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀",
    "⣠⣄⠀⢠⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⡄⠀⣠⣄",
    "⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⣿⣿",
    "⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⣿⣿",
    "⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⣿⣿",
    "⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⣿⣿",
    "⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⣿⣿",
    "⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⣿⣿",
    "⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⣿⣿",
    "⠻⠟⠁⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠈⠻⠟",
    "⠀⠀⠀⠀⠉⠉⣿⣿⣿⡏⠉⠉⢹⣿⣿⣿⠉⠉⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⣿⣿⣿⡇⠀⠀⢸⣿⣿⣿⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⣿⣿⣿⡇⠀⠀⢸⣿⣿⣿⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠀⠀⠀⠈⠉⠉⠀⠀⠀⠀⠉⠉⠁⠀⠀⠀⠀⠀⠀",
]
LOGO_LINES = [f"{C_GREEN}{line}{C_RESET}" for line in ANDROID_LOGO]

# ====== Helpers ======
ANSI_ESC = re.compile(r'\033\[[0-9;]*m')

def vlen(s: str) -> int:
    """Visible length of a string, ignoring ANSI escape codes.
    Accounts for wide (2-column) Unicode characters."""
    plain = ANSI_ESC.sub('', s)
    width = 0
    for ch in plain:
        cp = ord(ch)
        # Wide character ranges (CJK, braille counted as narrow in most terminals)
        if (0x1100 <= cp <= 0x115F or 0x2E80 <= cp <= 0x303E or
                0x3040 <= cp <= 0xA4CF or 0xAC00 <= cp <= 0xD7A3 or
                0xF900 <= cp <= 0xFAFF or 0xFE10 <= cp <= 0xFE19 or
                0xFE30 <= cp <= 0xFE6F or 0xFF00 <= cp <= 0xFF60 or
                0xFFE0 <= cp <= 0xFFE6 or 0x1F300 <= cp <= 0x1F64F or
                0x1F900 <= cp <= 0x1F9FF or 0x20000 <= cp <= 0x2FFFD or
                0x30000 <= cp <= 0x3FFFD):
            width += 2
        else:
            width += 1
    return width

def print_with_logo(logo: list, info: list, gap: int = 3):
    """Print logo vertically centered on the left, info lines on the right."""
    logo_w = max((vlen(l) for l in logo), default=0)
    # Pad logo with empty lines top and bottom to center it against info
    offset = max(0, (len(info) - len(logo)) // 2)
    padded_logo = [""] * offset + logo
    n = max(len(padded_logo), len(info))
    for i in range(n):
        l = padded_logo[i] if i < len(padded_logo) else ""
        r = info[i]        if i < len(info)         else ""
        pad = logo_w - vlen(l) + gap
        print(f"{l}{' ' * pad}{r}")

def run(*args, default="") -> str:
    try:
        result = subprocess.run(
            list(args), capture_output=True, text=True, timeout=10
        )
        return result.stdout.replace("\r", "").strip()
    except Exception:
        return default

def adb(*args, default="") -> str:
    return run(ADB, *args, default=default)

def adb_shell(command: str, default="") -> str:
    return adb("shell", command, default=default)

def get_prop(prop: str) -> str:
    return adb("shell", "getprop", prop)

def c(color: str, text: str) -> str:
    return f"{color}{text}{C_RESET}"

def fmt_prop(prop: str) -> str:
    val = get_prop(prop)
    return c(C_NA, L["NA"]) if not val else c(C_VALUE, val)

def fmt_line(label: str, value: str, fallback: str = "", color: str = C_VALUE) -> str:
    if not fallback:
        fallback = L["NA"]
    lbl = f"{C_LABEL}{label}{C_RESET} "
    val = c(C_NA, fallback) if not (value and value.strip()) else c(color, value)
    return lbl + val

def section(title: str) -> str:
    return c(C_TITLE, f"----[ {title} ]----")

# ====== Language selection ======
os.system("cls" if sys.platform == "win32" else "clear")
print(c(C_TITLE, "📱 ADB-Device-Info"))
print(c(C_TITLE, "------------------"))
print()
print(c(C_VALUE, "Select language / Selecciona idioma:"))
print(f"  {C_LABEL}[1]{C_RESET} English")
print(f"  {C_LABEL}[2]{C_RESET} Español")
print()
lang_choice = input("  > ").strip()
lang_es = lang_choice == "2"

# ====== Localized labels ======
if lang_es:
    L = {
        "TITLE":            "📱 Información del dispositivo Android (ADB)",
        "SEP":              "--------------------------------------------",
        "SEC_SYSTEM":       "Sistema",
        "SEC_HARDWARE":     "Hardware",
        "SEC_CONNECTIVITY": "Conectividad",
        "ANDROID":          "🤖 Android:",
        "SDK":              "🧩 SDK:",
        "MODEL":            "🏷️ Modelo:",
        "BRAND":            "🏭 Fabricante:",
        "SERIAL":           "🔢 Nº de serie:",
        "SOC":              "🧠 CPU / SoC:",
        "LOCALE":           "🌍 Región / Locale:",
        "TZ":               "🕒 Zona horaria:",
        "BOOT":             "🔒 OEM / Bootloader:",
        "SEC_PATCH":        "🛡️ Parche Android:",
        "PLAY_PATCH":       "🔐 Parche Google Play:",
        "BUILD_DATE":       "📅 Fecha de build:",
        "DISPLAY":          "🖥️ Pantalla:",
        "RAM":              "💾 RAM:",
        "KERNEL":           "🐧 Kernel:",
        "BATTERY":          "🔋 Batería:",
        "STORAGE":          "💽 Almacenamiento:",
        "WIFI_SSID":        "📶 WiFi SSID:",
        "WIFI_IP":          "🌐 IP local:",
        "BT_VER":           "🔵 Bluetooth:",
        "IMEI1":            "📶 IMEI 1:",
        "IMEI2":            "📶 IMEI 2:",
        "OPERATOR":         "📡 Operador SIM:",
        "BOOT_LOCKED":      "BLOQUEADO",
        "BOOT_UNLOCKED":    "DESBLOQUEADO",
        "BAT_CHARGING":     "Cargando",
        "BAT_DISCHARGING":  "Descargando",
        "BAT_NOT_CHARGING": "No cargando",
        "BAT_FULL":         "Completa",
        "BAT_UNKNOWN":      "Desconocido",
        "BAT_HEALTH":       "Salud",
        "BAT_CYCLES":       "ciclos",
        "BAT_USED":         "usados",
        "BAT_FREE":         "libres",
        "IMEI2_NA":         "No disponible / SIM única",
        "IMEI_NA":          "No accesible",
        "OPERATOR_NA":      "No detectado",
        "WIFI_NA":          "No conectado / No disponible",
        "BT_NA":            "No disponible",
        "NA":               "N/A",
        "ADB_NOT_FOUND":    "❌ No encuentro adb en",
        "ADB_INSTALL":      "   Instala con:",
        "ADB_ENV":          "   O usa: ADB=/ruta/a/adb python ADB-Info.py",
        "ADB_NO_DEVICE":    "❌ No hay dispositivo ADB conectado o autorizado.",
        "ADB_CHECK":        "   Comprueba: adb devices",
    }
else:
    L = {
        "TITLE":            "📱 Android Device Info (ADB)",
        "SEP":              "----------------------------",
        "SEC_SYSTEM":       "System",
        "SEC_HARDWARE":     "Hardware",
        "SEC_CONNECTIVITY": "Connectivity",
        "ANDROID":          "🤖 Android:",
        "SDK":              "🧩 SDK:",
        "MODEL":            "🏷️ Model:",
        "BRAND":            "🏭 Manufacturer:",
        "SERIAL":           "🔢 Serial number:",
        "SOC":              "🧠 CPU / SoC:",
        "LOCALE":           "🌍 Region / Locale:",
        "TZ":               "🕒 Timezone:",
        "BOOT":             "🔒 OEM / Bootloader:",
        "SEC_PATCH":        "🛡️ Android Patch:",
        "PLAY_PATCH":       "🔐 Google Play Patch:",
        "BUILD_DATE":       "📅 Build date:",
        "DISPLAY":          "🖥️ Display:",
        "RAM":              "💾 RAM:",
        "KERNEL":           "🐧 Kernel:",
        "BATTERY":          "🔋 Battery:",
        "STORAGE":          "💽 Storage:",
        "WIFI_SSID":        "📶 WiFi SSID:",
        "WIFI_IP":          "🌐 Local IP:",
        "BT_VER":           "🔵 Bluetooth:",
        "IMEI1":            "📶 IMEI 1:",
        "IMEI2":            "📶 IMEI 2:",
        "OPERATOR":         "📡 SIM Operator:",
        "BOOT_LOCKED":      "LOCKED",
        "BOOT_UNLOCKED":    "UNLOCKED",
        "BAT_CHARGING":     "Charging",
        "BAT_DISCHARGING":  "Discharging",
        "BAT_NOT_CHARGING": "Not charging",
        "BAT_FULL":         "Full",
        "BAT_UNKNOWN":      "Unknown",
        "BAT_HEALTH":       "Health",
        "BAT_CYCLES":       "cycles",
        "BAT_USED":         "used",
        "BAT_FREE":         "free",
        "IMEI2_NA":         "Not available / Single SIM",
        "IMEI_NA":          "Not accessible",
        "OPERATOR_NA":      "Not detected",
        "WIFI_NA":          "Not connected / Not available",
        "BT_NA":            "Not available",
        "NA":               "N/A",
        "ADB_NOT_FOUND":    "❌ Cannot find adb at",
        "ADB_INSTALL":      "   Install with:",
        "ADB_ENV":          "   Or use: ADB=/path/to/adb python ADB-Info.py",
        "ADB_NO_DEVICE":    "❌ No ADB device connected or authorized.",
        "ADB_CHECK":        "   Check: adb devices",
    }

# ====== Pre-flight ======
if not shutil.which(ADB) and not os.path.isfile(ADB):
    print(c(C_WARN, f"{L['ADB_NOT_FOUND']} '{ADB}'."))
    print(c(C_WARN, L["ADB_INSTALL"]))
    if sys.platform != "win32":
        print(c(C_WARN, "   sudo pacman -S android-tools      (Arch)"))
        print(c(C_WARN, "   sudo dnf install android-tools    (Fedora)"))
        print(c(C_WARN, "   sudo apt install adb              (Debian/Ubuntu)"))
    else:
        print(c(C_WARN, "   https://developer.android.com/tools/releases/platform-tools"))
    print(c(C_WARN, L["ADB_ENV"]))
    sys.exit(1)

run(ADB, "start-server")

device_state = adb("get-state")
if device_state != "device":
    print(c(C_WARN, L["ADB_NO_DEVICE"]))
    print(c(C_WARN, L["ADB_CHECK"]))
    sys.exit(1)

# ====== Collect data ======

# --- System ---
serial            = adb("get-serialno")
manufacturer      = get_prop("ro.product.manufacturer").lower()
model             = get_prop("ro.product.model")
manufacturer_disp = get_prop("ro.product.manufacturer")
vb_state          = get_prop("ro.boot.vbmeta.device_state")
flash_lock        = get_prop("ro.boot.flash.locked")
bootloader        = L["BOOT_UNLOCKED"] if (vb_state == "unlocked" or flash_lock == "0") else L["BOOT_LOCKED"]
sec_patch         = get_prop("ro.build.version.security_patch")
play_patch        = get_prop("ro.build.version.security_patch_google")
if not play_patch:
    gms_dump = adb_shell("dumpsys package com.google.android.gms")
    m = re.search(r"versionName=([\d.]+)", gms_dump)
    if m: play_patch = m.group(1)
build_date = " ".join(get_prop("ro.build.date").split())

# --- Display ---
wm_size_raw = adb_shell("wm size").splitlines()
wm_dens_raw = adb_shell("wm density").splitlines()
screen_res = screen_dpi = ""
if wm_size_raw:
    m = re.search(r":\s*(.+)$", wm_size_raw[0])
    if m: screen_res = m.group(1).strip()
if wm_dens_raw:
    m = re.search(r":\s*(.+)$", wm_dens_raw[0])
    if m: screen_dpi = m.group(1).strip()

display_type = get_prop("ro.display.type")
if not display_type:
    sf = adb_shell("dumpsys SurfaceFlinger")
    m = re.search(r"(LTPO AMOLED|LTPO OLED|AMOLED|POLED|OLED|IPS LCD|TFT LCD|LTPS|LCD)", sf, re.IGNORECASE)
    if m: display_type = m.group(1).upper()
if not display_type:
    desc = get_prop("ro.build.description")
    m = re.search(r"(amoled|oled|lcd)", desc, re.IGNORECASE)
    if m: display_type = m.group(1).upper()

# --- RAM ---
ddr_raw       = get_prop("ro.boot.hardware.ddr")
ddr_size_prop = get_prop("ro.boot.ddr_size").replace(" ", "")
ram_gib = ddr_size_prop or ""
ddr_vendor = ddr_type = ""
if ddr_raw and "," in ddr_raw:
    fields = [f.strip() for f in ddr_raw.split(",")]
    if not ram_gib and fields:    ram_gib    = fields[0]
    if len(fields) > 1:           ddr_vendor = fields[1]
    if len(fields) > 2:           ddr_type   = fields[2]

meminfo = adb_shell("cat /proc/meminfo")
ram_total_kb = ram_free_kb = 0
for line in meminfo.splitlines():
    if line.startswith("MemTotal:"):
        m = re.search(r"(\d+)", line)
        if m: ram_total_kb = int(m.group(1))
    elif line.startswith("MemAvailable:"):
        m = re.search(r"(\d+)", line)
        if m: ram_free_kb = int(m.group(1))

ram_used_mb = ram_total_mb = ram_perc_val = 0
if ram_total_kb > 0:
    ram_used_kb  = ram_total_kb - ram_free_kb
    ram_used_mb  = ram_used_kb  // 1024
    ram_total_mb = ram_total_kb // 1024
    ram_perc_val = ram_used_kb * 100 // ram_total_kb

ram_perc_color = C_RED if ram_perc_val >= 85 else (C_YELLOW if ram_perc_val >= 70 else C_GREEN)

# --- Kernel ---
kernel = adb_shell("uname -r")

# --- Storage ---
storage_official = get_prop("ro.boot.hardware.ufs").split(",")[0].strip()
storage_samsung  = ""
if manufacturer == "samsung":
    df_out = adb_shell("df /data").splitlines()
    if len(df_out) > 1:
        cols = df_out[-1].split()
        if len(cols) >= 2:
            try: storage_samsung = f"{float(cols[1]) / 1024 / 1024:.0f}GB"
            except ValueError: pass

df_data = adb_shell("df -h /data").splitlines()
df_line = next((l for l in reversed(df_data) if l and not l.startswith("Filesystem")), "")
df_cols = df_line.split()
data_used     = df_cols[2] if len(df_cols) > 2 else L["NA"]
data_avail    = df_cols[3] if len(df_cols) > 3 else L["NA"]
data_perc_s   = df_cols[4] if len(df_cols) > 4 else "0%"
try:    data_perc_raw = int(re.sub(r"[^\d]", "", data_perc_s))
except: data_perc_raw = 0

storage_perc_color = C_RED if data_perc_raw >= 86 else (C_YELLOW if data_perc_raw >= 70 else C_GREEN)

# --- Battery ---
battery_dump    = adb_shell("dumpsys battery")
bat_level = bat_status_code = bat_temp_raw = ""
for line in battery_dump.splitlines():
    ls = line.strip()
    if   ls.startswith("level:")       and not bat_level:       bat_level       = ls.split(":", 1)[1].strip()
    elif ls.startswith("status:")      and not bat_status_code: bat_status_code = ls.split(":", 1)[1].strip()
    elif ls.startswith("temperature:") and not bat_temp_raw:    bat_temp_raw    = ls.split(":", 1)[1].strip()

bat_level_int = int(bat_level) if bat_level.isdigit() else 0
bat_status = {"2": L["BAT_CHARGING"], "3": L["BAT_DISCHARGING"],
              "4": L["BAT_NOT_CHARGING"], "5": L["BAT_FULL"]}.get(bat_status_code, L["BAT_UNKNOWN"])

bat_temp = L["NA"]; bat_temp_deg = 0
if bat_temp_raw:
    try:
        bat_temp_deg = round(int(bat_temp_raw) / 10)
        bat_temp = f"{int(bat_temp_raw) / 10:.1f}°C"
    except ValueError: pass

charge_full   = adb_shell("cat /sys/class/power_supply/battery/charge_full")
charge_design = adb_shell("cat /sys/class/power_supply/battery/charge_full_design")
cycle_count   = adb_shell("cat /sys/class/power_supply/battery/cycle_count") or L["NA"]

bat_health_real = L["NA"]; bat_health_detail = ""; bat_health_int = 0
try:
    cf = float(charge_full); cd = float(charge_design)
    if cd > 0:
        bat_health_int    = round(cf / cd * 100)
        bat_health_real   = f"{bat_health_int}%"
        bat_health_detail = f" ({round(cf/1000)}/{round(cd/1000)} mAh)"
except (ValueError, ZeroDivisionError): pass

bat_level_color  = C_RED if bat_level_int <= 15 else (C_YELLOW if bat_level_int <= 30 else C_GREEN)
bat_health_color = C_RED if bat_health_int < 80 else (C_YELLOW if bat_health_int < 90 else C_GREEN)
bat_temp_color   = C_RED if bat_temp_deg > 45 else C_VALUE

# --- Connectivity ---
wifi_dump = adb_shell("dumpsys wifi")
wifi_ssid = ""
m = re.search(r'SSID:\s*"?([^",\s<>]+)"?', wifi_dump)
if m and not m.group(1).startswith("unknown"): wifi_ssid = m.group(1)

wlan_info = adb_shell("ip -4 addr show wlan0")
wifi_ip   = ""
m = re.search(r"inet\s+(\d+\.\d+\.\d+\.\d+)", wlan_info)
if m: wifi_ip = m.group(1)

bt_dump = adb_shell("dumpsys bluetooth_manager")
bt_version = ""
m = re.search(r"hci_version.*?(0x[0-9a-fA-F]+)", bt_dump, re.IGNORECASE)
if m:
    hci_dec = int(m.group(1), 16)
    bt_version = {14:"6.0",13:"5.4",12:"5.3",11:"5.2",10:"5.1",
                   9:"5.0", 8:"4.2", 7:"4.1", 6:"4.0"}.get(hci_dec, "")
if not bt_version: bt_version = get_prop("bluetooth.core.le.version")
bt_line = f"Bluetooth {bt_version}" if bt_version else ""

def parse_imei(raw: str) -> str:
    combined = "".join(re.findall(r"'([^']*)'", raw))
    return re.sub(r"[.\s]", "", combined)

imei1 = parse_imei(adb_shell("service call iphonesubinfo 1 s16 com.android.shell"))
imei2 = parse_imei(adb_shell("service call iphonesubinfo 4 i32 1 s16 com.android.shell"))

operator     = get_prop("gsm.operator.alpha").rstrip(", ")
operator_num = get_prop("gsm.operator.numeric").split(",")[0].rstrip(", ")

# ====== Build info lines ======
I = []  # info lines list

I.append(c(C_TITLE, L["TITLE"]))
I.append(c(C_TITLE, L["SEP"]))
I.append("")

# ── System ──
I.append(section(L["SEC_SYSTEM"]))
I.append(f"{C_LABEL}{L['ANDROID']}{C_RESET} {fmt_prop('ro.build.version.release')}")
I.append(f"{C_LABEL}{L['SDK']}{C_RESET} {fmt_prop('ro.build.version.sdk')}")
I.append(fmt_line(L["MODEL"],      model,             L["NA"], C_YELLOW))
I.append(fmt_line(L["BRAND"],      manufacturer_disp, L["NA"], C_YELLOW))
I.append(fmt_line(L["SERIAL"],     serial))
I.append(f"{C_LABEL}{L['LOCALE']}{C_RESET} {fmt_prop('persist.sys.locale')}")
I.append(f"{C_LABEL}{L['TZ']}{C_RESET} {fmt_prop('persist.sys.timezone')}")
I.append(fmt_line(L["BOOT"],       bootloader))
I.append(fmt_line(L["SEC_PATCH"],  sec_patch))
I.append(fmt_line(L["PLAY_PATCH"], play_patch))
I.append(fmt_line(L["BUILD_DATE"], build_date))
I.append("")

# ── Hardware ──
I.append(section(L["SEC_HARDWARE"]))
I.append(f"{C_LABEL}{L['SOC']}{C_RESET} {fmt_prop('ro.soc.model')}")

# Display
display_line = ""
if screen_res and screen_dpi: display_line = f"{screen_res} · {screen_dpi}dpi"
if display_type: display_line = f"{display_line} · {display_type}" if display_line else display_type
I.append(fmt_line(L["DISPLAY"], display_line))

# RAM
if not ram_gib:
    I.append(fmt_line(L["RAM"], ""))
else:
    parts = [c(C_YELLOW, ram_gib)]
    if ddr_type:   parts.append(c(C_VALUE, ddr_type))
    if ddr_vendor: parts.append(c(C_VALUE, ddr_vendor))
    ram_line = f" {C_VALUE}·{C_RESET} ".join(parts)
    if ram_total_mb > 0:
        ram_line += (
            f" {C_VALUE}·{C_RESET} "
            f"{C_VALUE}{ram_used_mb}MB/{ram_total_mb}MB ({C_RESET}"
            f"{ram_perc_color}{ram_perc_val}%{C_RESET}{C_VALUE}){C_RESET}"
        )
    I.append(f"{C_LABEL}{L['RAM']}{C_RESET} {ram_line}")

I.append(fmt_line(L["KERNEL"], kernel))

# Battery
if bat_level:
    I.append(
        f"{C_LABEL}{L['BATTERY']}{C_RESET} "
        f"{bat_level_color}{bat_level}%{C_RESET}"
        f" {C_VALUE}·{C_RESET} {C_VALUE}{bat_status}{C_RESET}"
        f" {C_VALUE}·{C_RESET} {bat_temp_color}{bat_temp}{C_RESET}"
        f" {C_VALUE}·{C_RESET} {C_VALUE}{L['BAT_HEALTH']} {C_RESET}"
        f"{bat_health_color}{bat_health_real}{bat_health_detail}{C_RESET}"
        f" {C_VALUE}·{C_RESET} {C_VALUE}{cycle_count} {L['BAT_CYCLES']}{C_RESET}"
    )
else:
    I.append(fmt_line(L["BATTERY"], ""))

# Storage
stor_label = storage_samsung or storage_official or ""
prefix = f"{C_VALUE}{stor_label} ({C_RESET}" if stor_label else f"{C_VALUE}("
I.append(
    f"{C_LABEL}{L['STORAGE']}{C_RESET} "
    f"{prefix}"
    f"{C_VALUE}{data_used} {L['BAT_USED']} · {data_avail} {L['BAT_FREE']} · {C_RESET}"
    f"{storage_perc_color}{data_perc_raw}%{C_RESET}{C_VALUE}){C_RESET}"
)
I.append("")

# ── Connectivity ──
I.append(section(L["SEC_CONNECTIVITY"]))
I.append(fmt_line(L["WIFI_SSID"], wifi_ssid, L["WIFI_NA"]))
I.append(fmt_line(L["WIFI_IP"],   wifi_ip,   L["WIFI_NA"]))
I.append(fmt_line(L["BT_VER"],    bt_line,   L["BT_NA"],  C_BLUE))
I.append(
    f"{C_LABEL}{L['IMEI1']}{C_RESET} "
    + (c(C_NA, L["IMEI_NA"]) if not imei1 else c(C_YELLOW, imei1))
)
I.append(
    f"{C_LABEL}{L['IMEI2']}{C_RESET} "
    + (c(C_NA, L["IMEI2_NA"]) if not imei2 else c(C_YELLOW, imei2))
)
if not operator.strip():
    I.append(f"{C_LABEL}{L['OPERATOR']}{C_RESET} {c(C_NA, L['OPERATOR_NA'])}")
else:
    I.append(f"{C_LABEL}{L['OPERATOR']}{C_RESET} {c(C_VALUE, f'{operator} ({operator_num})')}")

I.append("")

# ====== Output ======
os.system("cls" if sys.platform == "win32" else "clear")
print_with_logo(LOGO_LINES, I, gap=3)
