# 📖 User Manual & Diagnostics — ROCCAT Torch Fix

<p align="center">
  <a href="MANUAL.md">🇧🇷 Português</a> | <b>🇺🇸 English</b>
</p>

This manual provides direct diagnostic, usage, and maintenance instructions for the **ROCCAT Torch** microphone unlock utility on Windows 10 and 11.

---

## 🎯 Purpose of the Utility

This script is specifically designed to resolve the audio endpoint freeze on the **ROCCAT Torch** microphone, characterized by:
1. Solid red microphone LED lighting.
2. Mixer base status displaying **MUTE / DISABLED**.
3. Inability to unmute by waving over the contactless top sensor.
4. Inability to unmute by clicking the physical central volume knob.

---

## 🚀 How to Use (Step by Step)

### Method 1: Using the Quick Launcher (.bat)
1. Ensure the microphone is connected to your computer's USB port.
2. **Double-click** `Unlock-Torch-Microphone.bat`.
3. A console window will open and automatically carry out the following actions:
   - Identifies the operating system language (PT-BR / EN).
   - Dynamically searches for the active `Torch Streaming Microphone` capture device.
   - Queries and clears the Windows CoreAudio mute flag.
4. A green success message will be displayed, and the microphone's dynamic RGB illumination will immediately return.
5. Press any key to close the console.

### Method 2: Running the PowerShell Script Directly (.ps1)
1. Right-click `Unlock-Torch-Microphone.ps1`.
2. Choose **"Run with PowerShell"**.
3. The script will execute the exact same recovery procedure.

---

## 🔍 Diagnostics & Troubleshooting

| Observed Symptom | Likely Cause | Recommended Action |
|---|---|---|
| Script displays that no active Torch microphone was found. | Loose or disconnected USB cable. | Verify both the main USB cable connecting the base to the PC and the short USB-C jumper cable connecting the mic capsule to the mixer base. |
| Microphone unlocks, but returns to red minutes later. | Proximity sensor triggered by ambient room lighting or shadows. | Move the rear **GESTURE MUTE** switch on the back of the base to **OFF**. |
| Discord, Teams, or a game mutes the mic upon opening. | Conflicting mute hotkey or Exclusive Mode lock. | Open Windows Sound Settings (`mmsys.cpl`) > Microphone Properties > Advanced > Uncheck Exclusive Mode. |

---

## ⚙️ System Requirements

- **Operating System:** Windows 10 or Windows 11 (64-bit).
- **Environment:** Windows PowerShell 5.1 (built into Windows) or PowerShell 7+.
- **Privileges:** No administrator rights required. Runs under standard user privileges.

---

## 📄 License & Authorship

- **Author:** Emerson Teles ([@Emertels](https://github.com/emertels))
- **License:** MIT License
