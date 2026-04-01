# Author: Zerenity
# License: MIT

#!/usr/bin/env bash

# ====== Config ======
ADB="/usr/bin/adb"

# ====== Colores ANSI ======
C_TITLE="\033[1;36m"
C_LABEL="\033[1;32m"
C_VALUE="\033[0;37m"
C_WARN="\033[1;33m"
C_RESET="\033[0m"

# ====== Helpers ======
adb_ok() {
  [[ -x "$ADB" ]] || return 1
  "$ADB" get-state 1>/dev/null 2>&1
}

# Devuelve una propiedad getprop desde Android (sin \r)
get_prop() {
  "$ADB" shell getprop "$1" 2>/dev/null | tr -d '\r'
}

# Imprime propiedad con el estilo de fastfetch
print_prop() {
  local VAL
  VAL="$(get_prop "$1")"
  if [[ -z "$VAL" ]]; then
    echo -e "${C_WARN}N/A${C_RESET}"
  else
    echo -e "${C_VALUE}$VAL${C_RESET}"
  fi
}

# Ejecuta comando dentro del móvil (sin \r)
adb_shell() {
  "$ADB" shell "$@" 2>/dev/null | tr -d '\r'
}

# ====== Pre-flight ======
if [[ ! -x "$ADB" ]]; then
  echo -e "${C_WARN}❌ No encuentro adb en $ADB. Instala: sudo dnf install android-tools${C_RESET}"
  exit 1
fi

# (Opcional) Silenciar el mensaje del daemon en fastfetch
"$ADB" start-server 1>/dev/null 2>&1

if ! adb_ok; then
  echo -e "${C_WARN}❌ No hay dispositivo ADB conectado/autorizado (comprueba 'adb devices').${C_RESET}"
  exit 1
fi

# ====== Datos host-side (ADB) ======
SERIAL="$("$ADB" get-serialno 2>/dev/null | tr -d '\r')"

# ====== Bootloader / OEM ======
VB_STATE="$(get_prop ro.boot.vbmeta.device_state)"
FLASH_LOCK="$(get_prop ro.boot.flash.locked)"

BOOTLOADER_STATE="BLOQUEADO"
if [[ "$VB_STATE" == "unlocked" || "$FLASH_LOCK" == "0" ]]; then
  BOOTLOADER_STATE="DESBLOQUEADO"
fi

# ====== IMEI (dual SIM compatible) ======
IMEI1="$(adb_shell service call iphonesubinfo 1 s16 com.android.shell | awk -F "'" '{print $2}' | tr -d '.[:space:]')"
IMEI2="$(adb_shell service call iphonesubinfo 4 i32 1 s16 com.android.shell | awk -F "'" '{print $2}' | tr -d '.[:space:]')"

# ====== Operador SIM ======
OPERATOR_RAW="$(get_prop gsm.operator.alpha)"
OPERATOR_NUM_RAW="$(get_prop gsm.operator.numeric)"

# Limpiar coma/espacios finales: "DIGI ES," -> "DIGI ES"
OPERATOR="$(echo "$OPERATOR_RAW" | sed 's/[[:space:],]*$//')"

# Puede venir como lista "21407," o "21407,21401"
OPERATOR_NUM="$(echo "$OPERATOR_NUM_RAW" | cut -d',' -f1 | sed 's/[[:space:],]*$//')"


# ====== RAM (Total + tipo + fabricante) ======
DDR_RAW="$(get_prop ro.boot.hardware.ddr)"     # 12GiB,Samsung,LPDDR5,0109
DDR_SIZE_PROP="$(get_prop ro.boot.ddr_size)"   # 12GiB

# Normalizar
DDR_RAW="$(echo "$DDR_RAW" | tr -d '\r')"
DDR_SIZE_PROP="$(echo "$DDR_SIZE_PROP" | tr -d '\r' | sed 's/[[:space:]]//g')"

# Defaults
RAM_GIB="N/A"
DDR_VENDOR="N/A"
DDR_TYPE="N/A"

# Tamaño: preferir ro.boot.ddr_size; si no, usar el campo 1 del DDR_RAW
if [[ -n "$DDR_SIZE_PROP" ]]; then
  RAM_GIB="$DDR_SIZE_PROP"
fi

# Parse exacto del formato REAL: size,vendor,type,code
# 12GiB,Samsung,LPDDR5,0109
if [[ -n "$DDR_RAW" && "$DDR_RAW" == *","* ]]; then
  F1="$(echo "$DDR_RAW" | cut -d',' -f1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
  F2="$(echo "$DDR_RAW" | cut -d',' -f2 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
  F3="$(echo "$DDR_RAW" | cut -d',' -f3 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

  [[ "$RAM_GIB" == "N/A" && -n "$F1" ]] && RAM_GIB="$F1"
  [[ -n "$F2" ]] && DDR_VENDOR="$F2"
  [[ -n "$F3" ]] && DDR_TYPE="$F3"
