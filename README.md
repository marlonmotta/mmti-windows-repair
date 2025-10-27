# 🛠️ mm.ti Lab - Windows Repair Tool

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Windows](https://img.shields.io/badge/Platform-Windows%207%2F8%2F10%2F11-0078D6?logo=windows)](https://www.microsoft.com/windows)
[![Version](https://img.shields.io/badge/Version-1.0-green.svg)](https://github.com/marlonmotta/mmti-windows-repair/releases)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/marlonmotta/mmti-windows-repair/graphs/commit-activity)

> Sistema automatizado profissional para reparar problemas comuns do Windows, incluindo arquivos corrompidos, erros de sistema e problemas de atualização.

---

## 🌟 Características Principais

- 🛡️ **Sistema Anti-Travamento** - Previne travamentos do DISM automaticamente
- 🎯 **Duas Versões** - LITE (rápida) e FULL (completa)
- 💻 **Duas Implementações** - BAT (universal) e PowerShell (moderna)
- 📊 **Barras de Progresso** - Visual claro do andamento
- 📝 **Logs Detalhados** - Tudo registrado para análise
- 🎨 **Interface Amigável** - Mensagens claras e coloridas
- ⚙️ **Modo Automático/Manual** - Escolha como executar
- 🔄 **Uso Livre do PC** - Continue trabalhando durante o reparo

---

## 📦 O Que Está Incluído

### 🔵 Versões Batch (.BAT)
- **WINrepair-lite.bat** - Reparo básico (DISM + SFC)
- **WINrepair-full.bat** - Reparo completo (+ limpezas + CHKDSK)
- **auto-enter-helper.vbs** - Helper anti-travamento

### 🟢 Versões PowerShell (.PS1)
- **WINrepair-lite.ps1** - Reparo básico com interface moderna
- **WINrepair-full.ps1** - Reparo completo com barra de progresso nativa

### 📚 Documentação
- **README_WINDOWS_REPAIR.txt** - Manual completo em português

---

## 🚀 Como Usar

### Opção 1: Versões BAT (Recomendado para compartilhar)

1. **Baixe o repositório** (Clone ou Download ZIP)
2. **Extraia todos os arquivos na mesma pasta**
3. **Clique com botão direito** no arquivo `.bat` desejado
4. **Selecione "Executar como administrador"**
5. **Escolha o modo** (Automático ou Passo a Passo)
6. **Aguarde a conclusão** (pode demorar 15-90 minutos)

### Opção 2: Versões PowerShell (Para usuários avançados)

1. **Baixe o repositório**
2. **Clique com botão direito** no arquivo `.ps1` desejado
3. **Selecione "Executar com PowerShell"**
4. Se der erro, execute no PowerShell Admin:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

---

## 📋 Qual Versão Escolher?

### WINrepair-LITE
✅ Primeira tentativa de reparo  
✅ Problemas simples de corrupção  
✅ Rápido (15-60 minutos)  
✅ **Executa:**
- DISM CheckHealth
- DISM ScanHealth
- DISM RestoreHealth
- SFC ScanNow

### WINrepair-FULL
✅ Problemas persistentes  
✅ Erros do Windows Update  
✅ Manutenção preventiva completa  
✅ Liberar espaço em disco  
✅ **Executa tudo do LITE +**
- Limpeza cache Windows Update
- Limpeza arquivos temporários
- Component Store Cleanup
- CHKDSK (opcional)

---

## 🛡️ Sistema Anti-Travamento

### O Problema
O comando DISM frequentemente "trava" em porcentagens específicas (20%, 62%, 84%) e precisa que o usuário pressione Enter para continuar. Isso pode fazer o processo parecer travado por 30-60+ minutos.

### Nossa Solução
✅ Envia Enter automaticamente a cada 2 minutos  
✅ Funciona invisível em background  
✅ Você pode usar o PC normalmente (YouTube, jogos, etc.)  
✅ Minimizar a janela não é problema  
✅ Desativa automaticamente ao finalizar  

**Versões BAT:** Usa `auto-enter-helper.vbs`  
**Versões PS1:** Sistema integrado (não precisa de arquivo extra)

---

## 📊 Barras de Progresso

### Versões BAT
```
┌─ PROGRESSO ────────────────────────────────────────┐
│ ░░░░░░░░░░░░░░░░░░░░░░░░░░░           50%    │
└────────────────────────────────────────────────────┘
```

### Versões PowerShell
Barra de progresso nativa do Windows integrada ao sistema operacional.

---

## 📝 Logs

Todos os scripts salvam logs detalhados em:
```
C:\Users\[USUÁRIO]\Desktop\WinRepair-Logs\
```

**Formato do nome:**
- BAT: `reparo_lite_AAAAMMDD_HHMMSS.log`
- PS1: `reparo_lite_ps_AAAAMMDD_HHMMSS.log`

---

## ⚙️ Requisitos

- ✅ Windows 7, 8, 8.1, 10 ou 11
- ✅ Privilégios de Administrador
- ✅ 5-20 GB de espaço livre no disco C:
- ✅ Conexão com internet (recomendado para DISM)
- ✅ PowerShell 5.1+ (apenas para versões .ps1)

---

## 📸 Screenshots

### Interface BAT
```
╔════════════════════════════════════════════════════════╗
║     REPARO DO SISTEMA WINDOWS - VERSÃO LITE           ║
╚════════════════════════════════════════════════════════╝

[✓] Sistema anti-travamento: ATIVO
[✓] Você pode minimizar esta janela e usar o PC normalmente
```

### Resumo Final
```
╔════════════════════════════════════════════════════════╗
║       🎉 REPARO CONCLUÍDO COM SUCESSO!                ║
╚════════════════════════════════════════════════════════╝

┌─ RESUMO DO PROCESSO ───────────────────────────────────┐
│  ✓ DISM CheckHealth      : CONCLUÍDO                  │
│  ✓ DISM ScanHealth       : CONCLUÍDO                  │
│  ✓ DISM RestoreHealth    : CONCLUÍDO                  │
│  ✓ SFC ScanNow           : CONCLUÍDO                  │
└────────────────────────────────────────────────────────┘
```

---

## ❓ Perguntas Frequentes

<details>
<summary><b>Vai apagar meus arquivos?</b></summary>

**NÃO!** O script apenas repara arquivos do SISTEMA. Seus documentos, fotos, vídeos e arquivos pessoais estão completamente seguros.
</details>

<details>
<summary><b>Posso usar o computador durante o processo?</b></summary>

**SIM!** O sistema anti-travamento funciona em background. Você pode minimizar a janela e usar o PC normalmente (navegar, assistir vídeos, trabalhar, etc.).
</details>

<details>
<summary><b>Quanto tempo demora?</b></summary>

- **LITE:** 15-60 minutos (depende do hardware)
- **FULL:** 30-90 minutos (depende do hardware)
- A etapa DISM RestoreHealth é a mais demorada (20-40 minutos)
</details>

<details>
<summary><b>Precisa de internet?</b></summary>

**Recomendado mas não obrigatório.** O DISM RestoreHealth funciona melhor com internet pois baixa arquivos de correção do Windows Update.
</details>

<details>
<summary><b>Por que o DISM "trava"?</b></summary>

É um comportamento conhecido da Microsoft. O DISM às vezes perde o foco da janela ou o buffer do console fica cheio. Nosso sistema anti-travamento resolve isso automaticamente enviando Enter a cada 2 minutos.
</details>

<details>
<summary><b>Qual a diferença entre BAT e PowerShell?</b></summary>

**Funcionalidades são idênticas.** Diferenças:

- **BAT:** Máxima compatibilidade (Win 7+), barra ASCII
- **PowerShell:** Interface moderna, barra nativa do Windows, mais colorido

Ambos têm sistema anti-travamento e logs completos.
</details>

---

## 🔧 O Que os Scripts Fazem

### DISM (Deployment Image Servicing and Management)
- **CheckHealth:** Verifica se há corrupção (rápido)
- **ScanHealth:** Análise profunda de integridade (demorado)
- **RestoreHealth:** Repara problemas encontrados (muito demorado)

### SFC (System File Checker)
- Verifica e repara arquivos do sistema corrompidos
- Usa cache do DISM para restaurar arquivos

### Limpezas (apenas FULL)
- **Windows Update Cache:** Remove cache corrompido que impede atualizações
- **Arquivos Temporários:** Limpa `%TEMP%` e pastas de logs
- **Component Store:** Remove versões antigas de componentes (libera espaço)

### CHKDSK (apenas FULL, opcional)
- Verifica e repara erros no disco rígido
- Executa na próxima reinicialização

---

## 🤝 Contribuindo

Contribuições são bem-vindas! Este é um projeto **Software Livre** sob licença GPL-3.0.

1. Fork o projeto
2. Crie uma branch (`git checkout -b feature/MinhaFeature`)
3. Commit suas mudanças (`git commit -m 'Adiciona MinhaFeature'`)
4. Push para a branch (`git push origin feature/MinhaFeature`)
5. Abra um Pull Request

---

## 📜 Licença

Este projeto está licenciado sob a **GNU General Public License v3.0** - veja o arquivo [LICENSE](LICENSE) para detalhes.

### O que isso significa?

✅ **Você pode:**
- Usar para qualquer propósito (pessoal ou comercial)
- Modificar o código-fonte
- Distribuir cópias
- Distribuir versões modificadas

⚠️ **Você deve:**
- Manter a mesma licença (GPL-3.0)
- Disponibilizar o código-fonte de versões modificadas
- Documentar mudanças feitas
- Incluir avisos de copyright e licença

🚫 **Você não pode:**
- Sublicenciar sob termos diferentes
- Responsabilizar os autores por problemas

---

## 👤 Autor

**Marlon Motta e equipe**
- Sistema: mm.ti Lab
- Email: marlonmotta.ti@gmail.com
- GitHub: [@marlonmotta](https://github.com/marlonmotta)

---

## 🌟 Agradecimentos

- Comunidade Windows por documentar os problemas do DISM
- Todos que testaram e deram feedback
- Você, por usar este projeto! 😊

---

## 📞 Suporte

Encontrou um bug? Tem uma sugestão? 

- 🐛 [Abra uma Issue](https://github.com/marlonmotta/mmti-windows-repair/issues)
- 💬 [Discussões](https://github.com/marlonmotta/mmti-windows-repair/discussions)
- 📧 Email: marlonmotta.ti@gmail.com

---

## 📈 Roadmap

- [ ] Interface gráfica (GUI) opcional
- [ ] Modo agendamento automático
- [ ] Relatórios em HTML
- [ ] Suporte para Windows Server
- [ ] Tradução para outros idiomas

---

## ⭐ Gostou? Dê uma estrela!

Se este projeto foi útil para você, considere dar uma ⭐ no repositório!

Isso ajuda outras pessoas a encontrarem a ferramenta e motiva a continuar desenvolvendo. 😊

---

<div align="center">

**Continue explorando. Continue aprendendo.** 🔥💻🎯

**Sistema mm.ti Lab - Windows Repair Tool v1.0**

*Feito com ❤️ por Marlon Motta e equipe*

</div>

