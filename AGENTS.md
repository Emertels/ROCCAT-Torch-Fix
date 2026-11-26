# 🤖 AGENTS.md — Diretrizes Técnicas para Agentes de IA e Desenvolvedores

<p align="center">
  <b>🇧🇷 Português</b> | <a href="AGENTS.en.md">🇺🇸 English</a>
</p>

Este documento define a arquitetura, convenções de código, interfaces COM e diretrizes de manutenção do projeto **ROCCAT Torch Fix**. Deve ser consultado por agentes de inteligência artificial e desenvolvedores que venham a manter ou estender este repositório.

---

## 1. Visão Geral da Arquitetura
O projeto consiste em um utilitário de reparo rápido executado em espaço de usuário (sem necessidade de privilégios de Administrador). Ele interage diretamente com o subsistema de áudio de baixo nível do Windows (**Windows CoreAudio API**) por meio de chamadas de interoperabilidade COM (P/Invoke) compiladas em tempo de execução via PowerShell `Add-Type`.

## 2. Interfaces COM e Identificadores (GUIDs)
As seguintes interfaces nativas do Windows são implementadas no script:

- **`IMMDeviceEnumerator`**: `A95664D2-9614-4F35-A746-DE8DB63617E6`
  - Utilizado para enumerar a coleção de endpoints de captura ativos (`dataFlow = 1`, `stateMask = 1`).
- **`IMMDeviceCollection`**: `0BD7A1BE-7A1A-44DB-8397-CC5392387B5E`
  - Manipulação da lista indexada de dispositivos de áudio.
- **`IMMDevice`**: `D666063F-1587-4E43-81F1-B948E807363F`
  - Representa o endpoint de áudio individual. Utilizado para abrir o repositório de propriedades (`OpenPropertyStore`) e ativar interfaces (`Activate`).
- **`IPropertyStore`**: `886d8eeb-8cf2-4446-8d02-cdba1dbdcf99`
  - Usado para obter o nome amigável do dispositivo via `PKEY_Device_FriendlyName` (`fmtid: a45c254e-df1c-4efd-8020-67d146a850e0`, `pid: 14`).
- **`IAudioEndpointVolume`**: `5CDF2C82-841E-4546-9722-0CF74078229A`
  - Interface responsável pela consulta (`GetMute`) e alteração direta (`SetMute`) da flag de silenciamento de hardware.
- **`MMDeviceEnumeratorComObject`**: `BCDE0395-E52F-467C-8E3D-C4579291692E`
  - CoClasse instanciável no Windows.

## 3. Fluxo de Execução
1. **Detecção de Idioma:** Avalia `[System.Globalization.CultureInfo]::CurrentUICulture`. Caso o código ISO de duas letras seja `pt`, utiliza o dicionário em português; caso contrário, seleciona inglês.
2. **Enumeração:** Itera sobre todos os dispositivos de captura ativos.
3. **Casamento por Nome:** Busca por correspondência não sensível a maiúsculas/minúsculas contendo a palavra `Torch`.
4. **Ativação COM:** Invoca `IMMDevice::Activate` requisitando `IID_IAudioEndpointVolume` com contexto `CLSCTX_ALL (23)`.
5. **Comutação de Mudo:** Executa `epVol.SetMute(false, ref ctx)`.
6. **Verificação:** Reconsulta `GetMute` para confirmar se o microfone foi destravado com sucesso.
7. **Pausa Interativa:** Se executado interativamente (sem pipes ou redirecionamento de entrada), aguarda tecla do usuário.

## 4. Regras para Modificações
- **Zero Dependências:** Não adicionar dependências de módulos externos do PowerShell. O código C# puro injetado garante compatibilidade total em qualquer Windows 10 e 11 limpo.
- **Não Requerer Elevação (UAC):** A API `IAudioEndpointVolume` de endpoints de áudio do usuário não requer privilégios de administrador. Manter a execução em nível padrão de usuário.
- **Compatibilidade Bilíngue:** Qualquer nova mensagem de console deve ser adicionada aos dois dicionários (`$L` para `pt` e `en`).
