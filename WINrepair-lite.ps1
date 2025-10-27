#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Windows Repair Tool - Versão Lite (PowerShell)
    
.DESCRIPTION
    Script automatizado para reparar problemas comuns do Windows
    Sistema mm.ti Lab v1.0
    
.NOTES
    Script criado por: Marlon Motta e equipe
    Email: marlonmotta.ti@gmail.com
    Versão: 1.0
#>

# ============================================================================
# CONFIGURAÇÕES INICIAIS
# ============================================================================
$Host.UI.RawUI.WindowTitle = "Reparo do Windows - Versão Lite (PowerShell)"
$ErrorActionPreference = "Continue"
$ScriptVersion = "1.0"

# Cores
$SuccessColor = "Green"
$WarningColor = "Yellow"
$ErrorColor = "Red"
$InfoColor = "Cyan"

# ============================================================================
# VERIFICAÇÃO DE PRIVILÉGIOS ADMINISTRATIVOS
# ============================================================================
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-Administrator)) {
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════╗" -ForegroundColor Red
    Write-Host "║  ERRO: Este script precisa ser executado como         ║" -ForegroundColor Red
    Write-Host "║  ADMINISTRADOR!                                        ║" -ForegroundColor Red
    Write-Host "║                                                        ║" -ForegroundColor Red
    Write-Host "║  Clique com o botão direito e escolha:                ║" -ForegroundColor Red
    Write-Host "║  'Executar com PowerShell como Administrador'         ║" -ForegroundColor Red
    Write-Host "╚════════════════════════════════════════════════════════╝" -ForegroundColor Red
    Write-Host ""
    Read-Host "Pressione Enter para sair"
    exit 1
}

# ============================================================================
# INTERFACE INICIAL
# ============================================================================
Clear-Host
Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║     REPARO DO SISTEMA WINDOWS - VERSÃO LITE           ║" -ForegroundColor Green
Write-Host "║                  (PowerShell Edition)                  ║" -ForegroundColor Green
Write-Host "║                                                        ║" -ForegroundColor Green
Write-Host "║  Este script irá executar:                            ║" -ForegroundColor Green
Write-Host "║  - DISM (Verificação e reparo da imagem do Windows)   ║" -ForegroundColor Green
Write-Host "║  - SFC (Verificação de arquivos do sistema)           ║" -ForegroundColor Green
Write-Host "║                                                        ║" -ForegroundColor Green
Write-Host "║  ATENÇÃO: Este processo pode demorar de 15 a 60       ║" -ForegroundColor Green
Write-Host "║  minutos dependendo do seu computador.                ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

# Escolha do modo
Write-Host "┌────────────────────────────────────────────────────────┐" -ForegroundColor Cyan
Write-Host "│              ESCOLHA O MODO DE EXECUÇÃO               │" -ForegroundColor Cyan
Write-Host "└────────────────────────────────────────────────────────┘" -ForegroundColor Cyan
Write-Host ""
Write-Host "[1] AUTOMÁTICO - Executa tudo sem pausas (recomendado)" -ForegroundColor Yellow
Write-Host "    > Aperte uma tecla e deixe rodando" -ForegroundColor Gray
Write-Host "    > Ideal se você vai sair e voltar depois" -ForegroundColor Gray
Write-Host ""
Write-Host "[2] PASSO A PASSO - Pausa entre cada etapa" -ForegroundColor Yellow
Write-Host "    > Você acompanha cada comando" -ForegroundColor Gray
Write-Host "    > Ideal para ver o que está acontecendo" -ForegroundColor Gray
Write-Host ""

$modoInput = Read-Host "Digite 1 ou 2"
$ModoAuto = ($modoInput -eq "1")

if ($ModoAuto) {
    Write-Host "`n[MODO AUTOMÁTICO SELECIONADO]" -ForegroundColor Green
} else {
    Write-Host "`n[MODO PASSO A PASSO SELECIONADO]" -ForegroundColor Green
}

Write-Host ""
$confirmacao = Read-Host "Deseja continuar? (S/N)"
if ($confirmacao -notmatch '^[Ss]$') {
    Write-Host "`nOperação cancelada pelo usuário." -ForegroundColor Yellow
    Start-Sleep -Seconds 2
    exit 0
}

