@echo off
chcp 65001 >nul
title Reparo do Windows - Versão Lite

:: ========================================
:: CONFIGURAÇÃO DE VARIÁVEIS GLOBAIS
:: ========================================
set SCRIPT_VERSION=1.0
set HELPER_RUNNING=0

:: ========================================
:: VERIFICAÇÃO DE PRIVILÉGIOS ADMINISTRATIVOS
:: ========================================
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ╔════════════════════════════════════════════════════════╗
    echo ║  ERRO: Este script precisa ser executado como         ║
    echo ║  ADMINISTRADOR!                                        ║
    echo ║                                                        ║
    echo ║  Clique com o botão direito no arquivo e escolha:     ║
    echo ║  "Executar como administrador"                        ║
    echo ╚════════════════════════════════════════════════════════╝
    echo.
    pause
    exit /b 1
)

cls
color 0A
echo.
echo ╔════════════════════════════════════════════════════════╗
echo ║     REPARO DO SISTEMA WINDOWS - VERSÃO LITE           ║
echo ║                                                        ║
echo ║  Este script irá executar:                            ║
echo ║  - DISM (Verificação e reparo da imagem do Windows)   ║
echo ║  - SFC (Verificação de arquivos do sistema)           ║
echo ║                                                        ║
echo ║  ATENÇÃO: Este processo pode demorar de 15 a 60       ║
echo ║  minutos dependendo do seu computador.                ║
echo ╚════════════════════════════════════════════════════════╝
echo.
echo ┌────────────────────────────────────────────────────────┐
echo │              ESCOLHA O MODO DE EXECUÇÃO               │
echo └────────────────────────────────────────────────────────┘
echo.
echo [1] AUTOMÁTICO - Executa tudo sem pausas (recomendado)
echo     ^> Aperte uma tecla e deixe rodando
echo     ^> Ideal se você vai sair e voltar depois
echo.
echo [2] PASSO A PASSO - Pausa entre cada etapa
echo     ^> Você acompanha cada comando
echo     ^> Ideal para ver o que está acontecendo
echo.
set /p modo="Digite 1 ou 2: "

if "%modo%"=="1" (
    set MODO_AUTO=1
    echo.
    echo [MODO AUTOMÁTICO SELECIONADO]
) else if "%modo%"=="2" (
    set MODO_AUTO=0
    echo.
    echo [MODO PASSO A PASSO SELECIONADO]
) else (
    echo.
    echo Opção inválida! Usando modo AUTOMÁTICO por padrão.
    set MODO_AUTO=1
    timeout /t 3 >nul
)

echo.
echo Deseja continuar? (S/N)
set /p confirma=^> 
if /i not "%confirma%"=="S" (
    echo.
    echo Operação cancelada pelo usuário.
    timeout /t 3 >nul
    exit /b 0
)

:: Criar pasta de logs
set LOGDIR=%USERPROFILE%\Desktop\WinRepair-Logs
if not exist "%LOGDIR%" mkdir "%LOGDIR%"

:: Nome do arquivo de log com data/hora
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set LOGFILE=%LOGDIR%\reparo_lite_%datetime:~0,8%_%datetime:~8,6%.log

:: ========================================
:: INICIAR AUTO-ENTER HELPER
:: ========================================
echo.
echo Iniciando sistema anti-travamento...
if exist "%~dp0auto-enter-helper.vbs" (
    start /min wscript.exe "%~dp0auto-enter-helper.vbs"
    set HELPER_RUNNING=1
    echo [OK] Helper ativado - Sistema protegido contra travamentos do DISM
) else (
    echo [AVISO] auto-enter-helper.vbs não encontrado - continuando sem proteção
    set HELPER_RUNNING=0
)
echo.
timeout /t 2 >nul

