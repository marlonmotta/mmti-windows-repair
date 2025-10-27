' ============================================================================
' Auto-Enter Helper - Sistema mm.ti Lab
' Script criado por Marlon Motta e equipe
' ============================================================================
' 
' Este script envia a tecla ENTER automaticamente para a janela do CMD
' a cada 2 minutos (120 segundos) para evitar que o DISM trave.
'
' Funciona em BACKGROUND - usuário pode usar o PC normalmente!
' ============================================================================

Option Explicit

Dim WshShell, windowTitle, timeoutSeconds, startTime
Set WshShell = CreateObject("WScript.Shell")

' Configurações
timeoutSeconds = 120  ' 2 minutos entre cada Enter
windowTitle = "Reparo do Windows"  ' Parte do título da janela CMD

' Registra início no log (se existir)
startTime = Now()

' Loop principal - roda até o script ser fechado
Do While True
    ' Aguarda 2 minutos
    WScript.Sleep timeoutSeconds * 1000
    
    ' Tenta encontrar a janela pelo título
    On Error Resume Next
    
    ' Ativa a janela se ela existir
    If WshShell.AppActivate(windowTitle) Then
        ' Aguarda 100ms para garantir que a janela está ativa
        WScript.Sleep 100
        
        ' Envia a tecla ENTER
        WshShell.SendKeys "{ENTER}"
        
        ' Aguarda mais 100ms
        WScript.Sleep 100
    End If
    
    On Error Goto 0
Loop

' Limpeza (nunca será executado, mas boa prática)
Set WshShell = Nothing


