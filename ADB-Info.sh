#!/usr/bin/env bash
# Author: Zerenity
# License: MIT
# Project: https://github.com/Zereniti/ADB-Device-Info

# ====== Config ======
ADB="${ADB:-/usr/bin/adb}"

# ====== Colores ANSI ======
C_TITLE="\033[1;36m"
C_LABEL="\033[1;32m"
C_VALUE="\033[1;33m"
C_WARN="\033[1;33m"
C_RESET="\033[0m"
C_RED="\033[1;31m"
C_GREEN="\033[1;32m"
C_YELLOW="\033[1;33m"
C_BLUE="\033[1;34m"
C_NA="\033[0;90m"

# ====== Selección de idioma / Language selection ======
clear
echo -e "${C_TITLE}📱 ADB-Device-Info${C_RESET}"
echo -e "${C_TITLE}------------------${C_RESET}"
echo ""
echo -e "${C_VALUE}Select language / Selecciona idioma:${C_RESET}"
echo -e "  ${C_LABEL}[1]${C_RESET} English"
echo -e "  ${C_LABEL}[2]${C_RESET} Español"
echo ""
read -rp "  > " LANG_CHOICE

case "$LANG_CHOICE" in
  2) LANG_ES=true ;;
  *) LANG_ES=false ;;
esac

# ====== Textos según idioma / Localized labels ======
if $LANG_ES; then
  L_TITLE="📱 Información del dispositivo Android (ADB)"
  L_SEP="--------------------------------------------"
  L_SEC_DEVICE="Dispositivo"
  L_SEC_DISPLAY="Pantalla"
  L_SEC_PERF="Rendimiento"
  L_SEC_BATTERY="Batería"
  L_SEC_STORAGE="Almacenamiento"
  L_SEC_SYSTEM="Sistema"
  L_SEC_SECURITY="Seguridad"
  L_SEC_NETWORK="Conectividad"
  L_SEC_SIM="SIM"
  L_ANDROID="🤖 Android:"
  L_SDK="🧩 SDK:"
  L_MODEL="🏷️ Modelo:"
  L_BRAND="🏭 Fabricante:"
  L_SERIAL="🔢 Nº de serie:"
  L_SOC="🧠 CPU / SoC:"
  L_RAM="💾 RAM:"
  L_DISPLAY="🖥️ Pantalla:"
  L_KERNEL="🐧 Kernel (móvil):"
  L_BATTERY="🔋 Batería:"
  L_STORAGE="💽 Almacenamiento:"
  L_LOCALE="🌍 Región / Locale:"
  L_TZ="🕒 Zona horaria:"
  L_BOOT="🔒 OEM / Bootloader:"
  L_IMEI1="📶 IMEI 1:"
  L_IMEI2="📶 IMEI 2:"
  L_OPERATOR="📡 Operador SIM:"
  L_WIFI_SSID="📶 WiFi SSID:"
  L_WIFI_IP="🌐 IP local:"
  L_BT_VER="🔵 Bluetooth:"
  L_SEC_PATCH="🛡️ Parche Android:"
  L_BUILD_DATE="📅 Fecha de build:"
  L_PLAY_PATCH="🔐 Parche Google Play:"
  L_BOOT_LOCKED="BLOQUEADO"
  L_BOOT_UNLOCKED="DESBLOQUEADO"
  L_BAT_CHARGING="Cargando"
  L_BAT_DISCHARGING="Descargando"
  L_BAT_NOT_CHARGING="No cargando"
  L_BAT_FULL="Completa"
  L_BAT_UNKNOWN="Desconocido"
  L_BAT_HEALTH="Salud"
  L_BAT_CYCLES="ciclos"
  L_BAT_USED="usados"
  L_BAT_FREE="libres"
  L_IMEI2_NA="No disponible / SIM única"
  L_IMEI_NA="No accesible"
  L_OPERATOR_NA="No detectado"
  L_WIFI_NA="No conectado / No disponible"
  L_BT_NA="No disponible"
  L_NA="N/A"
  L_ADB_NOT_FOUND="❌ No encuentro adb en"
  L_ADB_INSTALL="   Instala con:"
  L_ADB_ENV="   O usa: ADB=/ruta/a/adb ./ADB-Info.sh"
  L_ADB_NO_DEVICE="❌ No hay dispositivo ADB conectado o autorizado."
  L_ADB_CHECK="   Comprueba: adb devices"
