# 🎙️ ROCCAT Torch Fix

<p align="center">
  <b>🇧🇷 Português</b> | <a href="README.en.md">🇺🇸 English</a>
</p>

<p align="center">
  <a href="https://github.com/Emertels/ROCCAT-Torch-Fix/releases"><img src="https://img.shields.io/badge/Release-v1.0.0-blue.svg" alt="Versão v1.0.0"></a>
  <a href="https://microsoft.com/powershell"><img src="https://img.shields.io/badge/PowerShell-5.1%2B%20%7C%207%2B-blue.svg" alt="PowerShell"></a>
  <a href="https://www.microsoft.com/windows"><img src="https://img.shields.io/badge/OS-Windows%2010%20%2F%2011-0078D6.svg" alt="Windows"></a>
  <img src="https://img.shields.io/badge/i18n-Auto--Detect%20(PT--BR%20%7C%20EN)-success.svg" alt="Idiomas">
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-brightgreen.svg" alt="Licença MIT"></a>
</p>

Utilitário em script único em **PowerShell** e **C# CoreAudio API** desenvolvido por **Emerson Teles** (com suporte e assistência analítica do **Gemini**) para corrigir de forma definitiva o problema crônico de travamento em silêncio (**LED vermelho estático**, indicador físico **DESATIVADO** e ausência de resposta ao sensor de gestos ou botões) que atinge o microfone **ROCCAT Torch** no Windows 10 e Windows 11.

---

## 📋 Sumário

