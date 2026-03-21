# dev.ps1 - Kyro VPN Unified Stack Runner
# Use this to start the entire project with one command.

Write-Host "🚀 Starting Kyro VPN Full Stack + Dashboard..." -ForegroundColor Cyan

# 1. Kill any existing Kyro processes
Write-Host "🧹 Cleaning up old processes..."
Stop-Process -Name "main", "kyro-node", "flutter", "node" -ErrorAction SilentlyContinue

# 2. Start Coordinator (Backend) in background
Write-Host "🧠 Starting Coordinator Backend (Port 8080)..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd coordinator; go run main.go" -WindowStyle Normal

# 3. Start Node Daemon (Server) in background
Write-Host "🛰️ Starting Node Daemon..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd node-daemon; go run . --endpoint 'localhost:51820' --city 'Dev-Machine' --country 'IN'" -WindowStyle Normal

# 4. Start Web Dashboard (Management) in background
Write-Host "📊 Starting Web Dashboard (Port 3000)..." -ForegroundColor Magenta
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd kyro-dashboard; npm run dev" -WindowStyle Normal

# 5. Start Flutter App (Frontend)
Write-Host "📱 Launching Flutter UI..." -ForegroundColor Blue
cd client
flutter run