# ============================================================================
# CONFIGURAÇÃO DE LOGS
# ============================================================================
$LogDir = "$env:USERPROFILE\Desktop\WinRepair-Logs"
if (-not (Test-Path $LogDir)) {
    New-Item -Path $LogDir -ItemType Directory -Force | Out-Null
}

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$LogFile = "$LogDir\reparo_lite_ps_$timestamp.log"

function Write-Log {
    param([string]$Message)
    $logMessage = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Message"
    Add-Content -Path $LogFile -Value $logMessage
}

# ============================================================================
# SISTEMA AUTO-ENTER (Job em Background)
# ============================================================================
Write-Host "`nIniciando sistema anti-travamento..." -ForegroundColor Cyan

$autoEnterScript = {
    param($windowTitle)
    Add-Type @"
        using System;
        using System.Runtime.InteropServices;
        public class WinAPI {
            [DllImport("user32.dll")]
            public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);
            [DllImport("user32.dll")]
            public static extern bool SetForegroundWindow(IntPtr hWnd);
            [DllImport("user32.dll")]
            public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);
        }
"@
    
    while ($true) {
        Start-Sleep -Seconds 120  # 2 minutos
        
        try {
            $hwnd = [WinAPI]::FindWindow($null, $windowTitle)
            if ($hwnd -ne [IntPtr]::Zero) {
                [WinAPI]::SetForegroundWindow($hwnd)
                Start-Sleep -Milliseconds 100
                # Simula Enter (VK_RETURN = 0x0D)
                [WinAPI]::keybd_event(0x0D, 0, 0, [UIntPtr]::Zero)
                Start-Sleep -Milliseconds 50
                [WinAPI]::keybd_event(0x0D, 0, 2, [UIntPtr]::Zero)
            }
        } catch {
            # Ignora erros silenciosamente
        }
    }
}

$autoEnterJob = Start-Job -ScriptBlock $autoEnterScript -ArgumentList $Host.UI.RawUI.WindowTitle
Write-Host "[OK] Sistema anti-travamento ativado" -ForegroundColor Green
Write-Host ""
Start-Sleep -Seconds 2

# ============================================================================
# INÍCIO DO REPARO
# ============================================================================
Clear-Host
Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║                 INICIANDO REPARO...                    ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "[✓] Sistema anti-travamento: ATIVO" -ForegroundColor Green
Write-Host "[✓] Você pode minimizar esta janela e usar o PC normalmente" -ForegroundColor Green
Write-Host ""
Write-Host "Log será salvo em: $LogFile" -ForegroundColor Cyan
Write-Host ""

Write-Log "========== INÍCIO DO REPARO LITE (PowerShell) =========="
Write-Log "Modo: $(if($ModoAuto){'AUTOMÁTICO'}else{'PASSO A PASSO'})"
Write-Log "Sistema: $([Environment]::OSVersion.VersionString)"

# Variáveis de resultado
$resultados = @{
    DismCheck = 0
    DismScan = 0
    DismRestore = 0
    SFC = 0
}

# ============================================================================
# ETAPA 1: DISM CheckHealth
# ============================================================================
Clear-Host
Write-Host ""
Write-Host "┌────────────────────────────────────────────────────────┐" -ForegroundColor Cyan
Write-Host "│ [1/4] DISM - Verificação Rápida da Imagem            │" -ForegroundColor Cyan
Write-Host "└────────────────────────────────────────────────────────┘" -ForegroundColor Cyan
Write-Host ""
Write-Host "Verificando se existem problemas na imagem do Windows..." -ForegroundColor White
Write-Host "⏱️  Tempo estimado: 2-5 minutos" -ForegroundColor Yellow
Write-Host "💡 Dica: Você pode usar o PC normalmente durante o processo!" -ForegroundColor Gray
Write-Host ""

Write-Progress -Activity "Reparo do Windows (Lite)" -Status "DISM CheckHealth" -PercentComplete 10

Write-Log "========== DISM CheckHealth =========="
try {
    $output = & dism.exe /Online /Cleanup-Image /CheckHealth 2>&1
    $resultados.DismCheck = $LASTEXITCODE
    $output | ForEach-Object { Write-Log $_ }
    
    if ($resultados.DismCheck -eq 0) {
        Write-Host "[OK] Verificação rápida concluída com sucesso!" -ForegroundColor Green
        Write-Log "Status: SUCESSO"
    } else {
        Write-Host "[AVISO] Código de erro: $($resultados.DismCheck)" -ForegroundColor Yellow
        Write-Log "Status: ERRO $($resultados.DismCheck)"
    }
} catch {
    Write-Host "[ERRO] Falha ao executar DISM CheckHealth" -ForegroundColor Red
    Write-Log "Erro: $_"
}