1. [O Problema Crônico](#-o-problema-crônico)
2. [Causa Raiz e a Solução com Auxílio do Gemini](#-causa-raiz-e-a-solução-com-auxílio-do-gemini)
3. [Como Funciona](#-como-funciona)
4. [Recursos Principais](#-recursos-principais)
5. [Como Baixar e Usar](#-como-baixar-e-usar)
6. [Dicas de Prevenção Definitiva](#-dicas-de-prevenção-definitiva)
7. [Estrutura do Repositório](#-estrutura-do-repositório)
8. [Licença](#-licença)
9. [Sobre o Autor & Redes Oficiais](#-sobre-o-autor--redes-oficiais)

---

## 🛑 O Problema Crônico

Usuários do microfone **ROCCAT Torch** frequentemente enfrentam um bloqueio repentino no qual:
- As luzes dinâmicas RGB do microfone se apagam e todo o corpo/logo acende em **vermelho fixo**.
- Na base do mixer físico, o indicador exibe o status de **DESATIVADO / MUTE**.
- **O sensor de gestos no topo e os botões físicos param de responder**, sendo impossível reativar o microfone tocando ou passando a mão.
- Desconectar o cabo USB, reiniciar o computador ou desinstalar o software **ROCCAT Swarm** não resolve o travamento.
- O único paliativo temporário era desinstalar o driver manualmente no Gerenciador de Dispositivos e reiniciar o PC, mas o bug retornava depois.

---

## 🔬 Causa Raiz e a Solução com Auxílio do Gemini

Após sofrer repetidamente com esse problema, investiguei a fundo com o auxílio técnico e analítico do **Gemini** e identificamos a causa exata:

1. **Sincronização Bidirecional via Hardware (Hardware Mute Sync):** O ROCCAT Torch possui sincronização direta de volume e silenciamento no nível de sistema com o Windows (`IAudioEndpointVolume`).
2. **Gatilho Inicial:** Reflexos de luz no sensor de aproximação infravermelho no topo, poeira ou atalhos de software acionam o silenciamento.
3. **Deadlock de Barramento (Travamento):** O Windows grava no registro que o ponto de áudio está mudo (`Mute = True`). O microfone entra em modo de espera pelo sistema operacional e bloqueia os controles manuais.
4. **Persistência no Registro:** Mesmo desligando o cabo ou reiniciando o PC, o Windows recarrega o estado salvo (`Mute = True`), religando o microfone já bloqueado em vermelho.

---

## ⚡ Como Funciona

O script acessa a **Windows CoreAudio MMDevice API** em baixo nível:
1. Localiza dinamicamente o dispositivo de captura ativo do **ROCCAT Torch**.
2. Acessa a interface COM `IAudioEndpointVolume` do microfone.
3. Emite uma ordem forçada de `SetMute(false)` diretamente ao hardware.
4. O Windows despacha o pacote USB de liberação, destravando o firmware, reativando a base física e restaurando a iluminação colorida RGB na mesma hora.

---

## ✨ Recursos Principais

- **📦 Script Único e Autocontido (`Unlock-Torch-Microphone.ps1`):** Não requer instalação, módulos externos adicionais nem executáveis pesados.
- **🌐 Detecção Automática de Idioma (PT-BR & EN):** Detecta o idioma do Windows (`[CultureInfo]::CurrentUICulture`). Se for Português (`pt-BR`), exibe tudo em PT-BR; se for qualquer outro idioma, assume automaticamente Inglês.
- **🛡️ Seguro e Não Invasivo:** Não altera drivers nem exige privilégios de Administrador.

---

## 📥 Como Baixar e Usar

1. Baixe o arquivo **`Unlock-Torch-Microphone.ps1`** (ou baixe o pacote portátil `ROCCAT-Torch-Fix-v1.0.0-Portable.zip` na aba de [Releases](https://github.com/Emertels/ROCCAT-Torch-Fix/releases)).
2. Quando o microfone travar no LED vermelho:
   - Clique com o **botão direito** nele e selecione **"Executar com o PowerShell"**; **OU**
   - Execute no terminal: `powershell -ExecutionPolicy Bypass -File .\Unlock-Torch-Microphone.ps1`
3. O microfone destravará imediatamente e voltará a funcionar!

---

## 🛡️ Dicas de Prevenção Definitiva

1. **Desative o sensor de gestos traseiro:**  
   Atrás da base do microfone há uma chave seletora chamada **GESTURE MUTE**. Se você não costuma usar gestos aéreos, coloque essa chave na posição **OFF** para evitar disparos falsos causados por sombras ou lâmpadas.
2. **Desative o Modo Exclusivo no Windows:**  
   Pressione `Win + R`, digite `mmsys.cpl` e dê Enter. Na aba **Gravação**, dê 2 cliques no microfone Torch > aba **Avançado** > desmarque *"Permitir que aplicativos assumam controle exclusivo deste dispositivo"*.

---

## 📂 Estrutura do Repositório

```text
ROCCAT-Torch-Fix/
├── Unlock-Torch-Microphone.ps1  # Script único autocontido em PowerShell + C# CoreAudio
├── README.md                    # Apresentação do projeto em Português
├── README.en.md                 # Apresentação do projeto em Inglês
├── MANUAL.md                    # Manual detalhado de instruções e diagnóstico (PT-BR)
├── MANUAL.en.md                 # Manual detalhado de instruções e diagnóstico (EN)
├── AGENTS.md                    # Diretrizes técnicas para IA e desenvolvedores (PT-BR)
├── AGENTS.en.md                 # Diretrizes técnicas para IA e desenvolvedores (EN)
├── LICENSE                      # Licença MIT de código aberto
└── .gitignore                   # Filtros do repositório Git
```

---

## 📄 Licença

Distribuído sob a licença **MIT**. Consulte o arquivo [LICENSE](LICENSE) para mais informações.

---

## 👨‍💻 Sobre o Autor

Desenvolvido e mantido por **Emerson Teles** (conhecido na comunidade como **Emertels**).

Entusiasta de tecnologia, informática, jogos, manutenção de sistemas e tradução/localização de softwares para Português do Brasil (PT-BR). Desenvolvedor focado em utilitários práticos, ferramentas de produtividade, automação inteligente em PowerShell e soluções completas de localização técnica que aproximam ferramentas modernas do público brasileiro.

### 🛠️ Projetos & Contribuições

- [AI-Chat-Vault](https://github.com/Emertels/AI-Chat-Vault) — Backup portátil e recuperação de conversas locais de 20+ ferramentas e assistentes de IA.
- [Antigravity — Tradução PT-BR](https://github.com/Emertels/Antigravity-Traducao-PTBR) — Localização completa do Google Antigravity Desktop para Português do Brasil.
- [Codex Router — Tradução PT-BR](https://github.com/Emertels/CodexRouter-Traducao-PTBR) — Pacote de tradução e localização do Codex Router Control Center em PT-BR.
- [Cursor AI — Tradução PT-BR](https://github.com/Emertels/Cursor-Traducao-PTBR) — Localização completa e profunda do Cursor AI para Português do Brasil.
- [GPU Tweak III — Tradução PT-BR](https://github.com/Emertels/GPU-Tweak-III-Traducao-PTBR) — Tradução em português brasileiro e instalador automatizado para ASUS GPU Tweak III.
- [Microsoft Photos Fix](https://github.com/Emertels/Microsoft-Photos-Fix) — Solução definitiva em PowerShell e C# para rota de inicialização rápida e visualização no app Fotos do Windows.
- [PSBBN-Translator](https://github.com/Emertels/PSBBN-Translator) — Suíte corporativa de tradução e localização para o PSBBN Definitive Project (PlayStation 2) em 40 idiomas.
- [ROCCAT Torch Fix](https://github.com/Emertels/ROCCAT-Torch-Fix) — Solução definitiva para destravar o microfone ROCCAT Torch travado em mudo e LED vermelho.
- [Silent Hill: Homecoming — Tradução PT-BR](https://github.com/Emertels/Silent-Hill-Homecoming-Traducao-PTBR) — Tradução e revisão completa do jogo para PC em português brasileiro.
- [Suite-Emuladores](https://github.com/Emertels/Suite-Emuladores) — Suíte inteligente em PowerShell para download e atualização autônoma de 56 emuladores e frontends no Windows.
- [ZCode — Tradução PT-BR](https://github.com/Emertels/ZCode-Traducao-PTBR) — Tradução e localização completa do ZCode Desktop para Português do Brasil.

### 🌐 Conecte-se comigo & Comunidades Oficiais

<div align="left">

[![GitHub](https://img.shields.io/badge/GitHub-Emertels-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/emertels)
[![Website](https://img.shields.io/badge/Website-Emerson_Teles-0070F3?style=for-the-badge&logo=googlechrome&logoColor=white)](https://emertels.github.io)
[![Discord](https://img.shields.io/badge/Discord-Emertels%20Server-5865F2?style=for-the-badge&logo=discord&logoColor=white)](https://emertels.github.io/discord)
[![X / Twitter](https://img.shields.io/badge/X_Twitter-@emertels-000000?style=for-the-badge&logo=x&logoColor=white)](https://x.com/emertels)
[![YouTube](https://img.shields.io/badge/YouTube-Emerson_Teles-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/@emersonteles2379)
[![Telegram](https://img.shields.io/badge/Telegram-Aplicativos%20Mods-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/apksmodsandroid)
[![Ko-fi](https://img.shields.io/badge/Ko--fi-Apoiar%20Projeto-FF5E5B?style=for-the-badge&logo=kofi&logoColor=white)](https://ko-fi.com/emertels)

</div>