else
  L_TITLE="📱 Android Device Info (ADB)"
  L_SEP="----------------------------"
  L_SEC_DEVICE="Device"
  L_SEC_DISPLAY="Display"
  L_SEC_PERF="Performance"
  L_SEC_BATTERY="Battery"
  L_SEC_STORAGE="Storage"
  L_SEC_SYSTEM="System"
  L_SEC_SECURITY="Security"
  L_SEC_NETWORK="Connectivity"
  L_SEC_SIM="SIM"
  L_ANDROID="🤖 Android:"
  L_SDK="🧩 SDK:"
  L_MODEL="🏷️ Model:"
  L_BRAND="🏭 Manufacturer:"
  L_SERIAL="🔢 Serial number:"
  L_SOC="🧠 CPU / SoC:"
  L_RAM="💾 RAM:"
  L_DISPLAY="🖥️ Display:"
  L_KERNEL="🐧 Kernel (mobile):"
  L_BATTERY="🔋 Battery:"
  L_STORAGE="💽 Storage:"
  L_LOCALE="🌍 Region / Locale:"
  L_TZ="🕒 Timezone:"
  L_BOOT="🔒 OEM / Bootloader:"
  L_IMEI1="📶 IMEI 1:"
  L_IMEI2="📶 IMEI 2:"
  L_OPERATOR="📡 SIM Operator:"
  L_WIFI_SSID="📶 WiFi SSID:"
  L_WIFI_IP="🌐 Local IP:"
  L_BT_VER="🔵 Bluetooth:"
  L_SEC_PATCH="🛡️ Android Patch:"
  L_BUILD_DATE="📅 Build date:"
  L_PLAY_PATCH="🔐 Google Play Patch:"
  L_BOOT_LOCKED="LOCKED"
  L_BOOT_UNLOCKED="UNLOCKED"
  L_BAT_CHARGING="Charging"
  L_BAT_DISCHARGING="Discharging"
  L_BAT_NOT_CHARGING="Not charging"
  L_BAT_FULL="Full"
  L_BAT_UNKNOWN="Unknown"
  L_BAT_HEALTH="Health"
  L_BAT_CYCLES="cycles"
  L_BAT_USED="used"
  L_BAT_FREE="free"
  L_IMEI2_NA="Not available / Single SIM"
  L_IMEI_NA="Not accessible"
  L_OPERATOR_NA="Not detected"
  L_WIFI_NA="Not connected / Not available"
  L_BT_NA="Not available"
  L_NA="N/A"
  L_ADB_NOT_FOUND="❌ Cannot find adb at"
  L_ADB_INSTALL="   Install with:"
  L_ADB_ENV="   Or use: ADB=/path/to/adb ./ADB-Info.sh"
  L_ADB_NO_DEVICE="❌ No ADB device connected or authorized."
  L_ADB_CHECK="   Check: adb devices"
fi

# ====== Helpers ======

adb_ok() {
  [[ -x "$ADB" ]] || return 1
  "$ADB" get-state 2>/dev/null | grep -q "^device$"
}

get_prop() {
  "$ADB" shell getprop "$1" 2>/dev/null | tr -d '\r'
}

print_prop() {
  local val
  val="$(get_prop "$1")"
  if [[ -z "$val" ]]; then
    echo -e "${C_NA}${L_NA}${C_RESET}"
  else
    echo -e "${C_VALUE}${val}${C_RESET}"
  fi
}

adb_shell() {
  "$ADB" shell "$@" 2>/dev/null | tr -d '\r'
}

# $1=label $2=value $3=fallback $4=color_override
print_line() {
  local label="$1" value="$2" fallback="${3:-${L_NA}}" color="${4:-${C_VALUE}}"
  echo -ne "${C_LABEL}${label}${C_RESET} "
  if [[ -z "$value" ]]; then
    echo -e "${C_NA}${fallback}${C_RESET}"
  else
    echo -e "${color}${value}${C_RESET}"
  fi
}

print_section() {
  echo -e "\n${C_TITLE}----[ ${1} ]----${C_RESET}"
}