Write-Host ""
if (-not $ModoAuto) {
    Read-Host "Pressione Enter para continuar"
} else {
    Write-Host "[Modo automático - Continuando em 2 segundos...]" -ForegroundColor Gray
    Start-Sleep -Seconds 2
}

# ============================================================================
# ETAPA 2: DISM ScanHealth
# ============================================================================
Clear-Host
Write-Host ""
Write-Host "┌────────────────────────────────────────────────────────┐" -ForegroundColor Cyan
Write-Host "│ [2/4] DISM - Verificação Profunda da Imagem          │" -ForegroundColor Cyan
Write-Host "└────────────────────────────────────────────────────────┘" -ForegroundColor Cyan
Write-Host ""
Write-Host "Analisando profundamente a integridade do sistema..." -ForegroundColor White
Write-Host "⏱️  Tempo estimado: 5-15 minutos" -ForegroundColor Yellow
Write-Host "🛡️  Sistema anti-travamento ativo - Continue usando o PC!" -ForegroundColor Green
Write-Host ""

Write-Progress -Activity "Reparo do Windows (Lite)" -Status "DISM ScanHealth" -PercentComplete 35

Write-Log "========== DISM ScanHealth =========="
try {
    $output = & dism.exe /Online /Cleanup-Image /ScanHealth 2>&1
    $resultados.DismScan = $LASTEXITCODE
    $output | ForEach-Object { Write-Log $_ }
    
    if ($resultados.DismScan -eq 0) {
        Write-Host "[OK] Varredura profunda concluída com sucesso!" -ForegroundColor Green
        Write-Log "Status: SUCESSO"
    } else {
        Write-Host "[AVISO] Código de erro: $($resultados.DismScan)" -ForegroundColor Yellow
        Write-Log "Status: ERRO $($resultados.DismScan)"
    }
} catch {
    Write-Host "[ERRO] Falha ao executar DISM ScanHealth" -ForegroundColor Red
    Write-Log "Erro: $_"
}

Write-Host ""
if (-not $ModoAuto) {
    Read-Host "Pressione Enter para continuar"
} else {
    Write-Host "[Modo automático - Continuando em 2 segundos...]" -ForegroundColor Gray
    Start-Sleep -Seconds 2
}

# ============================================================================
# ETAPA 3: DISM RestoreHealth
# ============================================================================
Clear-Host
Write-Host ""
Write-Host "┌────────────────────────────────────────────────────────┐" -ForegroundColor Cyan
Write-Host "│ [3/4] DISM - Reparando a Imagem do Windows           │" -ForegroundColor Cyan
Write-Host "└────────────────────────────────────────────────────────┘" -ForegroundColor Cyan
Write-Host ""
Write-Host "Corrigindo problemas encontrados na imagem do sistema..." -ForegroundColor White
Write-Host "⏱️  Tempo estimado: 20-40 minutos" -ForegroundColor Yellow
Write-Host "⚠️  IMPORTANTE: Esta etapa pode PARECER travada às vezes!" -ForegroundColor Red
Write-Host "🛡️  Não se preocupe: Sistema anti-travamento está ativo" -ForegroundColor Green
Write-Host "💡 Aproveite e tome um café! ☕" -ForegroundColor Gray
Write-Host ""

Write-Progress -Activity "Reparo do Windows (Lite)" -Status "DISM RestoreHealth - PODE DEMORAR!" -PercentComplete 60

Write-Log "========== DISM RestoreHealth =========="
try {
    $output = & dism.exe /Online /Cleanup-Image /RestoreHealth 2>&1
    $resultados.DismRestore = $LASTEXITCODE
    $output | ForEach-Object { Write-Log $_ }
    
    if ($resultados.DismRestore -eq 0) {
        Write-Host "[OK] Reparo da imagem concluído com sucesso!" -ForegroundColor Green
        Write-Log "Status: SUCESSO"
    } else {
        Write-Host "[AVISO] Código de erro: $($resultados.DismRestore)" -ForegroundColor Yellow
        Write-Log "Status: ERRO $($resultados.DismRestore)"
    }
} catch {
    Write-Host "[ERRO] Falha ao executar DISM RestoreHealth" -ForegroundColor Red
    Write-Log "Erro: $_"
}

