# Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto adere ao [Versionamento Semântico](https://semver.org/lang/pt-BR/).

---

## [1.0.0] - 2025-10-27

### 🎉 Lançamento Inicial

#### ✨ Adicionado

**Funcionalidades Principais:**
- Scripts de reparo automático para Windows (versões Lite e Full)
- Sistema anti-travamento do DISM (envia Enter automaticamente a cada 2 minutos)
- Duas implementações: Batch (.BAT) e PowerShell (.PS1)
- Modo automático e modo passo a passo
- Barras de progresso visuais (ASCII para BAT, nativa para PS1)
- Sistema de logs detalhados salvos na Desktop
- Interface amigável com emojis e cores

**Versões Batch (.BAT):**
- `WINrepair-lite.bat` - Reparo básico (DISM + SFC)
- `WINrepair-full.bat` - Reparo completo (+ limpezas + CHKDSK opcional)
- `auto-enter-helper.vbs` - Helper para sistema anti-travamento

**Versões PowerShell (.PS1):**
- `WINrepair-lite.ps1` - Reparo básico com interface moderna
- `WINrepair-full.ps1` - Reparo completo com barra de progresso nativa
- Sistema anti-travamento integrado (não precisa de arquivo externo)

**Comandos Executados:**
- DISM CheckHealth (verificação rápida)
- DISM ScanHealth (verificação profunda)
- DISM RestoreHealth (reparo da imagem)
- SFC ScanNow (verificação de arquivos do sistema)
- Limpeza do cache do Windows Update (apenas Full)
- Limpeza de arquivos temporários (apenas Full)
- Component Store Cleanup (apenas Full)
- CHKDSK opcional (apenas Full)

**Recursos de Segurança:**
- Verificação automática de privilégios administrativos
- Confirmação antes de iniciar o processo
- Códigos de erro registrados no log
- Resumo visual final com status de cada etapa

**Documentação:**
- README.md completo em português
- README_WINDOWS_REPAIR.txt (manual detalhado)
- CHANGELOG.md (este arquivo)
- COMO_SUBIR_NO_GITHUB.txt (guia de publicação)
- LICENSE (GPL-3.0)

**Compatibilidade:**
- Windows 7, 8, 8.1, 10 e 11
- Versões BAT: Todas as versões do Windows
- Versões PS1: Windows 10/11 (PowerShell 5.1+)

---

## [Não Lançado]

### 🚧 Planejado para Futuras Versões

- Interface gráfica (GUI) opcional
- Modo agendamento automático
- Relatórios em HTML
- Suporte para Windows Server
- Tradução para inglês e espanhol
- Verificação de integridade de drivers
- Backup automático antes do reparo
- Modo silencioso (sem interação)

---

## Legenda

- `✨ Adicionado` - Novas funcionalidades
- `🔧 Modificado` - Mudanças em funcionalidades existentes
- `🐛 Corrigido` - Correções de bugs
- `🗑️ Removido` - Funcionalidades removidas
- `🔒 Segurança` - Correções de vulnerabilidades
- `📝 Documentação` - Mudanças na documentação

---

**Sistema mm.ti Lab - Windows Repair Tool**  
*Criado por Marlon Motta e equipe*  
*Email: marlonmotta.ti@gmail.com*

