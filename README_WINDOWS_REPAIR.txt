╔════════════════════════════════════════════════════════════════════╗
║                                                                    ║
║          WINDOWS REPAIR TOOL - GUIA DE USO COMPLETO                ║
║                                                                    ║
║             Sistema mm.ti Lab - Versão 1.0                         ║
║          Script criado por Marlon Motta e equipe                   ║
║                                                                    ║
╚════════════════════════════════════════════════════════════════════╝


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📦 O QUE É ESTE SISTEMA?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Este é um conjunto de scripts automatizados para reparar problemas
comuns do Windows, incluindo arquivos corrompidos, erros do sistema
e problemas de atualização.


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📁 ARQUIVOS INCLUÍDOS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔵 VERSÕES BATCH (.BAT) - Compatibilidade Universal

1. WINrepair-lite.bat (VERSÃO SIMPLES)
   ├─ DISM (3 etapas de verificação e reparo)
   ├─ SFC (verificação de arquivos do sistema)
   ├─ Sistema anti-travamento automático
   ├─ Barras de progresso visuais
   └─ Tempo estimado: 15-60 minutos

2. WINrepair-full.bat (VERSÃO COMPLETA)
   ├─ Limpeza do cache do Windows Update
   ├─ Limpeza de arquivos temporários
   ├─ DISM (3 etapas de verificação e reparo)
   ├─ SFC (verificação de arquivos do sistema)
   ├─ Limpeza de componentes antigos
   ├─ Verificação do disco (opcional)
   ├─ Sistema anti-travamento automático
   ├─ Barras de progresso visuais
   └─ Tempo estimado: 30-90 minutos

3. auto-enter-helper.vbs (HELPER DO SISTEMA)
   └─ Script auxiliar que previne travamentos do DISM

🟢 VERSÕES POWERSH ELL (.PS1) - Recursos Avançados

4. WINrepair-lite.ps1 (VERSÃO SIMPLES - PowerShell)
   ├─ Mesmas funcionalidades da versão .bat
   ├─ Barra de progresso nativa do Windows
   ├─ Auto-enter integrado (não precisa do .vbs)
   ├─ Interface colorida e moderna
   └─ Logs mais detalhados

5. WINrepair-full.ps1 (VERSÃO COMPLETA - PowerShell)
   ├─ Mesmas funcionalidades da versão .bat
   ├─ Barra de progresso nativa do Windows
   ├─ Auto-enter integrado (não precisa do .vbs)
   ├─ Interface colorida e moderna
   └─ Logs mais detalhados

📚 DOCUMENTAÇÃO

6. README_WINDOWS_REPAIR.txt (este arquivo)


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 COMO USAR - PASSO A PASSO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PASSO 0: Escolha BAT ou PowerShell

   ┌────────────────────────────────────────────────────────────────┐
   │ Use versões .BAT SE:                                           │
   │  ✓ Quer máxima compatibilidade (Windows 7/8/10/11)            │
   │  ✓ Prefere algo simples e direto                              │
   │  ✓ Não quer mexer em configurações                            │
   │  → RECOMENDADO para compartilhar com amigos                   │
   └────────────────────────────────────────────────────────────────┘

   ┌────────────────────────────────────────────────────────────────┐
   │ Use versões .PS1 (PowerShell) SE:                             │
   │  ✓ Quer interface mais moderna e colorida                     │
   │  ✓ Gosta de barra de progresso nativa do Windows             │
   │  ✓ Quer logs mais detalhados                                  │
   │  ✓ Tem Windows 10/11 (PowerShell 5.1+)                       │
   │  → RECOMENDADO para usuários técnicos                         │
   └────────────────────────────────────────────────────────────────┘

PASSO 1: Escolha LITE ou FULL
   
   ┌────────────────────────────────────────────────────────────────┐
   │ Use WINrepair-lite.bat SE:                                     │
   │  ✓ É a primeira vez que está tentando reparar                 │
   │  ✓ Tem problemas simples de corrupção                         │
   │  ✓ Precisa de um reparo rápido                                │
   └────────────────────────────────────────────────────────────────┘

   ┌────────────────────────────────────────────────────────────────┐
   │ Use WINrepair-full.bat SE:                                     │
   │  ✓ O WINrepair-lite não resolveu o problema                   │
   │  ✓ Tem problemas com Windows Update                           │
   │  ✓ Quer fazer uma manutenção preventiva completa              │
   │  ✓ Quer liberar espaço em disco também                        │
   └────────────────────────────────────────────────────────────────┘


