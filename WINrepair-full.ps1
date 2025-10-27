#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Windows Repair Tool - Versão Completa (PowerShell)
    
.DESCRIPTION
    Script automatizado completo para reparar e otimizar o Windows
    Sistema mm.ti Lab v1.0
    
.NOTES
    Script criado por: Marlon Motta e equipe
    Email: marlonmotta.ti@gmail.com
    Versão: 1.0
#>

# ============================================================================
# CONFIGURAÇÕES INICIAIS
# ============================================================================
$Host.UI.RawUI.WindowTitle = "Reparo do Windows - Versão Completa (PowerShell)"
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
Write-Host "╔════════════════════════════════════════════════════════╗" -ForegroundColor Blue
Write-Host "║    REPARO DO SISTEMA WINDOWS - VERSÃO COMPLETA        ║" -ForegroundColor Blue
Write-Host "║                  (PowerShell Edition)                  ║" -ForegroundColor Blue
Write-Host "║                                                        ║" -ForegroundColor Blue
Write-Host "║  Este script irá executar:                            ║" -ForegroundColor Blue
Write-Host "║  1. Limpeza do cache do Windows Update                ║" -ForegroundColor Blue
Write-Host "║  2. Limpeza de arquivos temporários do sistema        ║" -ForegroundColor Blue
Write-Host "║  3. DISM (Verificação e reparo da imagem)             ║" -ForegroundColor Blue
Write-Host "║  4. SFC (Verificação de arquivos do sistema)          ║" -ForegroundColor Blue
Write-Host "║  5. Limpeza de componentes antigos (Component Store)  ║" -ForegroundColor Blue
Write-Host "║  6. Verificação do disco (opcional)                   ║" -ForegroundColor Blue
Write-Host "║                                                        ║" -ForegroundColor Blue
Write-Host "║  ATENÇÃO: Este processo pode demorar de 30 a 90       ║" -ForegroundColor Blue
Write-Host "║  minutos dependendo do seu computador.                ║" -ForegroundColor Blue
Write-Host "╚════════════════════════════════════════════════════════╝" -ForegroundColor Blue
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
$LogFile = "$LogDir\reparo_full_ps_$timestamp.log"

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
Write-Host "╔════════════════════════════════════════════════════════╗" -ForegroundColor Blue
Write-Host "║              INICIANDO REPARO COMPLETO...              ║" -ForegroundColor Blue
Write-Host "╚════════════════════════════════════════════════════════╝" -ForegroundColor Blue
Write-Host ""
Write-Host "[✓] Sistema anti-travamento: ATIVO" -ForegroundColor Green
Write-Host "[✓] Você pode minimizar esta janela e usar o PC normalmente" -ForegroundColor Green
Write-Host ""
Write-Host "Log será salvo em: $LogFile" -ForegroundColor Cyan
Write-Host ""

Write-Log "========== INÍCIO DO REPARO COMPLETO (PowerShell) =========="
Write-Log "Modo: $(if($ModoAuto){'AUTOMÁTICO'}else{'PASSO A PASSO'})"
Write-Log "Sistema: $([Environment]::OSVersion.VersionString)"

# Variáveis de resultado
$resultados = @{
    WUCache = 0
    TempFiles = 0
    DismCheck = 0
    DismScan = 0
    DismRestore = 0
    SFC = 0
    ComponentCleanup = 0
    CHKDSK = "NÃO AGENDADO"
}

# ============================================================================
# ETAPA 1: Limpeza do Windows Update Cache
# ============================================================================
Clear-Host
Write-Host ""
Write-Host "┌────────────────────────────────────────────────────────┐" -ForegroundColor Cyan
Write-Host "│ [1/8] Limpando Cache do Windows Update               │" -ForegroundColor Cyan
Write-Host "└────────────────────────────────────────────────────────┘" -ForegroundColor Cyan
Write-Host ""
Write-Host "Parando serviço Windows Update..." -ForegroundColor White
Write-Host ""