# ====== Pre-flight ======
if [[ ! -x "$ADB" ]]; then
  echo -e "${C_WARN}${L_ADB_NOT_FOUND} '${ADB}'.${C_RESET}"
  echo -e "${C_WARN}${L_ADB_INSTALL}${C_RESET}"
  echo -e "${C_WARN}   sudo dnf install android-tools   (Fedora)${C_RESET}"
  echo -e "${C_WARN}   sudo apt install adb              (Debian/Ubuntu)${C_RESET}"
  echo -e "${C_WARN}   sudo pacman -S android-tools      (Arch)${C_RESET}"
  echo -e "${C_WARN}${L_ADB_ENV}${C_RESET}"
  exit 1
fi

"$ADB" start-server &>/dev/null

if ! adb_ok; then
  echo -e "${C_WARN}${L_ADB_NO_DEVICE}${C_RESET}"
  echo -e "${C_WARN}${L_ADB_CHECK}${C_RESET}"
  exit 1
fi

# ====== Recopilar datos ======

SERIAL="$("$ADB" get-serialno 2>/dev/null | tr -d '\r')"
MANUFACTURER="$(get_prop ro.product.manufacturer | tr '[:upper:]' '[:lower:]')"
MODEL="$(get_prop ro.product.model)"
MANUFACTURER_DISPLAY="$(get_prop ro.product.manufacturer)"

# --- Bootloader / OEM ---
VB_STATE="$(get_prop ro.boot.vbmeta.device_state)"
FLASH_LOCK="$(get_prop ro.boot.flash.locked)"
if [[ "$VB_STATE" == "unlocked" || "$FLASH_LOCK" == "0" ]]; then
  BOOTLOADER_STATE="$L_BOOT_UNLOCKED"
else
  BOOTLOADER_STATE="$L_BOOT_LOCKED"
fi

# --- IMEI (dual SIM) ---
IMEI1="$(adb_shell service call iphonesubinfo 1 s16 com.android.shell \
  | awk -F"'" '{print $2}' | tr -d '.[:space:]')"
IMEI2="$(adb_shell service call iphonesubinfo 4 i32 1 s16 com.android.shell \
  | awk -F"'" '{print $2}' | tr -d '.[:space:]')"

# --- Operador SIM ---
OPERATOR="$(get_prop gsm.operator.alpha | sed 's/[[:space:],]*$//')"
OPERATOR_NUM="$(get_prop gsm.operator.numeric | cut -d',' -f1 | sed 's/[[:space:],]*$//')"

# --- RAM: tamaño, tipo, fabricante ---
DDR_RAW="$(get_prop ro.boot.hardware.ddr)"
DDR_SIZE_PROP="$(get_prop ro.boot.ddr_size | tr -d '[:space:]')"

RAM_GIB=""; DDR_VENDOR=""; DDR_TYPE=""
[[ -n "$DDR_SIZE_PROP" ]] && RAM_GIB="$DDR_SIZE_PROP"

if [[ -n "$DDR_RAW" && "$DDR_RAW" == *","* ]]; then
  IFS=',' read -r f1 f2 f3 _ <<< "$DDR_RAW"
  f1="$(echo "$f1" | xargs)"; f2="$(echo "$f2" | xargs)"; f3="$(echo "$f3" | xargs)"
  [[ -z "$RAM_GIB" && -n "$f1" ]] && RAM_GIB="$f1"
  [[ -n "$f2" ]] && DDR_VENDOR="$f2"
  [[ -n "$f3" ]] && DDR_TYPE="$f3"
fi

# --- RAM: uso en tiempo real ---
RAM_TOTAL_KB="$(adb_shell cat /proc/meminfo | awk '/MemTotal/{print $2}')"
RAM_FREE_KB="$(adb_shell  cat /proc/meminfo | awk '/MemAvailable/{print $2}')"

RAM_USAGE_STR=""; RAM_PERC_VAL=0
if [[ -n "$RAM_TOTAL_KB" && -n "$RAM_FREE_KB" && "$RAM_TOTAL_KB" -gt 0 ]]; then
  RAM_USED_KB=$(( RAM_TOTAL_KB - RAM_FREE_KB ))
  RAM_USED_MB=$(( RAM_USED_KB / 1024 ))
  RAM_TOTAL_MB=$(( RAM_TOTAL_KB / 1024 ))
  RAM_PERC_VAL=$(( RAM_USED_KB * 100 / RAM_TOTAL_KB ))
  RAM_USAGE_STR="${RAM_USED_MB}MB/${RAM_TOTAL_MB}MB (${RAM_PERC_VAL}%)"
