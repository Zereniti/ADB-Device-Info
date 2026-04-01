# 📱 ADB-Device-Info

> **A fastfetch-style device info tool for Android — via ADB**  
> **Una herramienta tipo fastfetch para obtener información detallada de Android — vía ADB**

---

## 🇬🇧 English

### What is this?

**ADB-Device-Info** is a Bash script that connects to an Android device via ADB and displays detailed system information in a clean, colorized, fastfetch-inspired format — directly from your Linux terminal.

No app installation needed on the device. Just ADB, a USB cable (or wireless ADB), and this script.

### 📋 What it shows

| Category | Details |
|---|---|
| 🤖 Android version | OS version + SDK level |
| 🏷️ Device | Model + Manufacturer |
| 🔢 Serial number | Device serial via ADB |
| 🧠 CPU / SoC | System-on-chip model |
| 💾 RAM | Size · Type (LPDDR4/5) · Vendor |
| 🖥️ Display | Resolution · DPI |
| 🐧 Kernel | Mobile kernel version |
| 🔋 Battery | Level · Status · Temp · Health · Cycles |
| 💽 Storage | Official capacity + used/free/% on /data |
| 🌍 Locale / Timezone | System locale + timezone |
| 🔒 Bootloader | Locked / Unlocked state |
| 📶 IMEI | IMEI 1 + IMEI 2 (dual SIM) |
| 📡 SIM Operator | Carrier name + MCC/MNC |

### ⚙️ Requirements

- Linux (tested on Fedora; should work on any distro)
- `adb` installed and in PATH (or at `/usr/bin/adb`)
- USB debugging enabled on the Android device
- Device authorized (accepted the ADB prompt on the phone)

**Install ADB:**
```bash
# Fedora / RHEL
sudo dnf install android-tools

# Debian / Ubuntu
sudo apt install adb

# Arch
sudo pacman -S android-tools
```

### 🚀 Installation & Usage

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/ADB-Device-Info.git
cd ADB-Device-Info

# Make it executable
chmod +x ADB-Info.sh

# Connect your phone via USB with USB debugging enabled, then run:
./ADB-Info.sh
```

> **Tip:** If ADB is not at `/usr/bin/adb`, edit the `ADB=` variable at the top of the script.

### ⚠️ Known limitations

- **IMEI retrieval** may fail on Android 10+ due to permission restrictions introduced in newer API levels. This is a platform limitation, not a bug in the script.
- **Battery health** data (charge_full / charge_full_design) depends on the device exposing sysfs nodes — not all manufacturers do.
- **Storage info** is read from `/data` partition; results may vary on devices with dynamic partitions.
- Tested primarily on **Qualcomm-based** devices. Some properties (SoC model, RAM info) may return `N/A` on other platforms.

### 📄 License

MIT — see [LICENSE](LICENSE)

---

## 🇪🇸 Español

### ¿Qué es esto?

**ADB-Device-Info** es un script Bash que se conecta a un dispositivo Android vía ADB y muestra información detallada del sistema en un formato limpio y colorizado al estilo de fastfetch, directamente desde tu terminal Linux.

No necesitas instalar nada en el móvil. Solo ADB, un cable USB (o ADB inalámbrico) y este script.

### 📋 Qué muestra

| Categoría | Detalles |
|---|---|
| 🤖 Versión de Android | Versión del SO + nivel de SDK |
| 🏷️ Dispositivo | Modelo + Fabricante |
| 🔢 Número de serie | Serial del dispositivo vía ADB |
| 🧠 CPU / SoC | Modelo del System-on-chip |
| 💾 RAM | Tamaño · Tipo (LPDDR4/5) · Fabricante |
| 🖥️ Pantalla | Resolución · DPI |
| 🐧 Kernel | Versión del kernel del móvil |
| 🔋 Batería | Nivel · Estado · Temp · Salud · Ciclos |
| 💽 Almacenamiento | Capacidad oficial + usado/libre/% en /data |
| 🌍 Región / Zona horaria | Locale del sistema + zona horaria |
| 🔒 Bootloader | Estado bloqueado / desbloqueado |
| 📶 IMEI | IMEI 1 + IMEI 2 (dual SIM) |
| 📡 Operador SIM | Nombre del operador + MCC/MNC |

### ⚙️ Requisitos

- Linux (probado en Fedora; debería funcionar en cualquier distro)
- `adb` instalado y en el PATH (o en `/usr/bin/adb`)
- Depuración USB activada en el dispositivo Android
- Dispositivo autorizado (haber aceptado el prompt ADB en el móvil)

**Instalar ADB:**
```bash
# Fedora / RHEL
sudo dnf install android-tools

# Debian / Ubuntu
sudo apt install adb

# Arch
sudo pacman -S android-tools
```

### 🚀 Instalación y uso

```bash
# Clona el repositorio
git clone https://github.com/YOUR_USERNAME/ADB-Device-Info.git
cd ADB-Device-Info

# Dale permisos de ejecución
chmod +x ADB-Info.sh

# Conecta tu móvil por USB con la depuración USB activada y ejecuta:
./ADB-Info.sh
```

> **Truco:** Si ADB no está en `/usr/bin/adb`, edita la variable `ADB=` al principio del script.

### ⚠️ Limitaciones conocidas

- **La lectura del IMEI** puede fallar en Android 10+ por las restricciones de permisos introducidas en versiones recientes de la API. Es una limitación de la plataforma, no un bug del script.
- **La salud real de la batería** (charge_full / charge_full_design) depende de que el fabricante exponga los nodos sysfs correspondientes — no todos lo hacen.
- **La información de almacenamiento** se lee de la partición `/data`; los resultados pueden variar en dispositivos con particiones dinámicas.
- Probado principalmente en dispositivos con **SoC Qualcomm**. Algunas propiedades (modelo del SoC, info de RAM) pueden devolver `N/A` en otras plataformas.

### 📄 Licencia

MIT — ver [LICENSE](LICENSE)

---

*Made with ❤️ by [Zerenity](https://github.com/YOUR_USERNAME)*
