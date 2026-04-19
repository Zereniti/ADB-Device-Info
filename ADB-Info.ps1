#Requires -Version 7.0
# Author: Zerenity
# License: MIT
# Project: https://github.com/Zereniti/ADB-Device-Info

# ====== Config ======
$ADB = $env:ADB
if (-not $ADB) { $ADB = "adb" }   # Change to full path if needed, e.g. "C:\platform-tools\adb.exe"

# ====== ANSI Colors ======
$C_TITLE  = "`e[1;36m"
$C_LABEL  = "`e[1;32m"
$C_VALUE  = "`e[1;33m"   # Yellow for all standard value text
$C_WARN   = "`e[1;33m"
$C_RED    = "`e[1;31m"
$C_GREEN  = "`e[1;32m"
$C_YELLOW = "`e[1;33m"
$C_BLUE   = "`e[1;34m"
$C_NA     = "`e[0;90m"
$C_RESET  = "`e[0m"

# ====== Language selection ======
Clear-Host
Write-Host "${C_TITLE}📱 ADB-Device-Info${C_RESET}"
Write-Host "${C_TITLE}------------------${C_RESET}"
Write-Host ""
Write-Host "${C_VALUE}Select language / Selecciona idioma:${C_RESET}"
Write-Host "  ${C_LABEL}[1]${C_RESET} English"
Write-Host "  ${C_LABEL}[2]${C_RESET} Español"
Write-Host ""
$LANG_CHOICE = Read-Host "  >"
$LANG_ES = ($LANG_CHOICE -eq "2")