PASSO 2: Execute como Administrador

   ⚠️  IMPORTANTE: É OBRIGATÓRIO executar como administrador!
   
   📦 Para arquivos .BAT:
   1. Clique com o BOTÃO DIREITO no arquivo .bat
   2. Selecione "Executar como administrador"
   3. Clique em "Sim" na janela de confirmação do Windows

   📦 Para arquivos .PS1 (PowerShell):
   1. Clique com o BOTÃO DIREITO no arquivo .ps1
   2. Selecione "Executar com PowerShell"
   3. Se der erro de ExecutionPolicy, veja a seção FAQ abaixo
   4. Clique em "Sim" na janela de confirmação do Windows


PASSO 3: Escolha o modo de execução

   O script irá perguntar:
   
   [1] AUTOMÁTICO
       → Executa tudo sem pausas
       → Você pode sair e voltar depois
       → Ideal para deixar rodando enquanto faz outras coisas
   
   [2] PASSO A PASSO
       → Pausa entre cada etapa
       → Você acompanha o progresso
       → Ideal se quer entender o que está acontecendo


PASSO 4: Aguarde a conclusão

   - O processo pode demorar bastante (veja estimativas acima)
   - NÃO FECHE A JANELA durante o processo
   - NÃO DESLIGUE o computador durante o processo
   - Se escolheu modo AUTOMÁTICO, pode sair e voltar depois


PASSO 5: Verifique os resultados

   - Ao final, uma tela com resumo será exibida
   - Um LOG detalhado será salvo na sua Área de Trabalho
   - Pasta do log: Desktop\WinRepair-Logs\


PASSO 6: Reinicie o computador

   ⚠️  IMPORTANTE: SEMPRE reinicie após o reparo!
   
   - As correções só são aplicadas após reiniciar
   - Se agendou CHKDSK, ele rodará na inicialização


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎯 QUANDO USAR CADA VERSÃO?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

┌─────────────────────────────────────────────────────────────────┐
│ SINTOMA                              │ VERSÃO RECOMENDADA        │
├──────────────────────────────────────┼───────────────────────────┤
│ Tela azul (BSOD) aleatória          │ LITE primeiro, depois FULL│
│ Windows Update não funciona          │ FULL                      │
│ Arquivos do sistema corrompidos     │ LITE                      │
│ Programas travando muito             │ LITE                      │
│ Erros ao instalar atualizações      │ FULL                      │
│ PC lento (manutenção preventiva)    │ FULL                      │
│ Mensagens de erro estranhas         │ LITE primeiro             │
│ Problemas após atualização          │ FULL                      │
└──────────────────────────────────────┴───────────────────────────┘


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 O QUE CADA COMANDO FAZ?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

DISM (Deployment Image Servicing and Management)
├─ CheckHealth:    Verifica se há problemas (rápido)
├─ ScanHealth:     Analisa profundamente (pode demorar)
└─ RestoreHealth:  Corrige os problemas encontrados (mais demorado)

SFC (System File Checker)
└─ Verifica e repara arquivos de sistema corrompidos

Component Store Cleanup (apenas versão FULL)
└─ Remove versões antigas de componentes do Windows
   (libera espaço em disco)

CHKDSK (apenas versão FULL, opcional)
└─ Verifica e repara erros no disco rígido
   (roda na próxima inicialização)


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️  AVISOS IMPORTANTES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. ✅ SEMPRE execute como Administrador
2. ✅ SEMPRE reinicie o PC após o reparo
3. ✅ NÃO interrompa o processo no meio
4. ✅ Conecte o notebook na tomada (não deixe só na bateria)
5. ✅ Feche outros programas antes de começar
6. ✅ Faça backup de arquivos importantes antes (recomendado)
7. ⚠️  O processo PODE DEMORAR MUITO (seja paciente!)
8. ⚠️  É normal a CPU ficar alta durante o processo
9. ⚠️  Alguns comandos podem mostrar "Erro 87" (é normal em alguns casos)


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🛡️  SISTEMA ANTI-TRAVAMENTO (NOVIDADE!)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

O QUE É?
O DISM às vezes "trava" e precisa apertar Enter para continuar.
Nosso sistema resolve isso AUTOMATICAMENTE!

COMO FUNCIONA?
   ✓ Envia Enter automaticamente a cada 2 minutos
   ✓ Funciona em BACKGROUND (invisível)
   ✓ Você pode usar o PC normalmente durante o processo
   ✓ Minimizar a janela, ver YouTube, jogar - SEM PROBLEMAS!
   ✓ É desativado automaticamente ao finalizar

