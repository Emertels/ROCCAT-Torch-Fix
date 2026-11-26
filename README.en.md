# 🎙️ ROCCAT Torch Fix

<p align="center">
  <a href="README.md">🇧🇷 Português</a> | <b>🇺🇸 English</b>
</p>

<p align="center">
  <a href="https://github.com/Emertels/ROCCAT-Torch-Fix/releases"><img src="https://img.shields.io/badge/Release-v1.0.0-blue.svg" alt="Release v1.0.0"></a>
  <a href="https://microsoft.com/powershell"><img src="https://img.shields.io/badge/PowerShell-5.1%2B%20%7C%207%2B-blue.svg" alt="PowerShell"></a>
  <a href="https://www.microsoft.com/windows"><img src="https://img.shields.io/badge/OS-Windows%2010%20%2F%2011-0078D6.svg" alt="Windows"></a>
  <img src="https://img.shields.io/badge/i18n-Auto--Detect%20(PT--BR%20%7C%20EN)-success.svg" alt="Languages">
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-brightgreen.svg" alt="MIT License"></a>
</p>

A standalone single-script **PowerShell** and **C# CoreAudio API** utility developed by **Emerson Teles** (with technical assistance from **Gemini**) to permanently solve the chronic mute lock issue (**solid red LED**, physical **DISABLED / MUTE** status, and non-responsive gesture sensor and buttons) affecting the **ROCCAT Torch** USB microphone on Windows 10 and Windows 11.

---

## 📋 Table of Contents

1. [The Chronic Problem](#-the-chronic-problem)
2. [Root Cause & Solution with Gemini Assistance](#-root-cause--solution-with-gemini-assistance)
3. [How It Works](#-how-it-works)
4. [Key Features](#-key-features)
5. [How to Download and Use](#-how-to-download-and-use)
6. [Permanent Prevention Tips](#-permanent-prevention-tips)
7. [Repository Structure](#-repository-structure)
8. [License](#-license)
9. [About the Author & Official Links](#-about-the-author--official-links)

---

## 🛑 The Chronic Problem

Owners of the **ROCCAT Torch** microphone frequently encounter an unresponsive state where:
- The dynamic RGB lighting turns completely off and the microphone turns **solid red**.
- The physical mixer base displays **DISABLED / MUTE**.
- **The top contactless gesture sensor and physical buttons stop responding**, preventing the user from unmuting manually.
- Restarting the computer, replugging the USB cable, or reinstalling **ROCCAT Swarm** does not resolve the lockup.
- Previously, the only workaround was manually uninstalling the driver in Device Manager and rebooting, but the issue invariably returned.

---

## 🔬 Root Cause & Solution with Gemini Assistance

After repeatedly dealing with this issue, an in-depth investigation with **Gemini** uncovered the exact cause:

1. **Hardware Mute Sync:** The ROCCAT Torch implements bidirectional hardware mute synchronization with Windows audio endpoints (`IAudioEndpointVolume`).
2. **Initial Trigger:** Room lighting, dust, shadows on the top proximity sensor, or software shortcuts trigger a mute event.
3. **Bus Deadlock:** Windows saves the muted state in the audio endpoint registry (`Mute = True`). The microphone enters system-muted state, locks hardware controls, and awaits a formal un-mute packet from Windows.
4. **Registry Persistence:** Even when replugged or rebooted, Windows restores the previous endpoint state (`Mute = True`), re-locking the microphone in solid red.

---

## ⚡ How It Works

The script operates directly at the Windows CoreAudio MMDevice COM layer:
1. Dynamically scans for the active recording endpoint belonging to the **ROCCAT Torch**.
2. Connects to the microphone's `IAudioEndpointVolume` interface.
3. Dispatches the direct hardware instruction `SetMute(false)`.
4. Windows immediately transmits the USB packet, the microcontroller unlocks, the mixer base enables, and the RGB lighting returns to normal instantly.

---

## ✨ Key Features

- **📦 Single Self-Contained Script (`Unlock-Torch-Microphone.ps1`):** Zero external dependencies, no third-party modules, and no companion files required.
- **🌐 Automatic Language Detection (PT-BR & EN):** Detects Windows OS language (`[CultureInfo]::CurrentUICulture`). Defaults to Portuguese on PT-BR systems and English on all other locales.
- **🛡️ Safe & Non-Invasive:** Does not modify system drivers, requires no permanent background software, and runs without administrator privileges.

---

## 📥 How to Download and Use

1. Download **`Unlock-Torch-Microphone.ps1`** (or download `ROCCAT-Torch-Fix-v1.0.0-Portable.zip` from the [Releases](https://github.com/Emertels/ROCCAT-Torch-Fix/releases) tab).
2. Whenever the microphone gets stuck in red:
   - **Right-click** `Unlock-Torch-Microphone.ps1` and select **"Run with PowerShell"**; **OR**
   - Run via terminal: `powershell -ExecutionPolicy Bypass -File .\Unlock-Torch-Microphone.ps1`
3. The microphone will instantly unlock, leaving the red state and resuming normal RGB illumination!

---

## 🛡️ Permanent Prevention Tips

1. **Disable the rear gesture sensor switch:**  
   On the back of the microphone base, locate the **GESTURE MUTE** switch. If you do not actively use hand-wave muting, switch it to **OFF**. This eliminates accidental triggers caused by overhead lighting or shadows.
2. **Disable Exclusive Mode in Windows:**  
   Press `Win + R`, type `mmsys.cpl`, and press Enter. Go to the **Recording** tab, open the properties for the Torch microphone, select the **Advanced** tab, and uncheck *"Allow applications to take exclusive control of this device"*.

---

## 📂 Repository Structure

```text
ROCCAT-Torch-Fix/
├── Unlock-Torch-Microphone.ps1  # Single self-contained PowerShell + C# CoreAudio script
├── README.md                    # Project presentation in Portuguese
├── README.en.md                 # Project presentation in English
├── MANUAL.md                    # Detailed user guide and diagnostics (PT-BR)
├── MANUAL.en.md                 # Detailed user guide and diagnostics (EN)
├── AGENTS.md                    # Technical guidelines for AI agents & devs (PT-BR)
├── AGENTS.en.md                 # Technical guidelines for AI agents & devs (EN)
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