# ====== Localized labels ======
if ($LANG_ES) {
  $L_TITLE         = "📱 Información del dispositivo Android (ADB)"
  $L_SEP           = "--------------------------------------------"
  $L_SEC_DEVICE    = "Dispositivo"
  $L_SEC_DISPLAY   = "Pantalla"
  $L_SEC_PERF      = "Rendimiento"
  $L_SEC_BATTERY   = "Batería"
  $L_SEC_STORAGE   = "Almacenamiento"
  $L_SEC_SYSTEM    = "Sistema"
  $L_SEC_SECURITY  = "Seguridad"
  $L_SEC_NETWORK   = "Conectividad"
  $L_SEC_SIM       = "SIM"
  $L_ANDROID       = "🤖 Android:"
  $L_SDK           = "🧩 SDK:"
  $L_MODEL         = "🏷️ Modelo:"
  $L_BRAND         = "🏭 Fabricante:"
  $L_SERIAL        = "🔢 Nº de serie:"
  $L_SOC           = "🧠 CPU / SoC:"
  $L_RAM           = "💾 RAM:"
  $L_DISPLAY       = "🖥️ Pantalla:"
  $L_KERNEL        = "🐧 Kernel (móvil):"
  $L_BATTERY       = "🔋 Batería:"
  $L_STORAGE       = "💽 Almacenamiento:"
  $L_LOCALE        = "🌍 Región / Locale:"
  $L_TZ            = "🕒 Zona horaria:"
  $L_BOOT          = "🔒 OEM / Bootloader:"
  $L_IMEI1         = "📶 IMEI 1:"
  $L_IMEI2         = "📶 IMEI 2:"
  $L_OPERATOR      = "📡 Operador SIM:"
  $L_WIFI_SSID     = "📶 WiFi SSID:"
  $L_WIFI_IP       = "🌐 IP local:"
  $L_BT_VER        = "🔵 Bluetooth:"
  $L_SEC_PATCH     = "🛡️ Parche Android:"
  $L_BUILD_DATE    = "📅 Fecha de build:"
  $L_PLAY_PATCH    = "🔐 Parche Google Play:"
  $L_BOOT_LOCKED   = "BLOQUEADO"
  $L_BOOT_UNLOCKED = "DESBLOQUEADO"
  $L_BAT_CHARGING     = "Cargando"
  $L_BAT_DISCHARGING  = "Descargando"
  $L_BAT_NOT_CHARGING = "No cargando"
  $L_BAT_FULL         = "Completa"
  $L_BAT_UNKNOWN      = "Desconocido"
  $L_BAT_HEALTH    = "Salud"
  $L_BAT_CYCLES    = "ciclos"
  $L_BAT_USED      = "usados"
  $L_BAT_FREE      = "libres"
  $L_IMEI2_NA      = "No disponible / SIM única"
  $L_IMEI_NA       = "No accesible"
  $L_OPERATOR_NA   = "No detectado"
  $L_WIFI_NA       = "No conectado / No disponible"
  $L_BT_NA         = "No disponible"
  $L_NA            = "N/A"
  $L_ADB_NOT_FOUND = "❌ No encuentro adb en"
  $L_ADB_NO_DEVICE = "❌ No hay dispositivo ADB conectado o autorizado."
  $L_ADB_CHECK     = "   Comprueba: adb devices"
} else {
  $L_TITLE         = "📱 Android Device Info (ADB)"
  $L_SEP           = "----------------------------"
  $L_SEC_DEVICE    = "Device"
  $L_SEC_DISPLAY   = "Display"
  $L_SEC_PERF      = "Performance"
  $L_SEC_BATTERY   = "Battery"
  $L_SEC_STORAGE   = "Storage"
  $L_SEC_SYSTEM    = "System"
  $L_SEC_SECURITY  = "Security"
  $L_SEC_NETWORK   = "Connectivity"
  $L_SEC_SIM       = "SIM"
  $L_ANDROID       = "🤖 Android:"
  $L_SDK           = "🧩 SDK:"
  $L_MODEL         = "🏷️ Model:"
  $L_BRAND         = "🏭 Manufacturer:"
  $L_SERIAL        = "🔢 Serial number:"
  $L_SOC           = "🧠 CPU / SoC:"
  $L_RAM           = "💾 RAM:"
  $L_DISPLAY       = "🖥️ Display:"
  $L_KERNEL        = "🐧 Kernel (mobile):"
  $L_BATTERY       = "🔋 Battery:"
  $L_STORAGE       = "💽 Storage:"
  $L_LOCALE        = "🌍 Region / Locale:"
  $L_TZ            = "🕒 Timezone:"
  $L_BOOT          = "🔒 OEM / Bootloader:"
  $L_IMEI1         = "📶 IMEI 1:"
  $L_IMEI2         = "📶 IMEI 2:"
  $L_OPERATOR      = "📡 SIM Operator:"
  $L_WIFI_SSID     = "📶 WiFi SSID:"
  $L_WIFI_IP       = "🌐 Local IP:"
  $L_BT_VER        = "🔵 Bluetooth:"
  $L_SEC_PATCH     = "🛡️ Android Patch:"
  $L_BUILD_DATE    = "📅 Build date:"
  $L_PLAY_PATCH    = "🔐 Google Play Patch:"
  $L_BOOT_LOCKED   = "LOCKED"
  $L_BOOT_UNLOCKED = "UNLOCKED"
  $L_BAT_CHARGING     = "Charging"
  $L_BAT_DISCHARGING  = "Discharging"
  $L_BAT_NOT_CHARGING = "Not charging"
  $L_BAT_FULL         = "Full"
  $L_BAT_UNKNOWN      = "Unknown"
  $L_BAT_HEALTH    = "Health"
  $L_BAT_CYCLES    = "cycles"
  $L_BAT_USED      = "used"
  $L_BAT_FREE      = "free"
  $L_IMEI2_NA      = "Not available / Single SIM"
  $L_IMEI_NA       = "Not accessible"
  $L_OPERATOR_NA   = "Not detected"
  $L_WIFI_NA       = "Not connected / Not available"
  $L_BT_NA         = "Not available"
  $L_NA            = "N/A"
  $L_ADB_NOT_FOUND = "❌ Cannot find adb at"
  $L_ADB_NO_DEVICE = "❌ No ADB device connected or authorized."
  $L_ADB_CHECK     = "   Check: adb devices"
}

