# Install Google Chrome
$chromeInstaller = "$env:TEMP\chrome.exe"
Invoke-WebRequest "https://dl.google.com/chrome/install/latest/chrome/install.exe" -OutFile $chromeInstaller
Start-Process $chromeInstaller -Args "/silent /install" -Wait

# Install Microsoft Edge
$edgeInstaller = "$env:TEMP\edge.msi"
Invoke-WebRequest "https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/latest/MicrosoftEdgeEnterpriseX64.msi" -OutFile $edgeInstaller
Start-Process "msiexec.exe" -ArgumentList "/i $edgeInstaller /quiet /norestart" -Wait

# Install VS Code
$vscodeInstaller = "$env:TEMP\vscode.exe"
Invoke-WebRequest "https://update.code.visualstudio.com/latest/win32-x64-user/stable" -OutFile $vscodeInstaller
Start-Process $vscodeInstaller -ArgumentList "/silent /mergetasks=!runcode" -Wait

# Create Logon Task to open Chrome
$action = New-ScheduledTaskAction -Execute "C:\Program Files\Google\Chrome\Application\chrome.exe"
$trigger = New-ScheduledTaskTrigger -AtLogOn
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "OpenChromeAtLogin" -Description "Launch Chrome on login" -User "SYSTEM"