fi

# Color del % de uso de RAM
RAM_PERC_COLOR="$C_GREEN"
(( RAM_PERC_VAL >= 85 )) && RAM_PERC_COLOR="$C_RED"
(( RAM_PERC_VAL >= 70 && RAM_PERC_VAL < 85 )) && RAM_PERC_COLOR="$C_YELLOW"

# --- Kernel ---
KERNEL_MOBILE="$(adb_shell uname -r)"

# --- Almacenamiento / Storage ---
STORAGE_OFFICIAL="$(get_prop ro.boot.hardware.ufs | cut -d',' -f1)"

STORAGE_TOTAL_SAMSUNG=""
if [[ "$MANUFACTURER" == "samsung" ]]; then
  STORAGE_TOTAL_SAMSUNG="$(adb_shell df /data | awk 'NR>1{printf "%.0fGB", $2/1024/1024; exit}')"
fi

DATA_INFO="$(adb_shell df -h /data | awk 'NR>1{line=$0} END{print line}')"
DATA_USED="$(awk '{print $3}' <<< "$DATA_INFO")"
DATA_AVAIL="$(awk '{print $4}' <<< "$DATA_INFO")"
DATA_PERC_RAW="$(awk '{print $5}' <<< "$DATA_INFO" | tr -d '%')"

# Color solo del porcentaje de almacenamiento
STORAGE_PERC_COLOR="$C_GREEN"
if [[ -n "$DATA_PERC_RAW" ]]; then
  (( DATA_PERC_RAW >= 86 )) && STORAGE_PERC_COLOR="$C_RED"
  (( DATA_PERC_RAW >= 70 && DATA_PERC_RAW < 86 )) && STORAGE_PERC_COLOR="$C_YELLOW"
fi

# --- Batería / Battery ---
BATTERY_DUMPSYS="$(adb_shell dumpsys battery)"

BAT_LEVEL="$(awk -F': ' '/^\s*level:/{print $2; exit}' <<< "$BATTERY_DUMPSYS")"
BAT_LEVEL_INT="${BAT_LEVEL:-0}"

BAT_STATUS_CODE="$(awk -F': ' '/^\s*status:/{print $2; exit}' <<< "$BATTERY_DUMPSYS")"
case "$BAT_STATUS_CODE" in
  2) BAT_STATUS="$L_BAT_CHARGING"     ;;
  3) BAT_STATUS="$L_BAT_DISCHARGING"  ;;
  4) BAT_STATUS="$L_BAT_NOT_CHARGING" ;;
  5) BAT_STATUS="$L_BAT_FULL"         ;;
  *) BAT_STATUS="$L_BAT_UNKNOWN"      ;;
esac

BAT_TEMP_RAW="$(awk -F': ' '/^\s*temperature:/{print $2; exit}' <<< "$BATTERY_DUMPSYS")"
BAT_TEMP="${L_NA}"; BAT_TEMP_DEG=0
if [[ -n "$BAT_TEMP_RAW" ]]; then
  BAT_TEMP="$(awk -v t="$BAT_TEMP_RAW" 'BEGIN{printf "%.1f°C", t/10}')"
  BAT_TEMP_DEG="$(awk -v t="$BAT_TEMP_RAW" 'BEGIN{printf "%.0f", t/10}')"
fi

CHARGE_FULL="$(adb_shell cat /sys/class/power_supply/battery/charge_full)"
CHARGE_DESIGN="$(adb_shell cat /sys/class/power_supply/battery/charge_full_design)"
CYCLE_COUNT="$(adb_shell cat /sys/class/power_supply/battery/cycle_count)"
[[ -z "$CYCLE_COUNT" ]] && CYCLE_COUNT="${L_NA}"