# ====== Helpers ======
function Get-Prop {
  param([string]$Prop)
  & $ADB shell getprop $Prop 2>$null | ForEach-Object { $_ -replace "`r","" }
}

function Print-Prop {
  param([string]$Prop)
  $val = Get-Prop $Prop
  if ([string]::IsNullOrWhiteSpace($val)) {
    Write-Host "${C_NA}${L_NA}${C_RESET}"
  } else {
    Write-Host "${C_VALUE}${val}${C_RESET}"
  }
}

function Invoke-ADBShell {
  param([string]$Command)
  & $ADB shell $Command 2>$null | ForEach-Object { $_ -replace "`r","" }
}

function Print-Line {
  param(
    [string]$Label,
    [string]$Value,
    [string]$Fallback = "",
    [string]$Color = $C_VALUE
  )
  if ([string]::IsNullOrWhiteSpace($Fallback)) { $Fallback = $L_NA }
  Write-Host -NoNewline "${C_LABEL}${Label}${C_RESET} "
  if ([string]::IsNullOrWhiteSpace($Value)) {
    Write-Host "${C_NA}${Fallback}${C_RESET}"
  } else {
    Write-Host "${Color}${Value}${C_RESET}"
  }
}

function Print-Section {
  param([string]$Title)
  $line = "----[ ${Title} ]----"
  Write-Host "`n${C_TITLE}${line}${C_RESET}"
}

# ====== Pre-flight ======
$adbCmd = Get-Command $ADB -ErrorAction SilentlyContinue
if (-not $adbCmd) {
  Write-Host "${C_WARN}${L_ADB_NOT_FOUND} '${ADB}'.${C_RESET}"
  Write-Host "${C_WARN}   Install: https://developer.android.com/tools/releases/platform-tools${C_RESET}"
  exit 1
}

& $ADB start-server 2>$null | Out-Null

$deviceState = (& $ADB get-state 2>$null) -replace "`r",""
if ($deviceState -ne "device") {
  Write-Host "${C_WARN}${L_ADB_NO_DEVICE}${C_RESET}"
  Write-Host "${C_WARN}${L_ADB_CHECK}${C_RESET}"
  exit 1
}

# ====== Collect data ======

$SERIAL               = (& $ADB get-serialno 2>$null) -replace "`r",""
$MANUFACTURER         = (Get-Prop "ro.product.manufacturer").ToLower()
$MODEL                = Get-Prop "ro.product.model"
$MANUFACTURER_DISPLAY = Get-Prop "ro.product.manufacturer"

# --- Bootloader ---
$VB_STATE   = Get-Prop "ro.boot.vbmeta.device_state"
$FLASH_LOCK = Get-Prop "ro.boot.flash.locked"
if ($VB_STATE -eq "unlocked" -or $FLASH_LOCK -eq "0") {
  $BOOTLOADER_STATE = $L_BOOT_UNLOCKED
} else {
  $BOOTLOADER_STATE = $L_BOOT_LOCKED
}

# --- IMEI ---
function Parse-IMEI {
  param([string[]]$Lines)
  $combined = ($Lines | Where-Object { $_ -match "'" } |
    ForEach-Object { ($_ -split "'")[1] }) -join ""
  return ($combined -replace "[.\s]", "")
}

$imei1Raw = & $ADB shell "service call iphonesubinfo 1 s16 com.android.shell" 2>$null | ForEach-Object { $_ -replace "`r","" }
$imei2Raw = & $ADB shell "service call iphonesubinfo 4 i32 1 s16 com.android.shell" 2>$null | ForEach-Object { $_ -replace "`r","" }
$IMEI1 = Parse-IMEI $imei1Raw
$IMEI2 = Parse-IMEI $imei2Raw