fi

# ORDEN EXACTO que quieres:
RAM_LINE="${RAM_GIB} · ${DDR_TYPE} · ${DDR_VENDOR}"


# ====== Kernel (móvil) ======
KERNEL_MOBILE="$(adb_shell uname -r)"

# ====== Almacenamiento (oficial + uso real) ======
# Capacidad oficial (ej: "128GB,Samsung" -> "128GB")
STORAGE_OFFICIAL="$(get_prop ro.boot.hardware.ufs | awk -F',' '{print $1}')"
[[ -z "$STORAGE_OFFICIAL" ]] && STORAGE_OFFICIAL="N/A"

# Uso real de /data (dm-crypt/particiones dinámicas -> total real distinto, pero usamos solo usado/libre/%)
DATA_INFO="$(adb_shell df -h /data | tail -n 1)"
DATA_USED="$(echo "$DATA_INFO" | awk '{print $3}')"
DATA_AVAIL="$(echo "$DATA_INFO" | awk '{print $4}')"
DATA_PERC="$(echo "$DATA_INFO" | awk '{print $5}')"

# ====== Batería (pro: % + estado + temp + salud real + ciclos) ======
BATTERY_DUMPSYS="$(adb_shell dumpsys battery)"

# Nivel (%)
BAT_LEVEL="$(echo "$BATTERY_DUMPSYS" | awk -F': ' '/level:/ {print $2; exit}')"

# Estado (status: 2=charging, 3=discharging, 4=not charging, 5=full)
BAT_STATUS_CODE="$(echo "$BATTERY_DUMPSYS" | awk -F': ' '/status:/ {print $2; exit}')"
case "$BAT_STATUS_CODE" in
  2) BAT_STATUS="Cargando" ;;
  3) BAT_STATUS="Descargando" ;;
  4) BAT_STATUS="No cargando" ;;
  5) BAT_STATUS="Completa" ;;
  *) BAT_STATUS="Desconocido" ;;
esac

# Temperatura (décimas de ºC)
BAT_TEMP_RAW="$(echo "$BATTERY_DUMPSYS" | awk -F': ' '/temperature:/ {print $2; exit}')"
BAT_TEMP="N/A"
if [[ -n "$BAT_TEMP_RAW" ]]; then
  BAT_TEMP="$(awk -v t="$BAT_TEMP_RAW" 'BEGIN{printf "%.1f°C", t/10}')"
fi

# Salud REAL desde sysfs (si existe)
# Nota: normalmente está en µAh -> /1000 = mAh
CHARGE_FULL="$(adb_shell cat /sys/class/power_supply/battery/charge_full 2>/dev/null)"
CHARGE_DESIGN="$(adb_shell cat /sys/class/power_supply/battery/charge_full_design 2>/dev/null)"
CYCLE_COUNT="$(adb_shell cat /sys/class/power_supply/battery/cycle_count 2>/dev/null)"

BAT_HEALTH_REAL="N/A"
BAT_HEALTH_DETAIL=""

if [[ -n "$CHARGE_FULL" && -n "$CHARGE_DESIGN" && "$CHARGE_DESIGN" != "0" ]]; then
  BAT_HEALTH_REAL="$(awk -v f="$CHARGE_FULL" -v d="$CHARGE_DESIGN" 'BEGIN{printf "%.0f%%", (f/d)*100}')"
  FULL_MAH="$(awk -v x="$CHARGE_FULL" 'BEGIN{printf "%.0f", x/1000}')"
  DES_MAH="$(awk -v x="$CHARGE_DESIGN" 'BEGIN{printf "%.0f", x/1000}')"
  BAT_HEALTH_DETAIL=" (${FULL_MAH}/${DES_MAH} mAh)"
fi

# Limpiar ciclo si viene vacío
[[ -z "$CYCLE_COUNT" ]] && CYCLE_COUNT="N/A"


# ====== Pantalla ======
WM_SIZE_RAW="$(adb_shell wm size | head -n 1)"
WM_DENS_RAW="$(adb_shell wm density | head -n 1)"

# Extrae números:
# "Physical size: 1080x2424" -> 1080x2424
SCREEN_RES="$(echo "$WM_SIZE_RAW" | awk -F': ' '{print $2}' | tr -d '\r')"
# "Physical density: 420" -> 420
SCREEN_DPI="$(echo "$WM_DENS_RAW" | awk -F': ' '{print $2}' | tr -d '\r')"

# Colores ANSI
GREEN="\e[32m"
RESET="\e[0m"

