# Enable TLS (important for downloads in Azure VM)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Desktop path (for all users)
$desktop = "C:\Users\Public\Desktop"

# Create WebClient (more stable)
$wc = New-Object System.Net.WebClient

# ---------------------------
# Install Chrome
# ---------------------------
$chromeInstaller = "$env:TEMP\chrome.exe"
$wc.DownloadFile("https://dl.google.com/chrome/install/latest/chrome/install.exe", $chromeInstaller)
Start-Process $chromeInstaller -ArgumentList "/silent /install" -Wait

# Create Chrome shortcut
$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
if (Test-Path $chromePath) {
    $ws = New-Object -ComObject WScript.Shell
    $sc = $ws.CreateShortcut("$desktop\Google Chrome.lnk")
    $sc.TargetPath = $chromePath
    $sc.Save()
}

# ---------------------------
# Install Edge
# ---------------------------
$edgeInstaller = "$env:TEMP\edge.msi"
$wc.DownloadFile("https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/latest/MicrosoftEdgeEnterpriseX64.msi", $edgeInstaller)
Start-Process "msiexec.exe" -ArgumentList "/i $edgeInstaller /quiet /norestart" -Wait

# Create Edge shortcut
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

# Create VS Code shortcut
$vscodePath = "$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe"
if (Test-Path $vscodePath) {
    $sc = $ws.CreateShortcut("$desktop\VS Code.lnk")
    $sc.TargetPath = $vscodePath
    $sc.Save()
}

# ---------------------------
# Chrome auto-launch on login
# ---------------------------
if (Test-Path $chromePath) {
    $action = New-ScheduledTaskAction -Execute $chromePath
    $trigger = New-ScheduledTaskTrigger -AtLogOn
    Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "OpenChromeAtLogin" -User "SYSTEM" -Force
}