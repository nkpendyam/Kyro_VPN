# setup.ps1 - Kyro VPN Windows Node Setup

$KYRO_DIR = "C:\kyro-vpn"
$XRAY_URL = "https://github.com/XTLS/Xray-core/releases/latest/download/Xray-windows-64.zip"
$AWG_URL = "https://download.amnezia.org/amneziawg/windows/AmneziaWG-x64-1.0.0.msi"
$OVPN_URL = "https://swupdate.openvpn.org/community/releases/OpenVPN-2.6.9-I001-amd64.msi"

Write-Host "--- Kyro VPN Node Setup (Free Tunnelling Edition) ---" -ForegroundColor Cyan

# 1. Create Directories
If (!(Test-Path $KYRO_DIR)) {
    New-Item -ItemType Directory -Path $KYRO_DIR
    New-Item -ItemType Directory -Path "$KYRO_DIR\bin"
}

# 2. Download Xray-core
Write-Host "[1/5] Downloading Xray-core..."
Invoke-WebRequest -Uri $XRAY_URL -OutFile "$KYRO_DIR\xray.zip"
Expand-Archive -Path "$KYRO_DIR\xray.zip" -DestinationPath "$KYRO_DIR\bin\xray" -Force
Remove-Item "$KYRO_DIR\xray.zip"

# 3. Download AmneziaWG
Write-Host "[2/5] Downloading AmneziaWG Installer..."
Invoke-WebRequest -Uri $AWG_URL -OutFile "$KYRO_DIR\amneziawg_installer.msi"

# 4. Download OpenVPN (for Portmap.io)
Write-Host "[3/5] Downloading OpenVPN GUI..."
Invoke-WebRequest -Uri $OVPN_URL -OutFile "$KYRO_DIR\openvpn_installer.msi"

# 5. Build Node Daemon
Write-Host "[4/5] Building Kyro Node Daemon..."
Set-Location "$PSScriptRoot\..\..\node-daemon"
go build -o "$KYRO_DIR\bin\kyro-node.exe" .

# 6. Instructions
Write-Host "--- Setup Complete! ---" -ForegroundColor Green
Write-Host "Please install these manually from $KYRO_DIR`:" -ForegroundColor Yellow
Write-Host "1. amneziawg_installer.msi"
Write-Host "2. openvpn_installer.msi (to connect to Portmap.io)"
Write-Host "---"
Write-Host "3. Start the daemon with:"
Write-Host "   $KYRO_DIR\bin\kyro-node.exe --endpoint yourname.portmap.io:12345 --city Bangalore --country IN" -ForegroundColor White
