# 🎙️ Correção ROCCAT Torch (Windows 10 & 11) — Mute Lock Fix

<div align="center">

**🌐 Idiomas / Languages:**  
  <a href="README-PT-BR.md"><img src="https://img.shields.io/badge/Documenta%C3%A7%C3%A3o-Portugu%C3%AAs%20(Brasil)-green?style=for-the-badge" alt="PT-BR"></a>
  <a href="README-EN.md"><img src="https://img.shields.io/badge/Documentation-English-blue?style=for-the-badge" alt="EN"></a>
  <a href="MANUAL.md"><img src="https://img.shields.io/badge/Manual-PT--BR-purple?style=for-the-badge" alt="Manual PT-BR"></a>
  <a href="MANUAL-EN.md"><img src="https://img.shields.io/badge/Manual-EN-darkblue?style=for-the-badge" alt="Manual EN"></a>

<br/>

[![Release](https://img.shields.io/badge/Release-v1.0.0-blue.svg)](https://github.com/Emertels/ROCCAT-Torch-Fix/releases)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B%20%7C%207%2B-blue.svg)](https://microsoft.com/powershell)
[![Windows](https://img.shields.io/badge/OS-Windows%2010%20%2F%2011-0078D6.svg)](https://www.microsoft.com/windows)
[![i18n](https://img.shields.io/badge/i18n-Auto--Detect%20(PT--BR%20%7C%20EN)-success.svg)](#-suporte-bil%C3%ADngue-autom%C3%A1tico)
[![License](https://img.shields.io/badge/License-MIT-brightgreen.svg)](LICENSE)

</div>

---

Solução técnica e automatizada em **PowerShell** e **C# CoreAudio API** desenvolvida por **Emerson Teles** (com suporte e assistência de inteligência artificial do **Gemini**) para corrigir de forma definitiva a falha crônica de travamento em silêncio (**LED vermelho estático**, indicador físico **DESATIVADO** e ausência de resposta ao sensor de gestos ou botões) que atinge o microfone **ROCCAT Torch** no Windows 10 e Windows 11.

---

## 🛑 O Problema Crônico: O que acontecia na prática?

Muitos usuários do **ROCCAT Torch** enfrentam um bloqueio repentino no qual:
- As luzes dinâmicas RGB do microfone apagam-se e todo o corpo/logo do microfone acende em **vermelho fixo**.
- Na base do mixer físico, o indicador exibe o status de **DESATIVADO / MUTE**.
- **O sensor de gestos no topo e os botões físicos param de responder**, sendo impossível reativar o microfone tocando ou passando a mão.
- Desconectar e reconectar o cabo USB, reiniciar o computador ou desinstalar o utilitário **ROCCAT Swarm** não resolvia o problema de forma definitiva.

A única solução paliativa que alguns usuários encontravam era desinstalar o driver no Gerenciador de Dispositivos e reiniciar o PC, mas o bug inevitavelmente retornava.

---

## 🔬 A Causa Raiz e a Correção com Auxílio do Gemini

Após sofrer repetidamente com esse problema e investigá-lo a fundo com o auxílio analítico do **Gemini**, descobriu-se a causa raiz exata:

1. **Sincronização Bidirecional via Hardware (Hardware Mute Sync):** O ROCCAT Torch possui suporte direto a controle de volume e silenciamento no nível do sistema (`IAudioEndpointVolume`).
2. **Disparo Involuntário:** O sensor de aproximação por gestos (ou um atalho de software) enviava uma ordem de mudo ao Windows.
3. **Deadlock de Barramento (Travamento):** O Windows gravava no registro que o ponto de áudio estava mudo (`Mute = True`). O microfone entrava em estado de espera pelo sistema operacional e bloqueava seus sensores físicos.
4. **Persistência no Registro:** O Windows mantinha o estado de mudo salvo mesmo desligando o cabo ou reiniciando o computador. O aparelho iniciava já bloqueado em vermelho.

### 💡 A Solução Definitiva
O script acessa diretamente a **Windows CoreAudio MMDevice API** em baixo nível, localiza o endpoint ativo do **ROCCAT Torch** e emite uma ordem forçada de `SetMute(false)` diretamente ao hardware. O Windows despacha o pacote USB de liberação, destravando o firmware, reativando a base física e restaurando a iluminação colorida RGB na mesma hora.

---

## ✨ Principais Funcionalidades

- **🌐 Detecção Automática de Idioma (PT-BR & EN):** Identifica o idioma do Windows do usuário. Se estiver em Português, exibe tudo em PT-BR; se estiver em qualquer outro idioma, assume automaticamente o Inglês.
- **⚡ Desbloqueio Instantâneo:** Executa em menos de 2 segundos sem necessitar reiniciar o computador ou retirar cabos.
- **🚀 2 Formas Práticas de Uso:** Acompanha o script PowerShell `Unlock-Torch-Microphone.ps1` e o inicializador rápido `.bat` para execução com 2 cliques.
- **🛡️ 100% Seguro e Não Invasivo:** Não altera drivers, não requer instalação de programas pesados e não necessita privilégios de Administrador.

---

## 📥 Como Baixar e Usar

### 📦 Versão Portátil Pronta (Recomendado)
1. Baixe o pacote **`ROCCAT-Torch-Fix-v1.0.0-Portable.zip`** na aba de [Releases](https://github.com/Emertels/ROCCAT-Torch-Fix/releases).
2. Extraia o conteúdo em qualquer pasta ou na sua Área de Trabalho.
3. Quando o microfone travar no LED vermelho:
   - Dê **dois cliques** em `Unlock-Torch-Microphone.bat`; **OU**
   - Clique com o botão direito em `Unlock-Torch-Microphone.ps1` e selecione **"Executar com o PowerShell"**.
4. O microfone destravará imediatamente e voltará a funcionar!

---

## 🛡️ Dicas para Prevenir Novos Travamentos

1. **Desative o sensor de gestos traseiro:**  
   Atrás da base do microfone há uma chave seletora chamada **GESTURE MUTE**. Se você não usa gestos aéreos, coloque essa chave na posição **OFF** para evitar disparos falsos causados por sombras ou lâmpadas.
2. **Desative o Modo Exclusivo no Windows:**  
   Pressione `Win + R`, digite `mmsys.cpl` e dê Enter. Na aba **Gravação**, dê 2 cliques no microfone Torch > aba **Avançado** > desmarque *"Permitir que aplicativos assumam controle exclusivo deste dispositivo"*.

---

## 📂 Estrutura do Repositório

```text
ROCCAT-Torch-Fix/
├── Unlock-Torch-Microphone.bat  # Inicializador rápido de 2 cliques para Windows
├── Unlock-Torch-Microphone.ps1  # Script PowerShell bilíngue com C# CoreAudio nativo
├── README.md                    # Apresentação principal do projeto
├── README-PT-BR.md              # Documentação completa em Português
├── README-EN.md                 # Documentação completa em Inglês
├── MANUAL.md                    # Manual de uso e diagnóstico (PT-BR)
├── MANUAL-EN.md                 # Manual de uso e diagnóstico (EN)
├── AGENTS.md                    # Diretrizes técnicas para IA e desenvolvedores (PT-BR)
├── AGENTS_EN.md                 # Diretrizes técnicas para IA e desenvolvedores (EN)
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