# --- SIM Operator ---
$OPERATOR     = (Get-Prop "gsm.operator.alpha") -replace "[,\s]+$",""
$OPERATOR_NUM = ((Get-Prop "gsm.operator.numeric") -split ",")[0] -replace "[,\s]+$",""

# --- RAM: size, type, vendor ---
$DDR_RAW       = Get-Prop "ro.boot.hardware.ddr"
$DDR_SIZE_PROP = (Get-Prop "ro.boot.ddr_size") -replace "\s",""

$RAM_GIB = ""; $DDR_VENDOR = ""; $DDR_TYPE = ""
if (-not [string]::IsNullOrWhiteSpace($DDR_SIZE_PROP)) { $RAM_GIB = $DDR_SIZE_PROP }

if (-not [string]::IsNullOrWhiteSpace($DDR_RAW) -and $DDR_RAW -match ",") {
  $fields = $DDR_RAW -split ","
  $F1 = $fields[0].Trim()
  $F2 = if ($fields.Count -ge 2) { $fields[1].Trim() } else { "" }
  $F3 = if ($fields.Count -ge 3) { $fields[2].Trim() } else { "" }
  if ([string]::IsNullOrWhiteSpace($RAM_GIB) -and $F1) { $RAM_GIB    = $F1 }
  if ($F2) { $DDR_VENDOR = $F2 }
  if ($F3) { $DDR_TYPE   = $F3 }
}

# --- RAM: real-time usage ---
$memInfo      = Invoke-ADBShell "cat /proc/meminfo"
$RAM_TOTAL_KB = [int](($memInfo | Where-Object { $_ -match "^MemTotal:" }     | Select-Object -First 1) -replace "[^\d]","")
$RAM_FREE_KB  = [int](($memInfo | Where-Object { $_ -match "^MemAvailable:" } | Select-Object -First 1) -replace "[^\d]","")

$RAM_USAGE_STR = ""; $RAM_PERC_VAL = 0; $RAM_USED_MB = 0; $RAM_TOTAL_MB = 0
if ($RAM_TOTAL_KB -gt 0) {
  $RAM_USED_KB  = $RAM_TOTAL_KB - $RAM_FREE_KB
  $RAM_USED_MB  = [math]::Floor($RAM_USED_KB  / 1024)
  $RAM_TOTAL_MB = [math]::Floor($RAM_TOTAL_KB / 1024)
  $RAM_PERC_VAL = [math]::Floor($RAM_USED_KB * 100 / $RAM_TOTAL_KB)
  $RAM_USAGE_STR = "${RAM_USED_MB}MB/${RAM_TOTAL_MB}MB (${RAM_PERC_VAL}%)"
}

$RAM_PERC_COLOR = $C_GREEN
if ($RAM_PERC_VAL -ge 85)     { $RAM_PERC_COLOR = $C_RED }
elseif ($RAM_PERC_VAL -ge 70) { $RAM_PERC_COLOR = $C_YELLOW }

# --- Kernel ---
$KERNEL_MOBILE = Invoke-ADBShell "uname -r"

# --- Storage ---
$STORAGE_OFFICIAL = ((Get-Prop "ro.boot.hardware.ufs") -split ",")[0]

$STORAGE_TOTAL_SAMSUNG = ""
if ($MANUFACTURER -eq "samsung") {
  $dfSamsung = Invoke-ADBShell "df /data"
  $dfLine = ($dfSamsung | Select-Object -Skip 1 | Select-Object -First 1) -split "\s+" | Where-Object { $_ -ne "" }
  if ($dfLine.Count -ge 2) {
    $rawKB = [double]$dfLine[1]
    $STORAGE_TOTAL_SAMSUNG = "{0:F0}GB" -f ($rawKB / 1024 / 1024)
  }
}

