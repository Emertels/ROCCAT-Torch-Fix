# 🤖 AGENTS_EN.md — Technical Guidelines for AI Agents and Developers

<p align="center">
  <a href="AGENTS.md">🇧🇷 Português</a> | <b>🇺🇸 English</b>
</p>

This document defines the architecture, code conventions, COM interfaces, and maintenance guidelines for the **ROCCAT Torch Fix** project. It should be consulted by AI agents and developers maintaining or extending this repository.

---

## 1. Architectural Overview
The project is a zero-dependency, non-elevated user-space utility that interfaces directly with the low-level **Windows CoreAudio API** via runtime P/Invoke COM interfaces compiled dynamically by PowerShell's `Add-Type`.

## 2. COM Interfaces & GUIDs
The following Windows native audio interfaces are declared and utilized:

- **`IMMDeviceEnumerator`**: `A95664D2-9614-4F35-A746-DE8DB63617E6`
  - Used to enumerate the active capture endpoint collection (`dataFlow = 1`, `stateMask = 1`).
- **`IMMDeviceCollection`**: `0BD7A1BE-7A1A-44DB-8397-CC5392387B5E`
  - Access to indexed endpoints.
- **`IMMDevice`**: `D666063F-1587-4E43-81F1-B948E807363F`
  - Represents individual endpoints; opens property stores and activates COM interfaces.
- **`IPropertyStore`**: `886d8eeb-8cf2-4446-8d02-cdba1dbdcf99`
  - Queries `PKEY_Device_FriendlyName` (`fmtid: a45c254e-df1c-4efd-8020-67d146a850e0`, `pid: 14`).
- **`IAudioEndpointVolume`**: `5CDF2C82-841E-4546-9722-0CF74078229A`
  - Direct hardware mute query (`GetMute`) and modification (`SetMute`).
- **`MMDeviceEnumeratorComObject`**: `BCDE0395-E52F-467C-8E3D-C4579291692E`
  - Creatable MMDeviceEnumerator COM CoClass.

## 3. Execution Pipeline
1. **Locale Detection:** Evaluates `[System.Globalization.CultureInfo]::CurrentUICulture`. If two-letter ISO language name is `pt`, sets Portuguese strings; otherwise defaults to English.
2. **Device Discovery:** Iterates through all active audio capture endpoints.
3. **Identifier Matching:** Performs case-insensitive matching for the string `Torch`.
4. **Interface Activation:** Calls `IMMDevice::Activate` for `IID_IAudioEndpointVolume` with `CLSCTX_ALL (23)`.
5. **State Reset:** Calls `SetMute(false, ref ctx)`.
6. **State Validation:** Reads back `GetMute` to confirm hardware release.
7. **Interactive Handshake:** If running interactively without redirection, waits for keyboard input before closing.

## 4. Constraints for Contributors & Agents
- **No External Modules:** Do not introduce third-party PowerShell modules. The embedded C# CoreAudio helper guarantees 100% out-of-the-box operation on stock Windows 10/11 installations.
- **No UAC Elevation:** Changing user endpoint volume and mute state does not require Administrator privileges. Keep execution non-elevated.
- **Bilingual Consistency:** Any added terminal output must be registered in both the Portuguese and English localization dictionaries.
