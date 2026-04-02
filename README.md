# 📱 ADB-Device-Info

> **A fastfetch-style device info tool for Android — via ADB**  
> **Una herramienta tipo fastfetch para obtener información detallada de Android — vía ADB**

---

## 📚 Table of Contents / Índice

**🇬🇧 English**
- [What is this?](#what-is-this)
- [What it shows](#-what-it-shows)
- [Requirements](#️-requirements)
- [Installation & Usage](#-installation--usage)
- [Contributing & Improvements](#-contributing--improvements)
- [Known limitations](#️-known-limitations)
- [License](#-license)

**🇪🇸 Español**
- [¿Qué es esto?](#qué-es-esto)
- [Qué muestra](#-qué-muestra)
- [Requisitos](#️-requisitos)
- [Instalación y uso](#-instalación-y-uso)
- [Contribuir y mejoras](#-contribuir-y-mejoras)
- [Limitaciones conocidas](#️-limitaciones-conocidas)
- [Licencia](#-licencia)

---

## 🇬🇧 English

### What is this?

**ADB-Device-Info** is a Bash script that connects to an Android device via ADB and displays detailed system information in a clean, colorized, fastfetch-inspired format — directly from your Linux terminal.

No app installation needed on the device. Just ADB, a USB cable (or wireless ADB), and this script.

> ℹ️ At startup, the script asks you whether you want the output in **English or Spanish**.

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
git clone https://github.com/Zereniti/ADB-Device-Info.git
cd ADB-Device-Info

# Make it executable
chmod +x ADB-Info.sh

# Connect your phone via USB with USB debugging enabled, then run:
./ADB-Info.sh
```

> **Tip:** If ADB is not at `/usr/bin/adb`, you can override it with an environment variable:
> ```bash
> ADB=/path/to/adb ./ADB-Info.sh
> ```

### 🤝 Contributing & Improvements

I'm not sure if I'll keep publishing updates to this project — life gets in the way! That said, I'd love to see this script grow with the community's help.

**If you improve it, fix a bug, or add support for more devices — please share it!**

Here's how:

1. **Fork** this repository
2. Make your changes in your fork
3. Open a **Pull Request** describing what you improved and why
4. I'll review it and, if it looks good, merge it into the main repo

All contributions are welcome: bug fixes, new features, better device compatibility, translations, documentation improvements... everything counts. 🙌

> ⚠️ By opening a Pull Request you agree that your contribution may be merged and redistributed under the same **MIT license** as this project.

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

> ℹ️ Al arrancar, el script te pregunta si quieres ver la información en **inglés o español**.

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
git clone https://github.com/Zereniti/ADB-Device-Info.git
cd ADB-Device-Info

# Dale permisos de ejecución
chmod +x ADB-Info.sh

# Conecta tu móvil por USB con la depuración USB activada y ejecuta:
./ADB-Info.sh
```

> **Truco:** Si ADB no está en `/usr/bin/adb`, puedes indicar la ruta con una variable de entorno:
> ```bash
> ADB=/ruta/a/adb ./ADB-Info.sh
> ```

### 🤝 Contribuir y mejoras

No tengo claro si voy a seguir publicando actualizaciones de este proyecto — ¡la vida da muchas vueltas! Aun así, me encantaría ver cómo crece con la ayuda de la comunidad.

**Si lo mejoras, corriges un bug o añades soporte para más dispositivos — ¡compártelo!**

Así es como puedes hacerlo:

1. Haz un **fork** de este repositorio
2. Aplica tus cambios en tu fork
3. Abre un **Pull Request** explicando qué mejoraste y por qué
4. Lo revisaré y, si está bien, lo fusionaré en el repositorio principal

Todas las contribuciones son bienvenidas: corrección de bugs, nuevas funcionalidades, mejor compatibilidad con dispositivos, traducciones, mejoras en la documentación... todo cuenta. 🙌

> ⚠️ Al abrir un Pull Request aceptas que tu contribución podrá ser fusionada y redistribuida bajo la misma licencia **MIT** de este proyecto.

### ⚠️ Limitaciones conocidas

- **La lectura del IMEI** puede fallar en Android 10+ por las restricciones de permisos introducidas en versiones recientes de la API. Es una limitación de la plataforma, no un bug del script.
- **La salud real de la batería** (charge_full / charge_full_design) depende de que el fabricante exponga los nodos sysfs correspondientes — no todos lo hacen.
- **La información de almacenamiento** se lee de la partición `/data`; los resultados pueden variar en dispositivos con particiones dinámicas.
- Probado principalmente en dispositivos con **SoC Qualcomm**. Algunas propiedades (modelo del SoC, info de RAM) pueden devolver `N/A` en otras plataformas.

### 📄 Licencia

MIT — ver [LICENSE](LICENSE)

---

*Made with ❤️ by [Zerenity](https://github.com/Zereniti)*