$dataInfo    = (Invoke-ADBShell "df -h /data") | Where-Object { $_ -notmatch "^Filesystem" } | Select-Object -Last 1
$dataFields  = ($dataInfo -split "\s+") | Where-Object { $_ -ne "" }
$DATA_USED     = if ($dataFields.Count -ge 3) { $dataFields[2] } else { $L_NA }
$DATA_AVAIL    = if ($dataFields.Count -ge 4) { $dataFields[3] } else { $L_NA }
$DATA_PERC_STR = if ($dataFields.Count -ge 5) { $dataFields[4] } else { "0%" }
$DATA_PERC_RAW = [int](($DATA_PERC_STR -replace "[^\d]",""))

$STORAGE_PERC_COLOR = $C_GREEN
if ($DATA_PERC_RAW -ge 86)     { $STORAGE_PERC_COLOR = $C_RED }
elseif ($DATA_PERC_RAW -ge 70) { $STORAGE_PERC_COLOR = $C_YELLOW }

# --- Battery ---
$BATTERY_DUMPSYS = Invoke-ADBShell "dumpsys battery"

$BAT_LEVEL       = ($BATTERY_DUMPSYS | Where-Object { $_ -match "^\s*level:" }       | Select-Object -First 1) -replace ".*level:\s*",""
$BAT_STATUS_CODE = ($BATTERY_DUMPSYS | Where-Object { $_ -match "^\s*status:" }      | Select-Object -First 1) -replace ".*status:\s*",""
$BAT_LEVEL_INT   = if ($BAT_LEVEL) { [int]$BAT_LEVEL.Trim() } else { 0 }

$BAT_STATUS = switch ($BAT_STATUS_CODE.Trim()) {
  "2" { $L_BAT_CHARGING }
  "3" { $L_BAT_DISCHARGING }
  "4" { $L_BAT_NOT_CHARGING }
  "5" { $L_BAT_FULL }
  default { $L_BAT_UNKNOWN }
}

$BAT_TEMP_RAW = ($BATTERY_DUMPSYS | Where-Object { $_ -match "^\s*temperature:" } | Select-Object -First 1) -replace ".*temperature:\s*",""
$BAT_TEMP = $L_NA; $BAT_TEMP_DEG = 0
if (-not [string]::IsNullOrWhiteSpace($BAT_TEMP_RAW)) {
  $BAT_TEMP_DEG = [math]::Round([double]$BAT_TEMP_RAW.Trim() / 10)
  $BAT_TEMP     = "{0:F1}°C" -f ([double]$BAT_TEMP_RAW.Trim() / 10)
}

$CHARGE_FULL   = Invoke-ADBShell "cat /sys/class/power_supply/battery/charge_full"
$CHARGE_DESIGN = Invoke-ADBShell "cat /sys/class/power_supply/battery/charge_full_design"
$CYCLE_COUNT   = Invoke-ADBShell "cat /sys/class/power_supply/battery/cycle_count"
if ([string]::IsNullOrWhiteSpace($CYCLE_COUNT)) { $CYCLE_COUNT = $L_NA }

$BAT_HEALTH_REAL = $L_NA; $BAT_HEALTH_DETAIL = ""; $BAT_HEALTH_INT = 0
if (-not [string]::IsNullOrWhiteSpace($CHARGE_FULL) -and
    -not [string]::IsNullOrWhiteSpace($CHARGE_DESIGN) -and
    [double]$CHARGE_DESIGN -ne 0) {
  $cf = [double]$CHARGE_FULL; $cd = [double]$CHARGE_DESIGN
  $BAT_HEALTH_INT    = [math]::Round($cf / $cd * 100)
  $BAT_HEALTH_REAL   = "${BAT_HEALTH_INT}%"
  $fullMah           = [math]::Round($cf / 1000)
  $desMah            = [math]::Round($cd / 1000)
  $BAT_HEALTH_DETAIL = " (${fullMah}/${desMah} mAh)"
}

$BAT_LEVEL_COLOR = $C_GREEN
if ($BAT_LEVEL_INT -le 15)     { $BAT_LEVEL_COLOR = $C_RED }
elseif ($BAT_LEVEL_INT -le 30) { $BAT_LEVEL_COLOR = $C_YELLOW }