cls
echo.
echo ╔════════════════════════════════════════════════════════╗
echo ║                 INICIANDO REPARO...                    ║
echo ╚════════════════════════════════════════════════════════╝
echo.
if %HELPER_RUNNING% equ 1 (
    echo [✓] Sistema anti-travamento: ATIVO
    echo [✓] Você pode minimizar esta janela e usar o PC normalmente
    echo.
)
echo Log será salvo em: %LOGFILE%
echo.

:: ========================================
:: ETAPA 1: DISM CheckHealth
:: ========================================
echo ┌────────────────────────────────────────────────────────┐
echo │ [1/4] DISM - Verificação Rápida da Imagem            │
echo └────────────────────────────────────────────────────────┘
echo.
echo Verificando se existem problemas na imagem do Windows...
echo ⏱️  Tempo estimado: 2-5 minutos
echo 💡 Dica: Você pode usar o PC normalmente durante o processo!
echo.

echo ========== DISM CheckHealth ========== >> "%LOGFILE%"
echo Data/Hora: %date% %time% >> "%LOGFILE%"
echo. >> "%LOGFILE%"

DISM /Online /Cleanup-Image /CheckHealth >> "%LOGFILE%" 2>&1
set DISM_CHECK_ERROR=%errorlevel%

if %DISM_CHECK_ERROR% equ 0 (
    echo [OK] Verificação rápida concluída com sucesso!
    echo Status: SUCESSO >> "%LOGFILE%"
) else (
    echo [AVISO] Código de erro: %DISM_CHECK_ERROR%
    echo Status: ERRO %DISM_CHECK_ERROR% >> "%LOGFILE%"
)
echo. >> "%LOGFILE%"
echo.
if %MODO_AUTO% equ 0 (
    echo Pressione qualquer tecla para continuar...
    pause >nul
) else (
    echo [Modo automático - Continuando em 2 segundos...]
    timeout /t 2 >nul
)

:: ========================================
:: ETAPA 2: DISM ScanHealth
:: ========================================
cls
echo.
echo ┌────────────────────────────────────────────────────────┐
echo │ [2/4] DISM - Verificação Profunda da Imagem          │
echo └────────────────────────────────────────────────────────┘
echo.
echo Analisando profundamente a integridade do sistema...
echo ⏱️  Tempo estimado: 5-15 minutos
echo 🛡️  Sistema anti-travamento ativo - Continue usando o PC!
echo.
echo ┌─ PROGRESSO ────────────────────────────────────────────┐
echo │ ░░░░░░░░░░░░░░░░░░░░░░░░░░░                    25%    │
echo └────────────────────────────────────────────────────────┘
echo.

echo ========== DISM ScanHealth ========== >> "%LOGFILE%"
echo Data/Hora: %date% %time% >> "%LOGFILE%"
echo. >> "%LOGFILE%"

DISM /Online /Cleanup-Image /ScanHealth >> "%LOGFILE%" 2>&1
set DISM_SCAN_ERROR=%errorlevel%

if %DISM_SCAN_ERROR% equ 0 (
    echo [OK] Varredura profunda concluída com sucesso!
    echo Status: SUCESSO >> "%LOGFILE%"
) else (
    echo [AVISO] Código de erro: %DISM_SCAN_ERROR%
    echo Status: ERRO %DISM_SCAN_ERROR% >> "%LOGFILE%"
)
echo. >> "%LOGFILE%"
echo.
if %MODO_AUTO% equ 0 (
    echo Pressione qualquer tecla para continuar...
    pause >nul
) else (
    echo [Modo automático - Continuando em 2 segundos...]
    timeout /t 2 >nul
)

:: ========================================
:: ETAPA 3: DISM RestoreHealth
:: ========================================
cls
echo.
echo ┌────────────────────────────────────────────────────────┐
echo │ [3/4] DISM - Reparando a Imagem do Windows           │
echo └────────────────────────────────────────────────────────┘
echo.
echo Corrigindo problemas encontrados na imagem do sistema...
echo ⏱️  Tempo estimado: 20-40 minutos
echo ⚠️  IMPORTANTE: Esta etapa pode PARECER travada às vezes!
echo 🛡️  Não se preocupe: Sistema anti-travamento está ativo
echo 💡 Aproveite e tome um café! ☕
echo.
echo ┌─ PROGRESSO ────────────────────────────────────────────┐
echo │ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░           50%    │
echo └────────────────────────────────────────────────────────┘
echo.

