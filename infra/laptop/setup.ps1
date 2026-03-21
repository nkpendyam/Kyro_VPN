# setup.ps1 - Kyro VPN Windows Node Setup

$KYRO_DIR = "C:\kyro-vpn"
$XRAY_URL = "https://github.com/XTLS/Xray-core/releases/latest/download/Xray-windows-64.zip"
$AWG_URL = "https://download.amnezia.org/amneziawg/windows/AmneziaWG-x64-1.0.0.msi"

Write-Host "--- Kyro VPN Node Setup ---" -ForegroundColor Cyan

# 1. Create Directories
If (!(Test-Path $KYRO_DIR)) {
    New-Item -ItemType Directory -Path $KYRO_DIR
    New-Item -ItemType Directory -Path "$KYRO_DIR\bin"
}

# 2. Download Xray-core
Write-Host "[1/4] Downloading Xray-core..."
Invoke-WebRequest -Uri $XRAY_URL -OutFile "$KYRO_DIR\xray.zip"
Expand-Archive -Path "$KYRO_DIR\xray.zip" -DestinationPath "$KYRO_DIR\bin\xray" -Force
Remove-Item "$KYRO_DIR\xray.zip"

# 3. Download AmneziaWG
Write-Host "[2/4] Downloading AmneziaWG Installer..."
Invoke-WebRequest -Uri $AWG_URL -OutFile "$KYRO_DIR\amneziawg_installer.msi"
Write-Host "Please install AmneziaWG manually from: $KYRO_DIR\amneziawg_installer.msi" -ForegroundColor Yellow

# 4. Build Node Daemon
Write-Host "[3/4] Building Kyro Node Daemon..."
Set-Location "$PSScriptRoot\..\..\node-daemon"
go build -o "$KYRO_DIR\bin\kyro-node.exe" .

# 5. Instructions
Write-Host "--- Setup Complete! ---" -ForegroundColor Green
Write-Host "1. Open AmneziaWG and generate a server config on port 51820."
Write-Host "2. Run playit.gg to tunnel UDP 51820 and TCP 443."
Write-Host "3. Start the daemon with:"
Write-Host "   $KYRO_DIR\bin\kyro-node.exe --playit abc.at.ply.gg:12345 --city Bangalore --country IN" -ForegroundColor White