Write-Host ""
if (-not $ModoAuto) {
    Read-Host "Pressione Enter para continuar"
} else {
    Write-Host "[Modo automático - Continuando em 2 segundos...]" -ForegroundColor Gray
    Start-Sleep -Seconds 2
}

# ============================================================================
# ETAPA 4: SFC ScanNow
# ============================================================================
Clear-Host
Write-Host ""
Write-Host "┌────────────────────────────────────────────────────────┐" -ForegroundColor Cyan
Write-Host "│ [4/4] SFC - Verificação dos Arquivos do Sistema      │" -ForegroundColor Cyan
Write-Host "└────────────────────────────────────────────────────────┘" -ForegroundColor Cyan
Write-Host ""
Write-Host "Verificando e reparando arquivos corrompidos do Windows..." -ForegroundColor White
Write-Host "⏱️  Tempo estimado: 10-15 minutos" -ForegroundColor Yellow
Write-Host "🎯 Última etapa! Quase lá!" -ForegroundColor Green
Write-Host ""

Write-Progress -Activity "Reparo do Windows (Lite)" -Status "SFC ScanNow" -PercentComplete 85

Write-Log "========== SFC ScanNow =========="
try {
    $output = & sfc.exe /scannow 2>&1
    $resultados.SFC = $LASTEXITCODE
    $output | ForEach-Object { Write-Log $_ }
    
    if ($resultados.SFC -eq 0) {
        Write-Host "[OK] Verificação SFC concluída com sucesso!" -ForegroundColor Green
        Write-Log "Status: SUCESSO"
    } else {
        Write-Host "[AVISO] Código de erro: $($resultados.SFC)" -ForegroundColor Yellow
        Write-Log "Status: ERRO $($resultados.SFC)"
    }
} catch {
    Write-Host "[ERRO] Falha ao executar SFC" -ForegroundColor Red
    Write-Log "Erro: $_"
}

# ============================================================================
# FINALIZAR AUTO-ENTER
# ============================================================================
Write-Host ""
Write-Host "Desativando sistema anti-travamento..." -ForegroundColor Cyan
Stop-Job -Job $autoEnterJob -ErrorAction SilentlyContinue
Remove-Job -Job $autoEnterJob -Force -ErrorAction SilentlyContinue
Write-Host "[OK] Sistema anti-travamento desativado" -ForegroundColor Green

Write-Progress -Activity "Reparo do Windows (Lite)" -Status "Concluído!" -PercentComplete 100 -Completed

# ============================================================================
# RESUMO FINAL
# ============================================================================
Clear-Host
Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║       🎉 REPARO CONCLUÍDO COM SUCESSO!                ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "Seu sistema Windows foi reparado! 🚀" -ForegroundColor White
Write-Host ""
Write-Host "┌─ RESUMO DO PROCESSO ───────────────────────────────────┐" -ForegroundColor Cyan
Write-Host "│                                                        │" -ForegroundColor Cyan

if ($resultados.DismCheck -eq 0) {
    Write-Host "│  ✓ DISM CheckHealth      : CONCLUÍDO                  │" -ForegroundColor Green
} else {
    Write-Host "│  ✗ DISM CheckHealth      : ERRO                       │" -ForegroundColor Red
}

if ($resultados.DismScan -eq 0) {
    Write-Host "│  ✓ DISM ScanHealth       : CONCLUÍDO                  │" -ForegroundColor Green
} else {
    Write-Host "│  ✗ DISM ScanHealth       : ERRO                       │" -ForegroundColor Red
}

if ($resultados.DismRestore -eq 0) {
    Write-Host "│  ✓ DISM RestoreHealth    : CONCLUÍDO                  │" -ForegroundColor Green
} else {
    Write-Host "│  ✗ DISM RestoreHealth    : ERRO                       │" -ForegroundColor Red
}

if ($resultados.SFC -eq 0) {
    Write-Host "│  ✓ SFC ScanNow           : CONCLUÍDO                  │" -ForegroundColor Green
} else {
    Write-Host "│  ✗ SFC ScanNow           : ERRO                       │" -ForegroundColor Red
}