$BAT_HEALTH_COLOR = $C_GREEN
if ($BAT_HEALTH_INT -lt 80)    { $BAT_HEALTH_COLOR = $C_RED }
elseif ($BAT_HEALTH_INT -lt 90){ $BAT_HEALTH_COLOR = $C_YELLOW }

$BAT_TEMP_COLOR = $C_VALUE
if ($BAT_TEMP_DEG -gt 45)      { $BAT_TEMP_COLOR = $C_RED }

# --- Display ---
$WM_SIZE_RAW = (Invoke-ADBShell "wm size")    | Select-Object -First 1
$WM_DENS_RAW = (Invoke-ADBShell "wm density") | Select-Object -First 1
$SCREEN_RES  = if ($WM_SIZE_RAW -match ":\s*(.+)$") { $Matches[1].Trim() } else { "" }
$SCREEN_DPI  = if ($WM_DENS_RAW -match ":\s*(.+)$") { $Matches[1].Trim() } else { "" }

$DISPLAY_TYPE = Get-Prop "ro.display.type"
if ([string]::IsNullOrWhiteSpace($DISPLAY_TYPE)) {
  $sfDump = Invoke-ADBShell "dumpsys SurfaceFlinger"
  $sfMatch = $sfDump | Select-String -Pattern "(LTPO AMOLED|LTPO OLED|AMOLED|POLED|OLED|IPS LCD|TFT LCD|LTPS|LCD)" -CaseSensitive:$false | Select-Object -First 1
  if ($sfMatch) { $DISPLAY_TYPE = $sfMatch.Matches[0].Groups[1].Value }
}
if ([string]::IsNullOrWhiteSpace($DISPLAY_TYPE)) {
  $buildDesc = Get-Prop "ro.build.description"
  if ($buildDesc -match "(amoled|oled|lcd)") { $DISPLAY_TYPE = $Matches[1].ToUpper() }
}

# --- WiFi ---
$wifiDump  = Invoke-ADBShell "dumpsys wifi"
$WIFI_SSID = ""
$ssidMatch = $wifiDump | Select-String -Pattern 'SSID:\s*"?([^",\s<>]+)"?' | Select-Object -First 1
if ($ssidMatch) {
  $WIFI_SSID = $ssidMatch.Matches[0].Groups[1].Value
  if ($WIFI_SSID -match "^unknown") { $WIFI_SSID = "" }
}

$wlanInfo = Invoke-ADBShell "ip -4 addr show wlan0"
$WIFI_IP  = ""
$ipMatch  = $wlanInfo | Select-String -Pattern "inet\s+(\d+\.\d+\.\d+\.\d+)" | Select-Object -First 1
if ($ipMatch) { $WIFI_IP = $ipMatch.Matches[0].Groups[1].Value }

# --- Bluetooth ---
$BT_DUMPSYS = Invoke-ADBShell "dumpsys bluetooth_manager"
$BT_VERSION = ""
$hciMatch   = $BT_DUMPSYS | Select-String -Pattern "hci_version.*?(0x[0-9a-fA-F]+)" | Select-Object -First 1
if ($hciMatch) {
  $hciHex = $hciMatch.Matches[0].Groups[1].Value
  $hciDec = [convert]::ToInt32($hciHex, 16)
  $BT_VERSION = switch ($hciDec) {
    14 { "6.0" } 13 { "5.4" } 12 { "5.3" } 11 { "5.2" } 10 { "5.1" }
     9 { "5.0" }  8 { "4.2" }  7 { "4.1" }  6 { "4.0" } default { "" }
  }
}
if ([string]::IsNullOrWhiteSpace($BT_VERSION)) { $BT_VERSION = Get-Prop "bluetooth.core.le.version" }
$BT_LINE = if ($BT_VERSION) { "Bluetooth ${BT_VERSION}" } else { "" }

