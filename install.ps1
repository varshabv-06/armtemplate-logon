# Get Public Desktop path
$desktop = "C:\Users\Public\Desktop"

# ---------------------------
# Install Chrome
# ---------------------------
$chromeInstaller = "$desktop\chrome.exe"
Invoke-WebRequest "https://dl.google.com/chrome/install/latest/chrome/install.exe" -OutFile $chromeInstaller
Start-Process $chromeInstaller -Args "/silent /install" -Wait

# Create Chrome shortcut
$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
$chromeShortcut = "$desktop\Google Chrome.lnk"
$ws = New-Object -ComObject WScript.Shell
$sc = $ws.CreateShortcut($chromeShortcut)
$sc.TargetPath = $chromePath
$sc.Save()

# ---------------------------
# Install Edge
# ---------------------------
$edgeInstaller = "$desktop\edge.msi"
Invoke-WebRequest "https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/latest/MicrosoftEdgeEnterpriseX64.msi" -OutFile $edgeInstaller
Start-Process "msiexec.exe" -ArgumentList "/i $edgeInstaller /quiet /norestart" -Wait

# Create Edge shortcut
$edgePath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$edgeShortcut = "$desktop\Microsoft Edge.lnk"
$sc = $ws.CreateShortcut($edgeShortcut)
$sc.TargetPath = $edgePath
$sc.Save()

# ---------------------------
# Install VS Code
# ---------------------------
$vscodeInstaller = "$desktop\vscode.exe"
Invoke-WebRequest "https://update.code.visualstudio.com/latest/win32-x64-user/stable" -OutFile $vscodeInstaller
Start-Process $vscodeInstaller -ArgumentList "/silent" -Wait

# Create VS Code shortcut
$vscodePath = "$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe"
$vscodeShortcut = "$desktop\VS Code.lnk"
$sc = $ws.CreateShortcut($vscodeShortcut)
$sc.TargetPath = $vscodePath
$sc.Save()

# ---------------------------
# Chrome on login
# ---------------------------
$action = New-ScheduledTaskAction -Execute $chromePath
$trigger = New-ScheduledTaskTrigger -AtLogOn
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "OpenChromeAtLogin" -User "SYSTEM" -Force