VERSÕES .BAT: Usa o arquivo auto-enter-helper.vbs
VERSÕES .PS1: Sistema integrado no próprio script

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📝 ONDE ENCONTRAR OS LOGS?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Os logs são salvos automaticamente em:

   📂 C:\Users\[SEU_USUÁRIO]\Desktop\WinRepair-Logs\

Nome do arquivo (.BAT):
   reparo_lite_[DATA]_[HORA].log
   reparo_full_[DATA]_[HORA].log

Nome do arquivo (.PS1):
   reparo_lite_ps_[DATA]_[HORA].log
   reparo_full_ps_[DATA]_[HORA].log

O log contém:
   • Todos os comandos executados
   • Saída completa de cada comando
   • Códigos de erro (se houver)
   • Resumo final com todos os resultados


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
❓ PERGUNTAS FREQUENTES (FAQ)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

P: Posso usar o computador durante o processo?
R: Pode, mas NÃO É RECOMENDADO. O processo ficará mais lento e você
   pode travar o PC. Melhor deixar rodando e fazer outra coisa.

P: Meu PC reiniciou sozinho, perdi o progresso?
R: Não! O log está salvo na Área de Trabalho. Mas você precisará
   executar o script novamente do início.

P: Deu erro, o que faço?
R: Verifique o arquivo de log e entre em contato (veja abaixo).

P: Posso executar os dois scripts seguidos?
R: Não recomendado. Execute um, reinicie, veja se resolveu. Se não,
   execute o outro.

P: Com que frequência devo executar?
R: Para manutenção preventiva: a cada 3-6 meses com a versão FULL.

P: Vai apagar meus arquivos?
R: NÃO! Apenas repara arquivos do SISTEMA. Seus documentos, fotos,
   vídeos estão seguros. Mas sempre recomendamos ter backup!

P: Funciona em qual versão do Windows?
R: Windows 7, 8, 8.1, 10 e 11. Todas as edições.
   Versões .BAT: Todas as versões do Windows
   Versões .PS1: Windows 10/11 (PowerShell 5.1+)

P: Precisa de internet?
R: Para o DISM RestoreHealth funcionar 100%, é RECOMENDADO ter
   internet (ele baixa arquivos de correção). Mas não é obrigatório.

P: Como executar scripts PowerShell se der erro?
R: Se aparecer "não pode ser carregado porque a execução de scripts
   foi desabilitada", faça:
   
   1. Abra PowerShell como ADMINISTRADOR
   2. Execute: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   3. Confirme com "S"
   4. Agora pode executar os scripts .ps1

P: O sistema anti-travamento realmente funciona?
R: SIM! O DISM frequentemente trava em 20%, 62%, 84%. Nosso sistema
   envia Enter automaticamente a cada 2 minutos. Você pode deixar
   rodando e fazer outras coisas no PC sem preocupação!

P: Qual a diferença entre .BAT e .PS1?
R: Funcionalidades são as MESMAS. Diferenças:
   
   .BAT → Mais simples, universal, barra de progresso ASCII
   .PS1 → Interface moderna, barra nativa do Windows, mais colorido
   
   Ambos têm sistema anti-travamento e logs completos.


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🆘 PROBLEMAS? PRECISA DE AJUDA?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Se o script não resolveu seu problema ou encontrou erros:

1. Envie o arquivo de LOG junto com sua dúvida
2. Descreva o problema que estava acontecendo
3. Diga qual versão executou (LITE ou FULL)
4. Informe sua versão do Windows

Contato:
   📧 Email: marlonmotta.ti@gmail.com
   👤 Criado por: Marlon Motta e equipe
   🏷️  Sistema: mm.ti Lab - Windows Repair Tool


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💖 GOSTOU? AJUDE A DIVULGAR!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Se este script resolveu seu problema:

✅ Compartilhe com amigos e familiares
✅ Envie feedback sobre sua experiência
✅ Sugira melhorias

Isso ajuda mais pessoas a manterem seus PCs funcionando corretamente!

Feedbacks são sempre bem-vindos em: marlonmotta.ti@gmail.com


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔥 DICAS EXTRAS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Mantenha o Windows Update sempre ativo
2. Faça backup regular dos seus arquivos
3. Use antivírus atualizado
4. Evite sites e downloads suspeitos
5. Execute este script a cada 3-6 meses como manutenção preventiva
6. Mantenha pelo menos 15-20GB livres no disco C:\
7. Desinstale programas que não usa mais


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Sistema mm.ti Lab - Windows Repair Tool v1.0
Script criado por Marlon Motta e equipe
Email: marlonmotta.ti@gmail.com

Continue explorando. Continue aprendendo. 🔥💻🎯

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

