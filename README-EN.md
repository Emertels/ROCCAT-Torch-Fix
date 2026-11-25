# 🎙️ ROCCAT Torch Fix (Windows 10 & 11) — Mute Lock Fix

<div align="center">

**🌐 Idiomas / Languages:**  
  <a href="README.md"><img src="https://img.shields.io/badge/Documenta%C3%A7%C3%A3o-Principal-lightgrey?style=for-the-badge" alt="Principal"></a>
  <a href="README-PT-BR.md"><img src="https://img.shields.io/badge/Documenta%C3%A7%C3%A3o-Portugu%C3%AAs%20(Brasil)-green?style=for-the-badge" alt="PT-BR"></a>
  <a href="README-EN.md"><img src="https://img.shields.io/badge/Documentation-English-blue?style=for-the-badge" alt="EN"></a>
  <a href="MANUAL-EN.md"><img src="https://img.shields.io/badge/Manual-EN-darkblue?style=for-the-badge" alt="Manual EN"></a>

<br/>

[![Release](https://img.shields.io/badge/Release-v1.0.0-blue.svg)](https://github.com/Emertels/ROCCAT-Torch-Fix/releases)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B%20%7C%207%2B-blue.svg)](https://microsoft.com/powershell)
[![Windows](https://img.shields.io/badge/OS-Windows%2010%20%2F%2011-0078D6.svg)](https://www.microsoft.com/windows)
[![i18n](https://img.shields.io/badge/i18n-Auto--Detect%20(PT--BR%20%7C%20EN)-success.svg)](#-automatic-bilingual-support)
[![License](https://img.shields.io/badge/License-MIT-brightgreen.svg)](LICENSE)

</div>

---

Automated, lightweight solution in **PowerShell** and native **C# CoreAudio API** developed by **Emerson Teles** (with technical analytical assistance from **Gemini**) to definitively fix the chronic mute lock problem (**solid red LED**, physical **DISABLED** indicator, and non-responsive gesture sensor or buttons) affecting the **ROCCAT Torch** USB microphone on Windows 10 and Windows 11.

---

## 🛑 The Chronic Problem: What happens in practice?

Many owners of the **ROCCAT Torch** encounter a sudden freeze where:
- The microphone's dynamic RGB lighting shuts off and the body turns **solid red**.
- On the physical mixer base, the status indicator shows **DISABLED / MUTE**.
- **The top contactless gesture sensor and physical buttons stop responding**, making it impossible to unmute by touch or wave.
- Unplugging and replugging the USB cable, restarting the computer, or uninstalling **ROCCAT Swarm** fails to resolve the lockup.

Previously, the only temporary workaround was manually uninstalling the driver in Windows Device Manager and rebooting, but the issue invariably returned days later.

---

## 🔬 The Root Cause and the Fix with Gemini's Assistance

After repeatedly suffering from this issue and investigating it thoroughly with analytical support from **Gemini**, the exact root cause was discovered:

1. **Bidirectional Hardware Mute Synchronization (Hardware Mute Sync):** The ROCCAT Torch features direct system-level volume and mute synchronization (`IAudioEndpointVolume`).
2. **Involuntary Trigger:** Ambient room light, shadows, or software shortcuts trigger a mute event.
3. **Bus Deadlock (Freeze):** Windows saves the muted state into the audio endpoint registry (`Mute = True`). The microphone enters system-muted state, locks hardware controls, and awaits a formal un-mute packet from Windows.
4. **Registry Persistence:** Even when replugged or rebooted, Windows restores the previous endpoint state (`Mute = True`), re-locking the microphone in solid red.

### 💡 The Definitive Solution
The script directly interfaces with the **Windows CoreAudio MMDevice API** at a low level, locates the active **ROCCAT Torch** endpoint, and dispatches a direct `SetMute(false)` command down to the hardware. Windows sends the USB release packet, immediately unlocking the firmware, re-enabling the physical base, and restoring dynamic RGB lighting.

---

## ✨ Key Features

- **🌐 Automatic Language Detection (PT-BR & EN):** Automatically identifies the user's Windows operating system language. Defaults to Portuguese on PT-BR/PT systems and English on all others.
- **⚡ Instant Unlock:** Restores audio capture in less than 2 seconds without requiring reboots or unplugging cables.
- **🚀 2 Convenient Ways to Run:** Includes both the `Unlock-Torch-Microphone.ps1` PowerShell script and a 2-click `.bat` launcher.
- **🛡️ 100% Safe and Non-Invasive:** Does not alter system drivers, requires no permanent background software, and does not require administrator privileges.

---

## 📥 How to Download and Use

### 📦 Ready-to-Use Portable Package (Recommended)
1. Download **`ROCCAT-Torch-Fix-v1.0.0-Portable.zip`** from the [Releases](https://github.com/Emertels/ROCCAT-Torch-Fix/releases) tab.
2. Extract the archive into any folder or directly to your Desktop.
3. Whenever the microphone gets stuck in red:
   - **Double-click** `Unlock-Torch-Microphone.bat`; **OR**
   - Right-click `Unlock-Torch-Microphone.ps1` and select **"Run with PowerShell"**.
4. The microphone will immediately unlock and resume normal operation!

---

## 🛡️ Tips to Prevent Future Lockups

1. **Disable the rear gesture sensor:**  
   On the back of the microphone base, locate the **GESTURE MUTE** switch. If you do not actively use hand-wave muting, switch it to **OFF** to eliminate false triggers caused by shadows or overhead lighting.
2. **Disable Exclusive Mode in Windows:**  
   Press `Win + R`, type `mmsys.cpl`, and press Enter. In the **Recording** tab, double-click the Torch microphone > **Advanced** tab > uncheck *"Allow applications to take exclusive control of this device"*.

---

## 📂 Repository Structure

```text
ROCCAT-Torch-Fix/
├── Unlock-Torch-Microphone.bat  # 2-click quick launcher for Windows
├── Unlock-Torch-Microphone.ps1  # Bilingual PowerShell script with native C# CoreAudio
├── README.md                    # Main project presentation
├── README-PT-BR.md              # Full documentation in Portuguese
├── README-EN.md                 # Full documentation in English
├── MANUAL.md                    # User and diagnostic manual (PT-BR)
├── MANUAL-EN.md                 # User and diagnostic manual (EN)
├── AGENTS.md                    # Technical guidelines for AI agents & devs (PT-BR)
├── AGENTS_EN.md                 # Technical guidelines for AI agents & devs (EN)
├── LICENSE                      # MIT open-source license
└── .gitignore                   # Git repository filters
```

---

## 📄 License

Distributed under the **MIT** license. See the [LICENSE](LICENSE) file for more information.

---

## 👨‍💻 About the Author

Developed and maintained by **Emerson Teles** (known in the community as **Emertels**).

Tech enthusiast, developer, and passionate system maintainer focused on practical tools, productivity utilities, smart PowerShell automation, and system fixes for the community.

### 🛠️ Projects & Contributions

- [AI-Chat-Vault](https://github.com/Emertels/AI-Chat-Vault) — Portable backup and local conversation recovery for 20+ AI tools and assistants.
- [Antigravity — Tradução PT-BR](https://github.com/Emertels/Antigravity-Traducao-PTBR) — Complete localization of Google Antigravity Desktop into Brazilian Portuguese.
- [Codex Router — Tradução PT-BR](https://github.com/Emertels/CodexRouter-Traducao-PTBR) — PT-BR translation and localization package for Codex Router Control Center.
- [Cursor AI — Tradução PT-BR](https://github.com/Emertels/Cursor-Traducao-PTBR) — Complete deep localization of Cursor AI into Brazilian Portuguese.
- [GPU Tweak III — Tradução PT-BR](https://github.com/Emertels/GPU-Tweak-III-Traducao-PTBR) — Brazilian Portuguese translation and automated installer for ASUS GPU Tweak III.
- [Microsoft Photos Fix](https://github.com/Emertels/Microsoft-Photos-Fix) — Advanced PowerShell and C# fix for fast startup and wallpaper application in Windows Photos.
- [PSBBN-Translator](https://github.com/Emertels/PSBBN-Translator) — Corporate translation and localization suite for the PSBBN Definitive Project (PS2) across 40 languages.
- [ROCCAT Torch Fix](https://github.com/Emertels/ROCCAT-Torch-Fix) — Definitive unlocker for ROCCAT Torch microphones stuck on mute and red LED.
- [Silent Hill: Homecoming — Tradução PT-BR](https://github.com/Emertels/Silent-Hill-Homecoming-Traducao-PTBR) — Complete PC translation and revision in Brazilian Portuguese.
- [Suite-Emuladores](https://github.com/Emertels/Suite-Emuladores) — Autonomous PowerShell suite for downloading and updating 56 emulators on Windows.
- [ZCode — Tradução PT-BR](https://github.com/Emertels/ZCode-Traducao-PTBR) — Complete translation and localization package for ZCode Desktop in PT-BR.

### 🌐 Connect with Me & Official Communities

<div align="left">

[![GitHub](https://img.shields.io/badge/GitHub-Emertels-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/emertels)
[![Website](https://img.shields.io/badge/Website-Emerson_Teles-0070F3?style=for-the-badge&logo=googlechrome&logoColor=white)](https://emertels.github.io)
[![Discord](https://img.shields.io/badge/Discord-Emertels%20Server-5865F2?style=for-the-badge&logo=discord&logoColor=white)](https://emertels.github.io/discord)
[![X / Twitter](https://img.shields.io/badge/X_Twitter-@emertels-000000?style=for-the-badge&logo=x&logoColor=white)](https://x.com/emertels)
[![YouTube](https://img.shields.io/badge/YouTube-Emerson_Teles-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/@emersonteles2379)
[![Telegram](https://img.shields.io/badge/Telegram-Aplicativos%20Mods-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/apksmodsandroid)
[![Ko-fi](https://img.shields.io/badge/Ko--fi-Support%20Project-FF5E5B?style=for-the-badge&logo=kofi&logoColor=white)](https://ko-fi.com/emertels)

</div>