# --- Security patches ---
$SEC_PATCH  = Get-Prop "ro.build.version.security_patch"
$PLAY_PATCH = Get-Prop "ro.build.version.security_patch_google"
if ([string]::IsNullOrWhiteSpace($PLAY_PATCH)) {
  $gmsDump  = Invoke-ADBShell "dumpsys package com.google.android.gms"
  $gmsMatch = $gmsDump | Select-String -Pattern "versionName=([\d.]+)" | Select-Object -First 1
  if ($gmsMatch) { $PLAY_PATCH = $gmsMatch.Matches[0].Groups[1].Value }
}

$BUILD_DATE = (Get-Prop "ro.build.date") -replace "\s+", " "

# ====== Output ======
Clear-Host
Write-Host "${C_TITLE}${L_TITLE}${C_RESET}"
Write-Host "${C_TITLE}${L_SEP}${C_RESET}"

# ── Device ──
Print-Section $L_SEC_DEVICE
Write-Host -NoNewline "${C_LABEL}${L_ANDROID}${C_RESET} "; Print-Prop "ro.build.version.release"
Write-Host -NoNewline "${C_LABEL}${L_SDK}${C_RESET} ";     Print-Prop "ro.build.version.sdk"
Print-Line $L_MODEL  $MODEL                $L_NA $C_YELLOW
Print-Line $L_BRAND  $MANUFACTURER_DISPLAY $L_NA $C_YELLOW
Print-Line $L_SERIAL $SERIAL
Write-Host -NoNewline "${C_LABEL}${L_SOC}${C_RESET} "; Print-Prop "ro.soc.model"

# ── Display ──
Print-Section $L_SEC_DISPLAY
$DISPLAY_LINE = ""
if (-not [string]::IsNullOrWhiteSpace($SCREEN_RES) -and -not [string]::IsNullOrWhiteSpace($SCREEN_DPI)) {
  $DISPLAY_LINE = "${SCREEN_RES} · ${SCREEN_DPI}dpi"
}
if (-not [string]::IsNullOrWhiteSpace($DISPLAY_TYPE)) {
  $DISPLAY_LINE = if ($DISPLAY_LINE) { "${DISPLAY_LINE} · ${DISPLAY_TYPE}" } else { $DISPLAY_TYPE }
}
Print-Line $L_DISPLAY $DISPLAY_LINE

# ── Performance ──
Print-Section $L_SEC_PERF
Write-Host -NoNewline "${C_LABEL}${L_RAM}${C_RESET} "
if ([string]::IsNullOrWhiteSpace($RAM_GIB)) {
  Write-Host "${C_NA}${L_NA}${C_RESET}"
} else {
  Write-Host -NoNewline "${C_YELLOW}${RAM_GIB}${C_RESET}"
  if (-not [string]::IsNullOrWhiteSpace($DDR_TYPE))   { Write-Host -NoNewline "${C_VALUE} · ${DDR_TYPE}${C_RESET}" }
  if (-not [string]::IsNullOrWhiteSpace($DDR_VENDOR)) { Write-Host -NoNewline "${C_VALUE} · ${DDR_VENDOR}${C_RESET}" }
  if (-not [string]::IsNullOrWhiteSpace($RAM_USAGE_STR)) {
    Write-Host -NoNewline "${C_VALUE} · ${RAM_USED_MB}MB/${RAM_TOTAL_MB}MB (${C_RESET}${RAM_PERC_COLOR}${RAM_PERC_VAL}%${C_RESET}${C_VALUE})${C_RESET}"
  }
  Write-Host ""
}
Print-Line $L_KERNEL $KERNEL_MOBILE