BAT_HEALTH_REAL="${L_NA}"; BAT_HEALTH_DETAIL=""; BAT_HEALTH_INT=0
if [[ -n "$CHARGE_FULL" && -n "$CHARGE_DESIGN" && "$CHARGE_DESIGN" != "0" ]]; then
  BAT_HEALTH_INT="$(awk -v f="$CHARGE_FULL" -v d="$CHARGE_DESIGN" \
    'BEGIN{printf "%.0f", (f/d)*100}')"
  BAT_HEALTH_REAL="${BAT_HEALTH_INT}%"
  FULL_MAH="$(awk -v x="$CHARGE_FULL"  'BEGIN{printf "%.0f", x/1000}')"
  DES_MAH="$(awk -v x="$CHARGE_DESIGN" 'BEGIN{printf "%.0f", x/1000}')"
  BAT_HEALTH_DETAIL=" (${FULL_MAH}/${DES_MAH} mAh)"
fi

# Colores de batería — solo el % del nivel
BAT_LEVEL_COLOR="$C_GREEN"
(( BAT_LEVEL_INT <= 15 )) && BAT_LEVEL_COLOR="$C_RED"
(( BAT_LEVEL_INT > 15 && BAT_LEVEL_INT <= 30 )) && BAT_LEVEL_COLOR="$C_YELLOW"

# Color de salud de batería
BAT_HEALTH_COLOR="$C_GREEN"
(( BAT_HEALTH_INT < 80 )) && BAT_HEALTH_COLOR="$C_RED"
(( BAT_HEALTH_INT >= 80 && BAT_HEALTH_INT < 90 )) && BAT_HEALTH_COLOR="$C_YELLOW"

# Color temperatura batería: rojo solo si >45ºC
BAT_TEMP_COLOR="$C_VALUE"
(( BAT_TEMP_DEG > 45 )) && BAT_TEMP_COLOR="$C_RED"

# --- Pantalla / Display ---
SCREEN_RES="$(adb_shell wm size    | head -n1 | awk -F': ' '{print $2}')"
SCREEN_DPI="$(adb_shell wm density | head -n1 | awk -F': ' '{print $2}')"

# Tipo de pantalla: intentar desde getprop (disponible en algunos fabricantes)
DISPLAY_TYPE="$(get_prop ro.display.type 2>/dev/null)"
# Fallback: buscar en dumpsys display o SurfaceFlinger
if [[ -z "$DISPLAY_TYPE" ]]; then
  DISPLAY_TYPE="$(adb_shell dumpsys SurfaceFlinger \
    | grep -iE '(AMOLED|OLED|LCD|LTPO|LTPS|IPS|TFT)' \
    | grep -oiE '(LTPO AMOLED|LTPO OLED|AMOLED|POLED|OLED|IPS LCD|TFT LCD|LTPS|LCD)' \
    | head -n1)"
fi
# Fallback 2: desde ro.hardware o build description
if [[ -z "$DISPLAY_TYPE" ]]; then
  DISPLAY_TYPE="$(get_prop ro.build.description \
    | grep -oiE '(amoled|oled|lcd)' | head -n1 | tr '[:lower:]' '[:upper:]')"
fi

# --- WiFi: SSID + IP ---
WIFI_SSID="$(adb_shell dumpsys wifi \
  | grep -m1 'SSID' \
  | grep -oP 'SSID: *\K[^,]+' \
  | sed 's/^"//;s/"$//' | xargs)"
[[ -z "$WIFI_SSID" || "$WIFI_SSID" == "<unknown ssid>" ]] && WIFI_SSID=""

WIFI_IP="$(adb_shell ip -4 addr show wlan0 \
  | grep -oP '(?<=inet )\d+\.\d+\.\d+\.\d+')"

# --- Bluetooth ---
BT_DUMPSYS="$(adb_shell dumpsys bluetooth_manager)"
BT_HCI_RAW="$(echo "$BT_DUMPSYS" \
  | grep -iE 'hci_version' \
  | grep -oP '0x[0-9a-fA-F]+' | head -n1)"

