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

**ADB-Device-Info** is a tool that connects to an Android device via ADB and displays detailed system information in a clean, colorized, fastfetch-inspired format — directly from your terminal.

Available for **Linux/macOS** (Bash) and **Windows** (PowerShell 7+).

No app installation needed on the device. Just ADB, a USB cable (or wireless ADB), and this script.

> ℹ️ At startup, the script asks you whether you want the output in **English or Spanish**.

### 📋 What it shows

The output is organized in **sections** for easy reading:

| Section | Fields |
|---|---|
| 📱 **Device** | Android version · SDK · Model · Manufacturer · Serial · SoC |
| 🖥️ **Display** | Resolution · DPI · Panel type (AMOLED, OLED, LCD…) |
| ⚡ **Performance** | RAM (size · type · vendor) · RAM usage · Kernel |
| 🔋 **Battery** | Level · Status · Temperature · Health · Cycles |
| 💽 **Storage** | Total · Used · Free · Usage % |
| 🌍 **System** | Locale · Timezone · Bootloader state |
| 🛡️ **Security** | Android security patch · Google Play patch · Build date |
| 🌐 **Connectivity** | WiFi SSID · Local IP · Bluetooth version |
| 📡 **SIM** | IMEI 1 · IMEI 2 · Operator |

**Smart color indicators:**

| Field | Green | Yellow | Red |
|---|---|---|---|
| 🔋 Battery level | ≥ 31% | ≤ 30% | ≤ 15% |
| 🔋 Battery health | ≥ 90% | 80–89% | < 80% |
| 🌡️ Temperature | — | — | > 45°C |
| 💽 Storage | < 70% used | 70–85% used | ≥ 86% used |
| 💾 RAM usage | < 70% used | 70–84% used | ≥ 85% used |

### ⚙️ Requirements

#### 🐧 Linux / macOS
- Linux or macOS (tested on Fedora; should work on any distro)
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