# ── Battery ──
Print-Section $L_SEC_BATTERY
if (-not [string]::IsNullOrWhiteSpace($BAT_LEVEL)) {
  Write-Host -NoNewline "${C_LABEL}${L_BATTERY}${C_RESET} "
  Write-Host -NoNewline "${BAT_LEVEL_COLOR}${BAT_LEVEL}%${C_RESET}"
  Write-Host -NoNewline "${C_VALUE} · ${BAT_STATUS}${C_RESET}"
  Write-Host -NoNewline "${C_VALUE} · ${C_RESET}${BAT_TEMP_COLOR}${BAT_TEMP}${C_RESET}"
  Write-Host -NoNewline "${C_VALUE} · ${L_BAT_HEALTH} ${C_RESET}${BAT_HEALTH_COLOR}${BAT_HEALTH_REAL}${BAT_HEALTH_DETAIL}${C_RESET}"
  Write-Host "${C_VALUE} · ${CYCLE_COUNT} ${L_BAT_CYCLES}${C_RESET}"
} else {
  Print-Line $L_BATTERY ""
}

# ── Storage ──
Print-Section $L_SEC_STORAGE
Write-Host -NoNewline "${C_LABEL}${L_STORAGE}${C_RESET} "
$storLabel = if ($STORAGE_TOTAL_SAMSUNG) { $STORAGE_TOTAL_SAMSUNG }
             elseif ($STORAGE_OFFICIAL)  { $STORAGE_OFFICIAL }
             else                        { "" }
if ($storLabel) {
  Write-Host -NoNewline "${C_VALUE}${storLabel} (${DATA_USED} ${L_BAT_USED} · ${DATA_AVAIL} ${L_BAT_FREE} · ${C_RESET}"
} else {
  Write-Host -NoNewline "${C_VALUE}${DATA_USED} ${L_BAT_USED} · ${DATA_AVAIL} ${L_BAT_FREE} · ${C_RESET}"
}
Write-Host "${STORAGE_PERC_COLOR}${DATA_PERC_RAW}%${C_RESET}${C_VALUE})${C_RESET}"

# ── System ──
Print-Section $L_SEC_SYSTEM
Write-Host -NoNewline "${C_LABEL}${L_LOCALE}${C_RESET} "; Print-Prop "persist.sys.locale"
Write-Host -NoNewline "${C_LABEL}${L_TZ}${C_RESET} ";     Print-Prop "persist.sys.timezone"
Print-Line $L_BOOT $BOOTLOADER_STATE

# ── Security ──
Print-Section $L_SEC_SECURITY
Print-Line $L_SEC_PATCH  $SEC_PATCH
Print-Line $L_PLAY_PATCH $PLAY_PATCH
Print-Line $L_BUILD_DATE $BUILD_DATE

# ── Connectivity ──
Print-Section $L_SEC_NETWORK
Print-Line $L_WIFI_SSID $WIFI_SSID $L_WIFI_NA
Print-Line $L_WIFI_IP   $WIFI_IP   $L_WIFI_NA
Print-Line $L_BT_VER    $BT_LINE   $L_BT_NA $C_BLUE

# ── SIM ──
Print-Section $L_SEC_SIM
Write-Host -NoNewline "${C_LABEL}${L_IMEI1}${C_RESET} "
if ([string]::IsNullOrWhiteSpace($IMEI1)) { Write-Host "${C_NA}${L_IMEI_NA}${C_RESET}" }
else                                       { Write-Host "${C_YELLOW}${IMEI1}${C_RESET}" }

Write-Host -NoNewline "${C_LABEL}${L_IMEI2}${C_RESET} "
if ([string]::IsNullOrWhiteSpace($IMEI2)) { Write-Host "${C_NA}${L_IMEI2_NA}${C_RESET}" }
else                                       { Write-Host "${C_YELLOW}${IMEI2}${C_RESET}" }

if ([string]::IsNullOrWhiteSpace($OPERATOR)) {
  Write-Host "${C_LABEL}${L_OPERATOR}${C_RESET} ${C_NA}${L_OPERATOR_NA}${C_RESET}"
} else {
  Write-Host "${C_LABEL}${L_OPERATOR}${C_RESET} ${C_VALUE}${OPERATOR} (${OPERATOR_NUM})${C_RESET}"
}

Write-Host ""