BT_VERSION=""
if [[ -n "$BT_HCI_RAW" ]]; then
  BT_HCI_DEC="$(printf '%d' "$BT_HCI_RAW" 2>/dev/null)"
  case "$BT_HCI_DEC" in
    14) BT_VERSION="6.0" ;;
    13) BT_VERSION="5.4" ;;
    12) BT_VERSION="5.3" ;;
    11) BT_VERSION="5.2" ;;
    10) BT_VERSION="5.1" ;;
     9) BT_VERSION="5.0" ;;
     8) BT_VERSION="4.2" ;;
     7) BT_VERSION="4.1" ;;
     6) BT_VERSION="4.0" ;;
  esac
fi
[[ -z "$BT_VERSION" ]] && BT_VERSION="$(get_prop bluetooth.core.le.version)"
[[ -n "$BT_VERSION" ]] && BT_LINE="Bluetooth ${BT_VERSION}" || BT_LINE=""

# --- Parches de seguridad ---
SEC_PATCH="$(get_prop ro.build.version.security_patch)"
PLAY_PATCH="$(get_prop ro.build.version.security_patch_google)"
if [[ -z "$PLAY_PATCH" ]]; then
  PLAY_PATCH="$(adb_shell dumpsys package com.google.android.gms \
    | grep -oP '(?<=versionName=)[\d.]+' | head -n1)"
fi

BUILD_DATE="$(get_prop ro.build.date | sed 's/  / /g' | xargs)"

# ====== Output ======
clear
echo -e "${C_TITLE}${L_TITLE}${C_RESET}"
echo -e "${C_TITLE}${L_SEP}${C_RESET}"

# ── Dispositivo / Device ──
print_section "$L_SEC_DEVICE"
echo -ne "${C_LABEL}${L_ANDROID}${C_RESET} "; print_prop ro.build.version.release
echo -ne "${C_LABEL}${L_SDK}${C_RESET} ";      print_prop ro.build.version.sdk
# Modelo y fabricante en amarillo
print_line "$L_MODEL"  "$MODEL"               "$L_NA" "$C_YELLOW"
print_line "$L_BRAND"  "$MANUFACTURER_DISPLAY" "$L_NA" "$C_YELLOW"
print_line "$L_SERIAL" "$SERIAL"
echo -ne "${C_LABEL}${L_SOC}${C_RESET} "; print_prop ro.soc.model

# ── Pantalla / Display ──
print_section "$L_SEC_DISPLAY"
DISPLAY_LINE=""
[[ -n "$SCREEN_RES" && -n "$SCREEN_DPI" ]] && DISPLAY_LINE="${SCREEN_RES} · ${SCREEN_DPI}dpi"
[[ -n "$DISPLAY_TYPE" ]] && DISPLAY_LINE+=" · ${DISPLAY_TYPE}"
print_line "$L_DISPLAY" "$DISPLAY_LINE"

# ── Rendimiento / Performance ──
print_section "$L_SEC_PERF"

# RAM: tamaño en amarillo · tipo y vendor en blanco · uso con color por %
echo -ne "${C_LABEL}${L_RAM}${C_RESET} "
if [[ -z "$RAM_GIB" ]]; then
  echo -e "${C_NA}${L_NA}${C_RESET}"
else
  # Tamaño en amarillo
  echo -ne "${C_YELLOW}${RAM_GIB}${C_RESET}"
  # Tipo y vendor en blanco si existen
  [[ -n "$DDR_TYPE"   ]] && echo -ne "${C_VALUE} · ${DDR_TYPE}${C_RESET}"
  [[ -n "$DDR_VENDOR" ]] && echo -ne "${C_VALUE} · ${DDR_VENDOR}${C_RESET}"
  # Uso en tiempo real con color en el %
  if [[ -n "$RAM_USAGE_STR" ]]; then
    # Mostrar "MB/MB" en blanco y solo el "(X%)" con color
    RAM_NO_PERC="${RAM_USED_MB}MB/${RAM_TOTAL_MB}MB"
    echo -ne "${C_VALUE} · ${RAM_NO_PERC} (${C_RESET}${RAM_PERC_COLOR}${RAM_PERC_VAL}%${C_RESET}${C_VALUE})${C_RESET}"
  fi
  echo ""
fi

print_line "$L_KERNEL" "$KERNEL_MOBILE"