print_android_ascii() {
    echo -e "${GREEN}"
    cat << "EOF"
⠀⠀⠀⠀⢀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠙⢷⣤⣤⣴⣶⣶⣦⣤⣤⡾⠋⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀
⠀⠀⠀⠀⣼⣿⣿⣉⣹⣿⣿⣿⣿⣏⣉⣿⣿⣧⠀⠀⠀⠀
⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀
⣠⣄⠀⢠⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⡄⠀⣠⣄
⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⣿⣿
⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⣿⣿
⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⣿⣿
⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⣿⣿
⠻⠟⠁⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠈⠻⠟
⠀⠀⠀⠀⠉⠉⣿⣿⣿⡏⠉⠉⢹⣿⣿⣿⠉⠉⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⣿⣿⣿⡇⠀⠀⢸⣿⣿⣿⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⣿⣿⣿⡇⠀⠀⢸⣿⣿⣿⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠈⠉⠉⠀⠀⠀⠀⠉⠉⠁⠀⠀⠀⠀⠀⠀
EOF
    echo -e "${RESET}"
}

# ====== Output ======
clear
#print_android_ascii
echo -e "${C_TITLE}📱 Android Fastfetch (ADB)${C_RESET}"
echo -e "${C_TITLE}--------------------------${C_RESET}"

echo -ne "${C_LABEL}🤖 Android:${C_RESET} "; print_prop ro.build.version.release
echo -ne "${C_LABEL}🧩 SDK:${C_RESET} "; print_prop ro.build.version.sdk
echo -ne "${C_LABEL}🏷️ Modelo:${C_RESET} "; print_prop ro.product.model
echo -ne "${C_LABEL}🏭 Fabricante:${C_RESET} "; print_prop ro.product.manufacturer
echo -ne "${C_LABEL}🔢 Nº de serie:${C_RESET} "; echo -e "${C_VALUE}${SERIAL:-N/A}${C_RESET}"

echo -ne "${C_LABEL}🧠 CPU / SoC:${C_RESET} "; print_prop ro.soc.model
echo -ne "${C_LABEL}💾 RAM:${C_RESET} "; echo -e "${C_VALUE}${RAM_LINE}${C_RESET}"

echo -ne "${C_LABEL}🖥️ Pantalla:${C_RESET} "
if [[ -z "$SCREEN_RES" || -z "$SCREEN_DPI" ]]; then
  echo -e "${C_WARN}N/A${C_RESET}"
else
  echo -e "${C_VALUE}${SCREEN_RES} · ${SCREEN_DPI}dpi${C_RESET}"
fi


echo -ne "${C_LABEL}🐧 Kernel (móvil):${C_RESET} "
if [[ -z "$KERNEL_MOBILE" ]]; then
  echo -e "${C_WARN}N/A${C_RESET}"
else
  echo -e "${C_VALUE}${KERNEL_MOBILE}${C_RESET}"
fi

echo -ne "${C_LABEL}🔋 Batería:${C_RESET} "
if [[ -z "$BAT_LEVEL" ]]; then
  echo -e "${C_WARN}N/A${C_RESET}"
else
  # Ejemplo: 64% · Cargando · 33.8°C · Salud 92% (4800/5200 mAh) · 120 ciclos
  echo -e "${C_VALUE}${BAT_LEVEL}% · ${BAT_STATUS} · ${BAT_TEMP} · Salud ${BAT_HEALTH_REAL}${BAT_HEALTH_DETAIL} · ${CYCLE_COUNT} ciclos${C_RESET}"
fi

echo -ne "${C_LABEL}💽 Almacenamiento:${C_RESET} "
echo -e "${C_VALUE}${STORAGE_OFFICIAL} (${DATA_USED} usados · ${DATA_AVAIL} libres · ${DATA_PERC})${C_RESET}"

echo -ne "${C_LABEL}🌍 Región / Locale:${C_RESET} "; print_prop persist.sys.locale
echo -ne "${C_LABEL}🕒 Zona horaria:${C_RESET} "; print_prop persist.sys.timezone

echo -ne "${C_LABEL}🔒 OEM / Bootloader:${C_RESET} "; echo -e "${C_VALUE}${BOOTLOADER_STATE}${C_RESET}"

echo -ne "${C_LABEL}📶 IMEI 1:${C_RESET} "
if [[ -z "$IMEI1" ]]; then
  echo -e "${C_WARN}No accesible${C_RESET}"
else
  echo -e "${C_VALUE}${IMEI1}${C_RESET}"
fi

echo -ne "${C_LABEL}📶 IMEI 2:${C_RESET} "
if [[ -z "$IMEI2" ]]; then
  echo -e "${C_WARN}No disponible / SIM única${C_RESET}"
else
  echo -e "${C_VALUE}${IMEI2}${C_RESET}"
fi

if [[ -z "${OPERATOR// }" ]]; then
  echo -e "${C_LABEL}📡 Operador SIM:${C_RESET} ${C_WARN}No detectado${C_RESET}"
else
  echo -e "${C_LABEL}📡 Operador SIM:${C_RESET} ${C_VALUE}${OPERATOR} (${OPERATOR_NUM})${C_RESET}"
fi