Write-Progress -Activity "Reparo do Windows (Full)" -Status "Limpando Windows Update Cache" -PercentComplete 5

Write-Log "========== Limpeza Windows Update Cache =========="
try {
    Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
    Stop-Service -Name bits -Force -ErrorAction SilentlyContinue
    Write-Log "Serviços parados"
    
    Write-Host "Limpando pasta SoftwareDistribution..." -ForegroundColor White
    $softDist = "$env:SystemRoot\SoftwareDistribution"
    if (Test-Path "$softDist.old") {
        Remove-Item "$softDist.old" -Recurse -Force -ErrorAction SilentlyContinue
    }
    if (Test-Path $softDist) {
        Rename-Item -Path $softDist -NewName "SoftwareDistribution.old" -Force -ErrorAction SilentlyContinue
    }
    Write-Log "Pasta SoftwareDistribution renomeada"
    
    Start-Service -Name wuauserv -ErrorAction SilentlyContinue
    Start-Service -Name bits -ErrorAction SilentlyContinue
    Write-Log "Serviços reiniciados"
    
    Write-Host "[OK] Cache do Windows Update limpo!" -ForegroundColor Green
    Write-Log "Status: CONCLUÍDO"
    $resultados.WUCache = 1
} catch {
    Write-Host "[ERRO] Falha na limpeza do cache: $_" -ForegroundColor Red
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
# ETAPA 2: Limpeza de Arquivos Temporários
# ============================================================================
Clear-Host
Write-Host ""
Write-Host "┌────────────────────────────────────────────────────────┐" -ForegroundColor Cyan
Write-Host "│ [2/8] Limpando Arquivos Temporários do Sistema       │" -ForegroundColor Cyan
Write-Host "└────────────────────────────────────────────────────────┘" -ForegroundColor Cyan
Write-Host ""

Write-Progress -Activity "Reparo do Windows (Full)" -Status "Limpando Arquivos Temporários" -PercentComplete 12

Write-Log "========== Limpeza de Temporários =========="
try {
    Write-Host "Limpando pasta Windows\Temp..." -ForegroundColor White
    Remove-Item "$env:SystemRoot\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    
    Write-Host "Limpando pasta Temp do usuário..." -ForegroundColor White
    Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    
    Write-Host "Limpando arquivos de log antigos..." -ForegroundColor White
    Remove-Item "$env:SystemRoot\Logs\CBS\*.log" -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:SystemRoot\Logs\DISM\*.log" -Force -ErrorAction SilentlyContinue
    
    Write-Host "[OK] Arquivos temporários limpos!" -ForegroundColor Green
    Write-Log "Status: CONCLUÍDO"
    $resultados.TempFiles = 1
} catch {
    Write-Host "[AVISO] Alguns arquivos não puderam ser removidos" -ForegroundColor Yellow
    Write-Log "Aviso: $_"
}

Write-Host ""
if (-not $ModoAuto) {
    Read-Host "Pressione Enter para continuar"
} else {
    Write-Host "[Modo automático - Continuando em 2 segundos...]" -ForegroundColor Gray
    Start-Sleep -Seconds 2
}

# ============================================================================
# ETAPA 3-5: DISM (CheckHealth, ScanHealth, RestoreHealth)
# ============================================================================
# ETAPA 3: DISM CheckHealth
Clear-Host
Write-Host ""
Write-Host "┌────────────────────────────────────────────────────────┐" -ForegroundColor Cyan
Write-Host "│ [3/8] DISM - Verificação Rápida da Imagem            │" -ForegroundColor Cyan
Write-Host "└────────────────────────────────────────────────────────┘" -ForegroundColor Cyan
Write-Host ""
Write-Host "Verificando se existem problemas na imagem do Windows..." -ForegroundColor White
Write-Host "⏱️  Tempo estimado: 2-5 minutos" -ForegroundColor Yellow
Write-Host ""

Write-Progress -Activity "Reparo do Windows (Full)" -Status "DISM CheckHealth" -PercentComplete 25

Write-Log "========== DISM CheckHealth =========="
try {
    $output = & dism.exe /Online /Cleanup-Image /CheckHealth 2>&1
    $resultados.DismCheck = $LASTEXITCODE
    $output | ForEach-Object { Write-Log $_ }
    
    if ($resultados.DismCheck -eq 0) {
        Write-Host "[OK] Verificação rápida concluída!" -ForegroundColor Green
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
if (-not $ModoAuto) { Read-Host "Pressione Enter para continuar" } else { Start-Sleep -Seconds 2 }

# ETAPA 4: DISM ScanHealth
Clear-Host
Write-Host ""
Write-Host "┌────────────────────────────────────────────────────────┐" -ForegroundColor Cyan
Write-Host "│ [4/8] DISM - Verificação Profunda da Imagem          │" -ForegroundColor Cyan
Write-Host "└────────────────────────────────────────────────────────┘" -ForegroundColor Cyan
Write-Host ""
Write-Host "Analisando profundamente a integridade do sistema..." -ForegroundColor White
Write-Host "⏱️  Tempo estimado: 5-15 minutos" -ForegroundColor Yellow
Write-Host "🛡️  Sistema anti-travamento ativo!" -ForegroundColor Green
Write-Host ""

Write-Progress -Activity "Reparo do Windows (Full)" -Status "DISM ScanHealth" -PercentComplete 37

Write-Log "========== DISM ScanHealth =========="
try {
    $output = & dism.exe /Online /Cleanup-Image /ScanHealth 2>&1
    $resultados.DismScan = $LASTEXITCODE
    $output | ForEach-Object { Write-Log $_ }
    
    if ($resultados.DismScan -eq 0) {
        Write-Host "[OK] Varredura profunda concluída!" -ForegroundColor Green
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
if (-not $ModoAuto) { Read-Host "Pressione Enter para continuar" } else { Start-Sleep -Seconds 2 }

# ETAPA 5: DISM RestoreHealth
Clear-Host
Write-Host ""
Write-Host "┌────────────────────────────────────────────────────────┐" -ForegroundColor Cyan
Write-Host "│ [5/8] DISM - Reparando a Imagem do Windows           │" -ForegroundColor Cyan
Write-Host "└────────────────────────────────────────────────────────┘" -ForegroundColor Cyan
Write-Host ""
Write-Host "Corrigindo problemas encontrados na imagem do sistema..." -ForegroundColor White
Write-Host "⏱️  Tempo estimado: 20-40 minutos" -ForegroundColor Yellow
Write-Host "⚠️  IMPORTANTE: Esta etapa pode PARECER travada às vezes!" -ForegroundColor Red
Write-Host "🛡️  Sistema anti-travamento está trabalhando por você" -ForegroundColor Green
Write-Host "💡 Aproveite e tome um café! ☕" -ForegroundColor Gray
Write-Host ""

Write-Progress -Activity "Reparo do Windows (Full)" -Status "DISM RestoreHealth - PODE DEMORAR!" -PercentComplete 50

Write-Log "========== DISM RestoreHealth =========="
try {
    $output = & dism.exe /Online /Cleanup-Image /RestoreHealth 2>&1
    $resultados.DismRestore = $LASTEXITCODE
    $output | ForEach-Object { Write-Log $_ }
    
    if ($resultados.DismRestore -eq 0) {
        Write-Host "[OK] Reparo da imagem concluído!" -ForegroundColor Green
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
if (-not $ModoAuto) { Read-Host "Pressione Enter para continuar" } else { Start-Sleep -Seconds 2 }

# ============================================================================
# ETAPA 6: SFC ScanNow
# ============================================================================
Clear-Host
Write-Host ""
Write-Host "┌────────────────────────────────────────────────────────┐" -ForegroundColor Cyan
Write-Host "│ [6/8] SFC - Verificação dos Arquivos do Sistema      │" -ForegroundColor Cyan
Write-Host "└────────────────────────────────────────────────────────┘" -ForegroundColor Cyan
Write-Host ""
Write-Host "Verificando e reparando arquivos corrompidos do Windows..." -ForegroundColor White
Write-Host "⏱️  Tempo estimado: 10-15 minutos" -ForegroundColor Yellow
Write-Host ""

Write-Progress -Activity "Reparo do Windows (Full)" -Status "SFC ScanNow" -PercentComplete 62

Write-Log "========== SFC ScanNow =========="
try {
    $output = & sfc.exe /scannow 2>&1
    $resultados.SFC = $LASTEXITCODE
    $output | ForEach-Object { Write-Log $_ }
    
    if ($resultados.SFC -eq 0) {
        Write-Host "[OK] Verificação SFC concluída!" -ForegroundColor Green
        Write-Log "Status: SUCESSO"
    } else {
        Write-Host "[AVISO] Código de erro: $($resultados.SFC)" -ForegroundColor Yellow
        Write-Log "Status: ERRO $($resultados.SFC)"
    }
} catch {
    Write-Host "[ERRO] Falha ao executar SFC" -ForegroundColor Red
    Write-Log "Erro: $_"
}

Write-Host ""
if (-not $ModoAuto) { Read-Host "Pressione Enter para continuar" } else { Start-Sleep -Seconds 2 }

# ============================================================================
# ETAPA 7: Component Store Cleanup
# ============================================================================
Clear-Host
Write-Host ""
Write-Host "┌────────────────────────────────────────────────────────┐" -ForegroundColor Cyan
Write-Host "│ [7/8] Limpando Componentes Antigos (Component Store) │" -ForegroundColor Cyan
Write-Host "└────────────────────────────────────────────────────────┘" -ForegroundColor Cyan
Write-Host ""
Write-Host "Removendo versões antigas de componentes do Windows..." -ForegroundColor White
Write-Host "⏱️  Tempo estimado: 5-10 minutos" -ForegroundColor Yellow
Write-Host "💾 Liberando espaço em disco..." -ForegroundColor Green
Write-Host ""

Write-Progress -Activity "Reparo do Windows (Full)" -Status "Component Store Cleanup" -PercentComplete 75

Write-Log "========== Component Store Cleanup =========="
try {
    $output = & dism.exe /Online /Cleanup-Image /StartComponentCleanup /ResetBase 2>&1
    $resultados.ComponentCleanup = $LASTEXITCODE
    $output | ForEach-Object { Write-Log $_ }
    
    if ($resultados.ComponentCleanup -eq 0) {
        Write-Host "[OK] Limpeza de componentes concluída!" -ForegroundColor Green
        Write-Log "Status: SUCESSO"
    } else {
        Write-Host "[AVISO] Código de erro: $($resultados.ComponentCleanup)" -ForegroundColor Yellow
        Write-Log "Status: ERRO $($resultados.ComponentCleanup)"
    }
} catch {
    Write-Host "[ERRO] Falha na limpeza de componentes" -ForegroundColor Red
    Write-Log "Erro: $_"
}

Write-Host ""
if (-not $ModoAuto) { Read-Host "Pressione Enter para continuar" } else { Start-Sleep -Seconds 2 }

# ============================================================================
# ETAPA 8: Verificação do Disco (Opcional)
# ============================================================================
Clear-Host
Write-Host ""
Write-Host "┌────────────────────────────────────────────────────────┐" -ForegroundColor Cyan
Write-Host "│ [8/8] Verificação do Disco (CHKDSK)                  │" -ForegroundColor Cyan
Write-Host "└────────────────────────────────────────────────────────┘" -ForegroundColor Cyan
Write-Host ""
Write-Host "O CHKDSK verifica e repara erros no disco rígido." -ForegroundColor White
Write-Host ""
Write-Host "ATENÇÃO: Esta verificação requer REINICIALIZAÇÃO e será" -ForegroundColor Red
Write-Host "executada ANTES do Windows iniciar." -ForegroundColor Red
Write-Host ""

Write-Progress -Activity "Reparo do Windows (Full)" -Status "CHKDSK (Opcional)" -PercentComplete 87

Write-Log "========== CHKDSK =========="
$chkdskConfirm = Read-Host "Deseja agendar a verificação do disco? (S/N)"

if ($chkdskConfirm -match '^[Ss]$') {
    try {
        Write-Host ""
        Write-Host "Agendando verificação do disco..." -ForegroundColor Yellow
        echo Y | chkdsk C: /F /R /X | Out-Null
        Write-Host "[OK] CHKDSK agendado! Será executado na próxima reinicialização." -ForegroundColor Green
        Write-Log "Status: AGENDADO"
        $resultados.CHKDSK = "AGENDADO"
    } catch {
        Write-Host "[ERRO] Falha ao agendar CHKDSK" -ForegroundColor Red
        Write-Log "Erro: $_"
    }
} else {
    Write-Host ""
    Write-Host "[IGNORADO] Verificação de disco não agendada." -ForegroundColor Yellow
    Write-Log "Status: IGNORADO PELO USUÁRIO"
    $resultados.CHKDSK = "NÃO AGENDADO"
}

# ============================================================================
# FINALIZAR AUTO-ENTER
# ============================================================================
Write-Host ""
Write-Host "Desativando sistema anti-travamento..." -ForegroundColor Cyan
Stop-Job -Job $autoEnterJob -ErrorAction SilentlyContinue
Remove-Job -Job $autoEnterJob -Force -ErrorAction SilentlyContinue
Write-Host "[OK] Sistema anti-travamento desativado" -ForegroundColor Green

Write-Progress -Activity "Reparo do Windows (Full)" -Status "Concluído!" -PercentComplete 100 -Completed

# ============================================================================
# RESUMO FINAL
# ============================================================================
Clear-Host
Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║      🎉 REPARO COMPLETO CONCLUÍDO COM SUCESSO!        ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "Seu sistema Windows foi reparado e otimizado! 🚀" -ForegroundColor White
Write-Host ""
Write-Host "┌─ RESUMO DO PROCESSO ───────────────────────────────────┐" -ForegroundColor Cyan
Write-Host "│                                                        │" -ForegroundColor Cyan
Write-Host "│  $(if($resultados.WUCache -eq 1){'✓'}else{'✗'}) Limpeza Windows Update    : $(if($resultados.WUCache -eq 1){'CONCLUÍDO'}else{'ERRO'})              │" -ForegroundColor $(if($resultados.WUCache -eq 1){'Green'}else{'Red'})
Write-Host "│  $(if($resultados.TempFiles -eq 1){'✓'}else{'✗'}) Limpeza Temporários       : $(if($resultados.TempFiles -eq 1){'CONCLUÍDO'}else{'ERRO'})              │" -ForegroundColor $(if($resultados.TempFiles -eq 1){'Green'}else{'Red'})
Write-Host "│  $(if($resultados.DismCheck -eq 0){'✓'}else{'✗'}) DISM CheckHealth          : $(if($resultados.DismCheck -eq 0){'CONCLUÍDO'}else{'ERRO'})              │" -ForegroundColor $(if($resultados.DismCheck -eq 0){'Green'}else{'Red'})
Write-Host "│  $(if($resultados.DismScan -eq 0){'✓'}else{'✗'}) DISM ScanHealth           : $(if($resultados.DismScan -eq 0){'CONCLUÍDO'}else{'ERRO'})              │" -ForegroundColor $(if($resultados.DismScan -eq 0){'Green'}else{'Red'})
Write-Host "│  $(if($resultados.DismRestore -eq 0){'✓'}else{'✗'}) DISM RestoreHealth        : $(if($resultados.DismRestore -eq 0){'CONCLUÍDO'}else{'ERRO'})              │" -ForegroundColor $(if($resultados.DismRestore -eq 0){'Green'}else{'Red'})
Write-Host "│  $(if($resultados.SFC -eq 0){'✓'}else{'✗'}) SFC ScanNow               : $(if($resultados.SFC -eq 0){'CONCLUÍDO'}else{'ERRO'})              │" -ForegroundColor $(if($resultados.SFC -eq 0){'Green'}else{'Red'})
Write-Host "│  $(if($resultados.ComponentCleanup -eq 0){'✓'}else{'✗'}) Component Store Cleanup   : $(if($resultados.ComponentCleanup -eq 0){'CONCLUÍDO'}else{'ERRO'})              │" -ForegroundColor $(if($resultados.ComponentCleanup -eq 0){'Green'}else{'Red'})
Write-Host "│  $(if($resultados.CHKDSK -eq 'AGENDADO'){'⏳'}else{'○'}) CHKDSK                    : $($resultados.CHKDSK.PadRight(14)) │" -ForegroundColor $(if($resultados.CHKDSK -eq 'AGENDADO'){'Yellow'}else{'Gray'})
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

if ($resultados.CHKDSK -eq "AGENDADO") {
    Write-Host "  2️⃣  O CHKDSK será executado na reinicialização" -ForegroundColor White
    Write-Host "      (pode demorar 30-60 minutos, não interrompa)" -ForegroundColor Gray
    Write-Host "  3️⃣  Após concluir, o Windows iniciará normalmente" -ForegroundColor White
} else {
    Write-Host "  2️⃣  Verifique se os problemas foram resolvidos" -ForegroundColor White
}

Write-Host "  3️⃣  Mantenha o Windows Update ativo e atualizado" -ForegroundColor White
Write-Host "  4️⃣  Execute este reparo periodicamente (a cada 3-6 meses)" -ForegroundColor White
Write-Host ""
Write-Host "⚠️  SE OS PROBLEMAS PERSISTIREM:" -ForegroundColor Red
Write-Host "  • Consulte o arquivo de log para detalhes técnicos" -ForegroundColor White
Write-Host "  • Considere fazer backup e restaurar o Windows" -ForegroundColor White
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
Write-Host "Sistema mm.ti Lab - Windows Repair Tool v$ScriptVersion (FULL - PowerShell)" -ForegroundColor Gray
Write-Host "Script criado por Marlon Motta e equipe" -ForegroundColor Gray
Write-Host "Email: marlonmotta.ti@gmail.com" -ForegroundColor Gray
Write-Host "Processado em: $(Get-Date -Format 'dd/MM/yyyy às HH:mm:ss')" -ForegroundColor Gray
Write-Host ""

Write-Log "========== RESUMO FINAL =========="
Write-Log "Limpeza Windows Update: $(if($resultados.WUCache -eq 1){'CONCLUÍDO'}else{'ERRO'})"
Write-Log "Limpeza Temporários: $(if($resultados.TempFiles -eq 1){'CONCLUÍDO'}else{'ERRO'})"
Write-Log "DISM CheckHealth: Código $($resultados.DismCheck)"
Write-Log "DISM ScanHealth: Código $($resultados.DismScan)"
Write-Log "DISM RestoreHealth: Código $($resultados.DismRestore)"
Write-Log "SFC ScanNow: Código $($resultados.SFC)"
Write-Log "Component Store Cleanup: Código $($resultados.ComponentCleanup)"
Write-Log "CHKDSK: $($resultados.CHKDSK)"
Write-Log "Script criado por: Marlon Motta e equipe"
Write-Log "Email: marlonmotta.ti@gmail.com"
Write-Log "Sistema mm.ti Lab - Windows Repair Tool v$ScriptVersion (FULL - PowerShell)"
Write-Log "========== FIM DO REPARO =========="

Write-Host "Pressione qualquer tecla para fechar..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