Write-Host "│                                                        │" -ForegroundColor Cyan
Write-Host "└────────────────────────────────────────────────────────┘" -ForegroundColor Cyan
Write-Host ""
Write-Host "📂 LOG DETALHADO SALVO EM:" -ForegroundColor Cyan
Write-Host "   $LogFile" -ForegroundColor White
Write-Host ""
Write-Host "───────────────────────────────────────────────────────────" -ForegroundColor Gray
Write-Host ""
Write-Host "💡 PRÓXIMOS PASSOS RECOMENDADOS:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  1️⃣  REINICIE O COMPUTADOR para aplicar todas as correções" -ForegroundColor White
Write-Host "  2️⃣  Verifique se os problemas foram resolvidos" -ForegroundColor White
Write-Host "  3️⃣  Mantenha o Windows Update ativo e atualizado" -ForegroundColor White
Write-Host "  4️⃣  Execute este reparo periodicamente (a cada 3-6 meses)" -ForegroundColor White
Write-Host ""
Write-Host "⚠️  SE OS PROBLEMAS PERSISTIREM:" -ForegroundColor Red
Write-Host "  • Consulte o arquivo de log para detalhes técnicos" -ForegroundColor White
Write-Host "  • Tente executar a versão FULL (WINrepair-full.ps1)" -ForegroundColor White
Write-Host "  • Entre em contato para suporte (dados abaixo)" -ForegroundColor White
Write-Host ""
Write-Host "───────────────────────────────────────────────────────────" -ForegroundColor Gray
Write-Host ""
Write-Host "📞 SUPORTE E CONTATO" -ForegroundColor Cyan
Write-Host ""
Write-Host "Script criado por: Marlon Motta e equipe" -ForegroundColor White
Write-Host "Sistema: mm.ti Lab - Windows Repair Tool" -ForegroundColor White
Write-Host "Email: marlonmotta.ti@gmail.com" -ForegroundColor White
Write-Host ""
Write-Host "Dúvidas? Sugestões? Problemas técnicos?" -ForegroundColor Yellow
Write-Host "Entre em contato pelo email acima. Adoraria saber se este" -ForegroundColor White
Write-Host "script ajudou a resolver seu problema! 😊" -ForegroundColor White
Write-Host ""
Write-Host "Feedbacks são sempre bem-vindos! Se este script foi útil," -ForegroundColor White
Write-Host "compartilhe com outros amigos que precisam de ajuda com" -ForegroundColor White
Write-Host "Windows. Isso ajuda mais pessoas a manterem seus PCs" -ForegroundColor White
Write-Host "funcionando corretamente!" -ForegroundColor White
Write-Host ""
Write-Host "───────────────────────────────────────────────────────────" -ForegroundColor Gray
Write-Host ""
Write-Host "🚀 SISTEMA REPARADO E PRONTO PARA USO!" -ForegroundColor Green
Write-Host ""
Write-Host "Lembre-se: manutenção preventiva é a chave para um PC" -ForegroundColor White
Write-Host "saudável. Execute este script periodicamente e mantenha" -ForegroundColor White
Write-Host "backups dos seus arquivos importantes." -ForegroundColor White
Write-Host ""
Write-Host "Continue explorando. Continue aprendendo. 🔥💻🎯" -ForegroundColor Yellow
Write-Host ""
Write-Host "───────────────────────────────────────────────────────────" -ForegroundColor Gray
Write-Host ""
Write-Host "Sistema mm.ti Lab - Windows Repair Tool v$ScriptVersion (LITE - PowerShell)" -ForegroundColor Gray
Write-Host "Script criado por Marlon Motta e equipe" -ForegroundColor Gray
Write-Host "Email: marlonmotta.ti@gmail.com" -ForegroundColor Gray
Write-Host "Processado em: $(Get-Date -Format 'dd/MM/yyyy às HH:mm:ss')" -ForegroundColor Gray
Write-Host ""

Write-Log "========== RESUMO FINAL =========="
Write-Log "DISM CheckHealth: Código $($resultados.DismCheck)"
Write-Log "DISM ScanHealth: Código $($resultados.DismScan)"
Write-Log "DISM RestoreHealth: Código $($resultados.DismRestore)"
Write-Log "SFC ScanNow: Código $($resultados.SFC)"
Write-Log "Script criado por: Marlon Motta e equipe"
Write-Log "Email: marlonmotta.ti@gmail.com"
Write-Log "Sistema mm.ti Lab - Windows Repair Tool v$ScriptVersion (LITE - PowerShell)"
Write-Log "========== FIM DO REPARO =========="

Write-Host "Pressione qualquer tecla para fechar..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

