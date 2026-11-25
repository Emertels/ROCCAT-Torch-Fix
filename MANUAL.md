# 📖 Manual de Instruções e Diagnóstico — ROCCAT Torch Fix

<p align="center">
  <b>🇧🇷 Português</b> | <a href="MANUAL-EN.md">🇺🇸 English</a>
</p>

Este manual contém instruções diretas de diagnóstico, utilização e manutenção do utilitário de desbloqueio para o microfone **ROCCAT Torch** no Windows 10 e 11.

---

## 🎯 Objetivo do Utilitário

O script foi concebido para resolver o congelamento do estado de áudio do microfone **ROCCAT Torch**, caracterizado por:
1. LED do microfone travado em cor vermelha estática.
2. Indicador da base exibindo o estado de **MUTE / DESATIVADO**.
3. Falha de resposta aos gestos aéreos na cúpula do microfone.
4. Falha de resposta ao clique físico no seletor central de volume.

---

## 🚀 Como Utilizar (Passo a Passo)

### Método 1: Pelo Inicializador Rápido (.bat)
1. Certifique-se de que o microfone está conectado à porta USB do computador.
2. Dê **dois cliques** no arquivo `Unlock-Torch-Microphone.bat`.
3. Uma tela do console abrirá e executará os seguintes passos automaticamente:
   - Identificação do idioma do sistema operacional (PT-BR / EN).
   - Localização dinâmica do dispositivo de captura `Torch Streaming Microphone`.
   - Consulta e alteração da flag de mudo via CoreAudio API do Windows.
4. Ao final, a mensagem de sucesso será exibida em verde e o microfone voltará a acender as luzes coloridas (RGB dinâmico) imediatamente.
5. Pressione qualquer tecla para encerrar a tela.

### Método 2: Pelo Script Direto do PowerShell (.ps1)
1. Clique com o **botão direito** do mouse sobre `Unlock-Torch-Microphone.ps1`.
2. Escolha a opção **"Executar com o PowerShell"**.
3. O script executará a mesma rotina de restauração.

---

## 🔍 Diagnóstico e Resolução de Problemas

| Sintoma Observado | Causa Provável | Ação Recomendada |
|---|---|---|
| O script exibe mensagem dizendo que nenhum microfone Torch foi encontrado. | Cabo USB frouxo ou desconectado. | Verifique tanto o cabo que liga a base ao PC quanto o cabo USB-C menor que conecta a cúpula do microfone à base. |
| O microfone destrava, mas volta a ficar vermelho minutos depois. | O sensor de gestos está sendo disparado por iluminação ambiente ou sombras. | Mova a chave **GESTURE MUTE** na parte de trás da base para a posição **OFF**. |
| O Discord ou jogo silencia o microfone ao abrir. | O aplicativo possui atalho de mudo conflitante ou assumiu controle exclusivo. | Abra as Configurações de Som do Windows (`mmsys.cpl`) > Propriedades do microfone > Avançado > Desmarque o modo exclusivo. |

---

## ⚙️ Requisitos do Sistema

- **Sistema Operacional:** Windows 10 ou Windows 11 (64-bit).
- **Ambiente:** Windows PowerShell 5.1 (nativo do Windows) ou PowerShell 7+.
- **Privilégios:** Não requer privilégios de Administrador. Executa em nível de usuário comum.

---

## 📄 Licença e Autoria

- **Autor:** Emerson Teles ([@Emertels](https://github.com/emertels))
- **Licença:** MIT License