#### 🪟 Windows
- PowerShell 7+ — [download here](https://github.com/PowerShell/PowerShell/releases)
- ADB from [platform-tools](https://developer.android.com/tools/releases/platform-tools)
- USB debugging enabled on the Android device
- Device authorized (accepted the ADB prompt on the phone)

### 🚀 Installation & Usage

#### 🐧 Linux / macOS

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

#### 🪟 Windows (PowerShell 7+)

```powershell
# Clone the repository
git clone https://github.com/Zereniti/ADB-Device-Info.git
cd ADB-Device-Info

# Unblock the script after downloading (one time only)
Unblock-File .\ADB-Info.ps1

# Connect your phone via USB with USB debugging enabled, then run:
.\ADB-Info.ps1
```

> **Why `Unblock-File`?**  
> Windows marks files downloaded from the internet as untrusted and blocks unsigned scripts.  
> `Unblock-File` removes that flag from this specific file without changing any system policy.

> **Tip:** If ADB is not in your PATH, you can override it with an environment variable:
> ```powershell
> $env:ADB = "C:\platform-tools\adb.exe"
> .\ADB-Info.ps1
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

- **IMEI retrieval** may fail on Android 10+ due to permission restrictions. This is a platform limitation, not a bug.
- **Battery health** depends on the device exposing sysfs nodes — not all manufacturers do.
- **Storage total** is only auto-detected on Samsung devices and Qualcomm-based devices that expose `ro.boot.hardware.ufs`. On other devices, only used/free/% are shown.
- **RAM type and vendor** are only available on devices that expose `ro.boot.hardware.ddr` — if not available, they are simply omitted.
- **Bluetooth version** depends on the manufacturer exposing HCI info via `dumpsys`. May show `Not available` on some devices.
- **WiFi SSID** may show as not connected if location permissions are restricted at system level.
- **Google Play patch** is available on Android 10+ with GMS. May return a GMS version string instead of a date on some devices.
- **Display type** detection relies on `dumpsys SurfaceFlinger` or build properties — may not be available on all devices.
- Tested primarily on **Qualcomm** and **Samsung Exynos** devices.

### 📄 License

MIT — see [LICENSE](LICENSE)

---

## 🇪🇸 Español

### ¿Qué es esto?

**ADB-Device-Info** es una herramienta que se conecta a un dispositivo Android vía ADB y muestra información detallada del sistema en un formato limpio y colorizado al estilo de fastfetch, directamente desde tu terminal.

Disponible para **Linux/macOS** (Bash) y **Windows** (PowerShell 7+).

No necesitas instalar nada en el móvil. Solo ADB, un cable USB (o ADB inalámbrico) y este script.

> ℹ️ Al arrancar, el script te pregunta si quieres ver la información en **inglés o español**.

### 📋 Qué muestra

La salida está organizada en **secciones** para facilitar la lectura:

| Sección | Campos |
|---|---|
| 📱 **Dispositivo** | Versión Android · SDK · Modelo · Fabricante · Serie · SoC |
| 🖥️ **Pantalla** | Resolución · DPI · Tipo de panel (AMOLED, OLED, LCD…) |
| ⚡ **Rendimiento** | RAM (tamaño · tipo · fabricante) · Uso de RAM · Kernel |
| 🔋 **Batería** | Nivel · Estado · Temperatura · Salud · Ciclos |
| 💽 **Almacenamiento** | Total · Usado · Libre · % de uso |
| 🌍 **Sistema** | Locale · Zona horaria · Estado del bootloader |
| 🛡️ **Seguridad** | Parche Android · Parche Google Play · Fecha de build |
| 🌐 **Conectividad** | SSID WiFi · IP local · Versión Bluetooth |
| 📡 **SIM** | IMEI 1 · IMEI 2 · Operador |

**Indicadores de color inteligentes:**

| Campo | Verde | Amarillo | Rojo |
|---|---|---|---|
| 🔋 Nivel batería | ≥ 31% | ≤ 30% | ≤ 15% |
| 🔋 Salud batería | ≥ 90% | 80–89% | < 80% |
| 🌡️ Temperatura | — | — | > 45°C |
| 💽 Almacenamiento | < 70% usado | 70–85% usado | ≥ 86% usado |
| 💾 Uso de RAM | < 70% usado | 70–84% usado | ≥ 85% usado |

### ⚙️ Requisitos

#### 🐧 Linux / macOS
- Linux o macOS (probado en Fedora; debería funcionar en cualquier distro)
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

#### 🪟 Windows
- PowerShell 7+ — [descarga aquí](https://github.com/PowerShell/PowerShell/releases)
- ADB desde [platform-tools](https://developer.android.com/tools/releases/platform-tools)
- Depuración USB activada en el dispositivo Android
- Dispositivo autorizado (haber aceptado el prompt ADB en el móvil)

### 🚀 Instalación y uso

#### 🐧 Linux / macOS

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

#### 🪟 Windows (PowerShell 7+)

```powershell
# Clona el repositorio
git clone https://github.com/Zereniti/ADB-Device-Info.git
cd ADB-Device-Info

# Desbloquea el script tras descargarlo (solo la primera vez)
Unblock-File .\ADB-Info.ps1

# Conecta tu móvil por USB con la depuración USB activada y ejecuta:
.\ADB-Info.ps1
```

> **¿Por qué `Unblock-File`?**  
> Windows marca los archivos descargados de internet como no confiables y bloquea los scripts sin firma.  
> `Unblock-File` elimina esa marca solo de este archivo, sin modificar ninguna política del sistema.

> **Truco:** Si ADB no está en el PATH, puedes indicar la ruta con una variable de entorno:
> ```powershell
> $env:ADB = "C:\platform-tools\adb.exe"
> .\ADB-Info.ps1
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

- **La lectura del IMEI** puede fallar en Android 10+ por restricciones de permisos. Es una limitación de la plataforma, no un bug.
- **La salud de la batería** depende de que el fabricante exponga los nodos sysfs — no todos lo hacen.
- **El total de almacenamiento** solo se detecta automáticamente en Samsung y en dispositivos Qualcomm que exponen `ro.boot.hardware.ufs`. En otros dispositivos, solo se muestran usado/libre/%.
- **El tipo y fabricante de RAM** solo están disponibles en dispositivos que exponen `ro.boot.hardware.ddr` — si no están disponibles, simplemente se omiten.
- **La versión de Bluetooth** depende de que el fabricante exponga la info HCI vía `dumpsys`. Puede mostrar `No disponible` en algunos dispositivos.
- **El SSID WiFi** puede aparecer como no conectado si los permisos de ubicación están restringidos a nivel de sistema.
- **El parche de Google Play** está disponible en Android 10+ con GMS. En algunos dispositivos puede devolver una cadena de versión de GMS en vez de una fecha.
- **El tipo de pantalla** se detecta mediante `dumpsys SurfaceFlinger` o propiedades de build — puede no estar disponible en todos los dispositivos.
- Probado principalmente en dispositivos **Qualcomm** y **Samsung Exynos**.

### 📄 Licencia

MIT — ver [LICENSE](LICENSE)

---

*Made with ❤️ by [Zerenity](https://github.com/Zerenity)*
