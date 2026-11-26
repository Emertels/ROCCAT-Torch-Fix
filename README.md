# 🎙️ ROCCAT Torch Fix (Windows 10 & 11) — Mute Lock Fix

<div align="center">

**[🇧🇷 Português](#-português) | [🇺🇸 English](#-english)**

<br/>

[![Release](https://img.shields.io/badge/Release-v1.0.0-blue.svg)](https://github.com/Emertels/ROCCAT-Torch-Fix/releases)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B%20%7C%207%2B-blue.svg)](https://microsoft.com/powershell)
[![Windows](https://img.shields.io/badge/OS-Windows%2010%20%2F%2011-0078D6.svg)](https://www.microsoft.com/windows)
[![i18n](https://img.shields.io/badge/i18n-Auto--Detect%20(PT--BR%20%7C%20EN)-success.svg)](#-suporte-bil%C3%ADngue-autom%C3%A1tico)
[![License](https://img.shields.io/badge/License-MIT-brightgreen.svg)](LICENSE)

</div>

---

## 🇧🇷 Português

Utilitário em script único em **PowerShell** e **C# CoreAudio API** desenvolvido por **Emerson Teles** (com suporte e assistência analítica do **Gemini**) para corrigir de forma definitiva o problema crônico de travamento em silêncio (**LED vermelho fixo**, indicador físico **DESATIVADO** e ausência de resposta ao sensor de gestos ou botões) que afeta o microfone **ROCCAT Torch** no Windows 10 e Windows 11.

### 🛑 O Problema Crônico
Muitos usuários do **ROCCAT Torch** enfrentam um bloqueio repentino no qual:
- As luzes dinâmicas RGB do microfone se apagam e todo o corpo/logo acende em **vermelho estático**.
- Na base do mixer físico, o indicador exibe o status de **DESATIVADO / MUTE**.
- **O sensor de gestos no topo e os botões físicos param de responder**, sendo impossível reativar o microfone tocando ou passando a mão.
- Desconectar o cabo USB, reiniciar o computador ou desinstalar o software **ROCCAT Swarm** não resolve o travamento.
- O único paliativo temporário era desinstalar o driver manualmente no Gerenciador de Dispositivos e reiniciar o PC, mas o bug retornava depois.

### 🔬 Causa Raiz e a Solução com Auxílio do Gemini
Após sofrer com esse travamento constante, investiguei a fundo com o suporte analítico do **Gemini** e identificamos a causa exata:
1. **Hardware Mute Sync:** O ROCCAT Torch possui sincronização bidirecional de mudo via USB com o Windows (`IAudioEndpointVolume`).
2. **Gatilho Inicial:** Reflexos de luz no sensor de aproximação infravermelho no topo, poeira ou atalhos de software acionam o silenciamento.
3. **Deadlock de Barramento:** O Windows grava no registro que o ponto de áudio está mudo (`Mute = True`). O microfone entra em modo de espera pelo sistema operacional e bloqueia os controles manuais.
4. **Persistência no Registro:** Mesmo desligando o cabo ou reiniciando o PC, o Windows recarrega o estado salvo (`Mute = True`), religando o microfone já bloqueado em vermelho.

**A Solução Definitiva:**  
O script acessa a **Windows CoreAudio API**, localiza dinamicamente o microfone **ROCCAT Torch** e emite uma ordem forçada de `SetMute(false)` diretamente ao hardware. O Windows despacha o pacote USB de liberação, destravando o firmware, reativando a base física e restaurando a iluminação colorida RGB na mesma hora.

### ✨ Funcionalidades
- **Script Único e Autocontido (`Unlock-Torch-Microphone.ps1`):** Não requer instalação, módulos externos ou arquivos `.bat` adicionais.
- **Detecção Automática de Idioma:** Detecta o idioma do Windows (`[CultureInfo]::CurrentUICulture`). Se for Português (`pt-BR`), exibe tudo em PT-BR; se for qualquer outro idioma, assume automaticamente Inglês.
- **Seguro e Não Invasivo:** Não altera drivers nem exige privilégios de Administrador.

### 🚀 Como Usar
1. Baixe o arquivo **`Unlock-Torch-Microphone.ps1`**.
2. Quando o microfone travar no LED vermelho:
   - Clique com o **botão direito** nele e selecione **"Executar com o PowerShell"**; **OU**
   - Execute no terminal: `powershell -ExecutionPolicy Bypass -File .\Unlock-Torch-Microphone.ps1`
3. O microfone destravará imediatamente e voltará a funcionar!

### 🛡️ Dicas de Prevenção
- **Chave GESTURE MUTE:** Na traseira da base do microfone, mova a chave seletora **GESTURE MUTE** para a posição **OFF** se você não usa gestos aéreos. Isso evita disparos falsos causados por luz ambiente.
- **Modo Exclusivo:** Pressione `Win + R`, digite `mmsys.cpl` > aba **Gravação** > 2 cliques no microfone Torch > aba **Avançado** > desmarque *"Permitir que aplicativos assumam controle exclusivo deste dispositivo"*.

---

## 🇺🇸 English

A standalone single-file **PowerShell** and **C# CoreAudio API** utility developed by **Emerson Teles** (with analytical technical assistance from **Gemini**) to permanently solve the chronic mute lock issue (**solid red LED**, physical **DISABLED / MUTE** status, and non-responsive gesture sensor and buttons) affecting the **ROCCAT Torch** USB microphone on Windows 10 and Windows 11.

### 🛑 The Chronic Issue
Users of the **ROCCAT Torch** microphone frequently encounter an unresponsive state where:
- Dynamic RGB lighting turns off and the body turns **solid red**.
- The physical mixer base indicates **DISABLED / MUTE**.
- **The top contactless gesture sensor and physical buttons stop responding**, making it impossible to unmute manually.
- Unplugging the USB cable, rebooting the PC, or reinstalling **ROCCAT Swarm** does not resolve the lockup.
- Previously, the only workaround was manually uninstalling the driver in Device Manager and rebooting, but the issue invariably returned.

### 🔬 Root Cause & Solution with Gemini Assistance
After repeatedly dealing with this issue, an in-depth investigation with **Gemini** uncovered the exact cause:
1. **Hardware Mute Sync:** The ROCCAT Torch implements bidirectional hardware mute synchronization with Windows audio endpoints (`IAudioEndpointVolume`).
2. **Initial Trigger:** Overhead room lighting, shadows on the top proximity sensor, or software shortcuts trigger a mute event.
3. **Bus Deadlock:** Windows saves the muted state in the audio endpoint registry (`Mute = True`). The microphone enters system-muted state, locks hardware controls, and awaits a formal un-mute packet from Windows.
4. **Registry Persistence:** Even when replugged or rebooted, Windows restores the previous endpoint state (`Mute = True`), re-locking the microphone in solid red.

**The Definitive Solution:**  
The script interfaces directly with the **Windows CoreAudio API**, dynamically locates the active **ROCCAT Torch** recording endpoint, and dispatches a direct `SetMute(false)` command to the hardware. Windows sends the USB release packet, immediately unlocking the firmware, re-enabling the physical mixer base, and restoring dynamic RGB lighting.

### ✨ Features
- **Single Self-Contained Script (`Unlock-Torch-Microphone.ps1`):** Zero external dependencies, no third-party modules, and no companion `.bat` files required.
- **Automatic Language Detection:** Detects the Windows OS language (`[CultureInfo]::CurrentUICulture`). Defaults to Portuguese on PT-BR systems and English on all other locales.
- **Safe & Non-Invasive:** Does not modify drivers, requires no permanent background software, and runs without administrator privileges.

### 🚀 How to Use
1. Download **`Unlock-Torch-Microphone.ps1`**.
2. Whenever the microphone gets stuck in red:
   - **Right-click** the file and select **"Run with PowerShell"**; **OR**
   - Run via terminal: `powershell -ExecutionPolicy Bypass -File .\Unlock-Torch-Microphone.ps1`
3. The microphone will instantly unlock, leaving the red state and resuming normal RGB illumination!

### 🛡️ Prevention Tips
- **GESTURE MUTE Switch:** On the back of the mixer base, move the **GESTURE MUTE** switch to **OFF** if you do not use hand gestures. This prevents false triggers from ambient room lighting.
- **Exclusive Mode:** Press `Win + R`, type `mmsys.cpl` > **Recording** tab > double-click Torch microphone > **Advanced** tab > uncheck *"Allow applications to take exclusive control of this device"*.

---

## 📄 Licença / License

Distribuído sob a licença **MIT** / Distributed under the **MIT** license. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

## 👨‍💻 Sobre o Autor / About the Author

Desenvolvido e mantido por **Emerson Teles** (conhecido na comunidade como **Emertels**).  
*Developed and maintained by Emerson Teles (known in the community as Emertels).*

Entusiasta de tecnologia, informática, jogos, manutenção de sistemas e tradução/localização técnica de softwares para Português do Brasil (PT-BR). Desenvolvedor focado em utilitários práticos, ferramentas de produtividade, automação inteligente em PowerShell e correções de sistema para a comunidade.

### 🌐 Conecte-se comigo & Comunidades Oficiais / Official Links

<div align="left">

[![GitHub](https://img.shields.io/badge/GitHub-Emertels-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/emertels)
[![Website](https://img.shields.io/badge/Website-Emerson_Teles-0070F3?style=for-the-badge&logo=googlechrome&logoColor=white)](https://emertels.github.io)
[![Discord](https://img.shields.io/badge/Discord-Emertels%20Server-5865F2?style=for-the-badge&logo=discord&logoColor=white)](https://emertels.github.io/discord)
[![X / Twitter](https://img.shields.io/badge/X_Twitter-@emertels-000000?style=for-the-badge&logo=x&logoColor=white)](https://x.com/emertels)
[![YouTube](https://img.shields.io/badge/YouTube-Emerson_Teles-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/@emersonteles2379)
[![Telegram](https://img.shields.io/badge/Telegram-Aplicativos%20Mods-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/apksmodsandroid)
[![Ko-fi](https://img.shields.io/badge/Ko--fi-Apoiar%20Projeto-FF5E5B?style=for-the-badge&logo=kofi&logoColor=white)](https://ko-fi.com/emertels)

</div>