echo ========== DISM RestoreHealth ========== >> "%LOGFILE%"
echo Data/Hora: %date% %time% >> "%LOGFILE%"
echo. >> "%LOGFILE%"

DISM /Online /Cleanup-Image /RestoreHealth >> "%LOGFILE%" 2>&1
set DISM_RESTORE_ERROR=%errorlevel%

if %DISM_RESTORE_ERROR% equ 0 (
    echo [OK] Reparo da imagem concluído com sucesso!
    echo Status: SUCESSO >> "%LOGFILE%"
) else (
    echo [AVISO] Código de erro: %DISM_RESTORE_ERROR%
    echo Status: ERRO %DISM_RESTORE_ERROR% >> "%LOGFILE%"
)
echo. >> "%LOGFILE%"
echo.
if %MODO_AUTO% equ 0 (
    echo Pressione qualquer tecla para continuar...
    pause >nul
) else (
    echo [Modo automático - Continuando em 2 segundos...]
    timeout /t 2 >nul
)

:: ========================================
:: ETAPA 4: SFC ScanNow
:: ========================================
cls
echo.
echo ┌────────────────────────────────────────────────────────┐
echo │ [4/4] SFC - Verificação dos Arquivos do Sistema      │
echo └────────────────────────────────────────────────────────┘
echo.
echo Verificando e reparando arquivos corrompidos do Windows...
echo ⏱️  Tempo estimado: 10-15 minutos
echo 🎯 Última etapa! Quase lá!
echo.
echo ┌─ PROGRESSO ────────────────────────────────────────────┐
echo │ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░      75%    │
echo └────────────────────────────────────────────────────────┘
echo.

echo ========== SFC ScanNow ========== >> "%LOGFILE%"
echo Data/Hora: %date% %time% >> "%LOGFILE%"
echo. >> "%LOGFILE%"

SFC /scannow >> "%LOGFILE%" 2>&1
set SFC_ERROR=%errorlevel%

if %SFC_ERROR% equ 0 (
    echo [OK] Verificação SFC concluída com sucesso!
    echo Status: SUCESSO >> "%LOGFILE%"
) else (
    echo [AVISO] Código de erro: %SFC_ERROR%
    echo Status: ERRO %SFC_ERROR% >> "%LOGFILE%"
)
echo. >> "%LOGFILE%"

:: ========================================
:: RESUMO FINAL
:: ========================================
cls
echo.
echo ╔════════════════════════════════════════════════════════╗
echo ║       🎉 REPARO CONCLUÍDO COM SUCESSO!                ║
echo ╚════════════════════════════════════════════════════════╝
echo.
echo Seu sistema Windows foi reparado! 🚀
echo.
echo ┌─ RESUMO DO PROCESSO ───────────────────────────────────┐
echo │                                                        │

if %DISM_CHECK_ERROR% equ 0 (
    echo │  ✓ DISM CheckHealth      : CONCLUÍDO                  │
) else (
    echo │  ✗ DISM CheckHealth      : ERRO                       │
)

if %DISM_SCAN_ERROR% equ 0 (
    echo │  ✓ DISM ScanHealth       : CONCLUÍDO                  │
) else (
    echo │  ✗ DISM ScanHealth       : ERRO                       │
)

if %DISM_RESTORE_ERROR% equ 0 (
    echo │  ✓ DISM RestoreHealth    : CONCLUÍDO                  │
) else (
    echo │  ✗ DISM RestoreHealth    : ERRO                       │
)

if %SFC_ERROR% equ 0 (
    echo │  ✓ SFC ScanNow           : CONCLUÍDO                  │
) else (
    echo │  ✗ SFC ScanNow           : ERRO                       │
)

