# MUST RUN AS ADMIN

# Enable TLS
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$desktop = "C:\Users\Public\Desktop"
$wc = New-Object System.Net.WebClient
$ws = New-Object -ComObject WScript.Shell

# ---------------------------
# Install Chrome (WORKING)
# ---------------------------
$chromeInstaller = "$env:TEMP\chrome.msi"
$wc.DownloadFile("https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi", $chromeInstaller)
Start-Process "msiexec.exe" -ArgumentList "/i $chromeInstaller /quiet /norestart" -Wait

# Chrome shortcut
$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
if (Test-Path $chromePath) {
    $sc = $ws.CreateShortcut("$desktop\Google Chrome.lnk")
    $sc.TargetPath = $chromePath
    $sc.Save()
}

# ---------------------------
# Install Edge (FIXED URL)
# ---------------------------
$edgeInstaller = "$env:TEMP\edge.msi"
$wc.DownloadFile("https://go.microsoft.com/fwlink/?linkid=2109047", $edgeInstaller)
Start-Process "msiexec.exe" -ArgumentList "/i $edgeInstaller /quiet /norestart" -Wait

# Edge shortcut
$edgePath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
if (Test-Path $edgePath) {
    $sc = $ws.CreateShortcut("$desktop\Microsoft Edge.lnk")
    $sc.TargetPath = $edgePath
    $sc.Save()
}

# ---------------------------
# Install VS Code
# ---------------------------
$vscodeInstaller = "$env:TEMP\vscode.exe"
$wc.DownloadFile("https://update.code.visualstudio.com/latest/win32-x64-user/stable", $vscodeInstaller)
Start-Process $vscodeInstaller -ArgumentList "/silent /mergetasks=!runcode" -Wait

# VS Code shortcut
$vscodePath = "$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe"
if (Test-Path $vscodePath) {
    $sc = $ws.CreateShortcut("$desktop\VS Code.lnk")
    $sc.TargetPath = $vscodePath
    $sc.Save()
}

$taskName = "ChromeLogonPopup"

# Chrome path
$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"

# URL to open
$url = "https://portal.azure.com"

# Action (open Chrome in app mode = popup)
$action = New-ScheduledTaskAction -Execute $chromePath -Argument "--app=$url"

# Trigger (At logon)
$trigger = New-ScheduledTaskTrigger -AtLogOn

# Principal (current user)
$principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\INTERACTIVE" -LogonType Interactive

# Settings
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries

# Register task
Register-ScheduledTask -TaskName $taskName `
    -Action $action `
    -Trigger $trigger `
    -Principal $principal `
    -Settings $settings `
    -Force