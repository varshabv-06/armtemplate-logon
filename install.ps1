# Create a flag file to track execution stage
$flagFile = "C:\setup_stage.txt"

# ---------------------------
# STAGE 1: Install Software
# ---------------------------
if (!(Test-Path $flagFile)) {

    Write-Output "Stage 1: Installing software..."

    # Install Chrome
    Invoke-WebRequest "https://dl.google.com/chrome/install/latest/chrome/install.exe" -OutFile "C:\chrome.exe"
    Start-Process "C:\chrome.exe" -Args "/silent /install" -Wait

    # Install Edge
    Invoke-WebRequest "https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/latest/MicrosoftEdgeEnterpriseX64.msi" -OutFile "C:\edge.msi"
    Start-Process "msiexec.exe" -ArgumentList "/i C:\edge.msi /quiet /norestart" -Wait

    # Install VS Code
    Invoke-WebRequest "https://update.code.visualstudio.com/latest/win32-x64-user/stable" -OutFile "C:\vscode.exe"
    Start-Process "C:\vscode.exe" -ArgumentList "/silent" -Wait

    # Mark stage complete
    New-Item -Path $flagFile -ItemType File -Force

    # Create scheduled task to resume script after reboot
    $action = New-ScheduledTaskAction -Execute "powershell.exe" `
        -Argument "-ExecutionPolicy Bypass -File C:\install.ps1"

    $trigger = New-ScheduledTaskTrigger -AtStartup

    Register-ScheduledTask -Action $action -Trigger $trigger `
        -TaskName "ResumeAfterReboot" -User "SYSTEM" -RunLevel Highest -Force

    Write-Output "Restarting system..."
    Restart-Computer -Force
}

# ---------------------------
# STAGE 2: After Restart
# ---------------------------
else {

    Write-Output "Stage 2: Post-restart configuration..."

    # Create Chrome auto-launch task
    $action = New-ScheduledTaskAction `
        -Execute "C:\Program Files\Google\Chrome\Application\chrome.exe"

    $trigger = New-ScheduledTaskTrigger -AtLogOn

    Register-ScheduledTask -Action $action -Trigger $trigger `
        -TaskName "OpenChromeAtLogin" -User "SYSTEM" -RunLevel Highest -Force

    # Cleanup resume task + flag
    Unregister-ScheduledTask -TaskName "ResumeAfterReboot" -Confirm:$false
    Remove-Item $flagFile -Force

    Write-Output "Setup completed successfully!"
}