echo │                                                        │
echo └────────────────────────────────────────────────────────┘
echo.
echo 📂 LOG DETALHADO SALVO EM:
echo    %LOGFILE%
echo.
echo ───────────────────────────────────────────────────────────
echo.
echo 💡 PRÓXIMOS PASSOS RECOMENDADOS:
echo.
echo   1️⃣  REINICIE O COMPUTADOR para aplicar todas as correções
echo   2️⃣  Verifique se os problemas foram resolvidos
echo   3️⃣  Mantenha o Windows Update ativo e atualizado
echo   4️⃣  Execute este reparo periodicamente (a cada 3-6 meses)
echo.
echo ⚠️  SE OS PROBLEMAS PERSISTIREM:
echo   • Consulte o arquivo de log para detalhes técnicos
echo   • Tente executar a versão FULL (WINrepair-full.bat)
echo   • Entre em contato para suporte (dados abaixo)
echo.
echo ───────────────────────────────────────────────────────────
echo.
echo 📞 SUPORTE E CONTATO
echo.
echo Script criado por: Marlon Motta e equipe
echo Sistema: mm.ti Lab - Windows Repair Tool
echo Email: marlonmotta.ti@gmail.com
echo.
echo Dúvidas? Sugestões? Problemas técnicos?
echo Entre em contato pelo email acima. Adoraria saber se este
echo script ajudou a resolver seu problema! 😊
echo.
echo Feedbacks são sempre bem-vindos! Se este script foi útil,
echo compartilhe com outros amigos que precisam de ajuda com
echo Windows. Isso ajuda mais pessoas a manterem seus PCs
echo funcionando corretamente!
echo.
echo ───────────────────────────────────────────────────────────
echo.
echo 🚀 SISTEMA REPARADO E PRONTO PARA USO!
echo.
echo Lembre-se: manutenção preventiva é a chave para um PC
echo saudável. Execute este script periodicamente e mantenha
echo backups dos seus arquivos importantes.
echo.
echo Continue explorando. Continue aprendendo. 🔥💻🎯
echo.
echo ───────────────────────────────────────────────────────────
echo.
echo Sistema mm.ti Lab - Windows Repair Tool v1.0 (LITE)
echo Script criado por Marlon Motta e equipe
echo Email: marlonmotta.ti@gmail.com
echo Processado em: %date% às %time%
echo.
:: ========================================
:: FINALIZAR AUTO-ENTER HELPER
:: ========================================
if %HELPER_RUNNING% equ 1 (
    echo.
    echo Desativando sistema anti-travamento...
    taskkill /f /im wscript.exe /fi "WINDOWTITLE eq auto-enter-helper*" >nul 2>&1
    echo [OK] Helper desativado
    echo.
)

echo ┌─ PROGRESSO ────────────────────────────────────────────┐
echo │ ██████████████████████████████████████████████  100%  │
echo └────────────────────────────────────────────────────────┘
echo.

echo ========== RESUMO FINAL ========== >> "%LOGFILE%"
echo Data/Hora de conclusão: %date% %time% >> "%LOGFILE%"
echo DISM CheckHealth: Código %DISM_CHECK_ERROR% >> "%LOGFILE%"
echo DISM ScanHealth: Código %DISM_SCAN_ERROR% >> "%LOGFILE%"
echo DISM RestoreHealth: Código %DISM_RESTORE_ERROR% >> "%LOGFILE%"
echo SFC ScanNow: Código %SFC_ERROR% >> "%LOGFILE%"
echo. >> "%LOGFILE%"
echo Script criado por: Marlon Motta e equipe >> "%LOGFILE%"
echo Email: marlonmotta.ti@gmail.com >> "%LOGFILE%"
echo Sistema mm.ti Lab - Windows Repair Tool v1.0 (LITE) >> "%LOGFILE%"
echo. >> "%LOGFILE%"

echo Pressione qualquer tecla para fechar...
pause >nul