# ── Batería / Battery ──
print_section "$L_SEC_BATTERY"
if [[ -n "$BAT_LEVEL" ]]; then
  # Solo el % en color, el resto en blanco, health con su color, temp con su color
  echo -ne "${C_LABEL}${L_BATTERY}${C_RESET} "
  echo -ne "${BAT_LEVEL_COLOR}${BAT_LEVEL}%${C_RESET}"
  echo -ne "${C_VALUE} · ${BAT_STATUS}${C_RESET}"
  echo -ne "${C_VALUE} · ${C_RESET}${BAT_TEMP_COLOR}${BAT_TEMP}${C_RESET}"
  echo -ne "${C_VALUE} · ${L_BAT_HEALTH} ${C_RESET}${BAT_HEALTH_COLOR}${BAT_HEALTH_REAL}${BAT_HEALTH_DETAIL}${C_RESET}"
  echo -e  "${C_VALUE} · ${CYCLE_COUNT} ${L_BAT_CYCLES}${C_RESET}"
else
  print_line "$L_BATTERY" ""
fi

# ── Almacenamiento / Storage ──
print_section "$L_SEC_STORAGE"
# Solo el porcentaje en color, el resto en blanco
echo -ne "${C_LABEL}${L_STORAGE}${C_RESET} "
if [[ -n "$STORAGE_TOTAL_SAMSUNG" ]]; then
  echo -ne "${C_VALUE}${STORAGE_TOTAL_SAMSUNG} (${DATA_USED} ${L_BAT_USED} · ${DATA_AVAIL} ${L_BAT_FREE} · ${C_RESET}"
elif [[ -n "$STORAGE_OFFICIAL" ]]; then
  echo -ne "${C_VALUE}${STORAGE_OFFICIAL} (${DATA_USED} ${L_BAT_USED} · ${DATA_AVAIL} ${L_BAT_FREE} · ${C_RESET}"
else
  echo -ne "${C_VALUE}${DATA_USED} ${L_BAT_USED} · ${DATA_AVAIL} ${L_BAT_FREE} · ${C_RESET}"
fi
echo -e "${STORAGE_PERC_COLOR}${DATA_PERC_RAW}%${C_RESET}${C_VALUE})${C_RESET}"

# ── Sistema / System ──
print_section "$L_SEC_SYSTEM"
echo -ne "${C_LABEL}${L_LOCALE}${C_RESET} "; print_prop persist.sys.locale
echo -ne "${C_LABEL}${L_TZ}${C_RESET} ";     print_prop persist.sys.timezone
print_line "$L_BOOT" "$BOOTLOADER_STATE"

# ── Seguridad / Security ──
print_section "$L_SEC_SECURITY"
print_line "$L_SEC_PATCH"  "$SEC_PATCH"
print_line "$L_PLAY_PATCH" "$PLAY_PATCH"
print_line "$L_BUILD_DATE" "$BUILD_DATE"

# ── Conectividad / Connectivity ──
print_section "$L_SEC_NETWORK"
print_line "$L_WIFI_SSID" "$WIFI_SSID" "$L_WIFI_NA"
print_line "$L_WIFI_IP"   "$WIFI_IP"   "$L_WIFI_NA"
# Bluetooth en azul
print_line "$L_BT_VER"    "$BT_LINE"   "$L_BT_NA" "$C_BLUE"

# ── SIM ──
print_section "$L_SEC_SIM"
# IMEI en amarillo
echo -ne "${C_LABEL}${L_IMEI1}${C_RESET} "
if [[ -z "$IMEI1" ]]; then
  echo -e "${C_NA}${L_IMEI_NA}${C_RESET}"
else
  echo -e "${C_YELLOW}${IMEI1}${C_RESET}"
fi

echo -ne "${C_LABEL}${L_IMEI2}${C_RESET} "
if [[ -z "$IMEI2" ]]; then
  echo -e "${C_NA}${L_IMEI2_NA}${C_RESET}"
else
  echo -e "${C_YELLOW}${IMEI2}${C_RESET}"
fi

if [[ -z "${OPERATOR// }" ]]; then
  echo -e "${C_LABEL}${L_OPERATOR}${C_RESET} ${C_NA}${L_OPERATOR_NA}${C_RESET}"
else
  echo -e "${C_LABEL}${L_OPERATOR}${C_RESET} ${C_VALUE}${OPERATOR} (${OPERATOR_NUM})${C_RESET}"
fi

echo ""
