# INFRA.md — Kyro VPN
## Laptop as Server Setup (₹0 — Windows)

### 1. Choose a Tunnelling Provider (Free)
Since playit.gg now requires premium for certain configurations, we recommend **Portmap.io** (1 rule free) or **Localtonet** (1GB free).

#### Option A: Portmap.io (Recommended for Stability)
1.  **Sign up**: Go to [Portmap.io](https://portmap.io) and create an account.
2.  **Configurations**: 
    - Go to "Configurations" -> "Create new configuration".
    - Type: **OpenVPN**.
    - Download the `.ovpn` file.
3.  **Mapping Rules**:
    - Go to "Mapping Rules" -> "Create new rule".
    - Protocol: **UDP** (for AmneziaWG) or **TCP** (for Xray).
    - Port on your PC: `51820` (UDP) or `443` (TCP).
    - Note the "Public Address" (e.g., `yourname-12345.portmap.io:54321`).
4.  **Connect**: Install [OpenVPN GUI](https://openvpn.net/community-downloads/) and use the `.ovpn` file to start the tunnel.

---

### 2. Run Automated Setup
Open PowerShell as **Administrator** and run:
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; .\infra\laptop\setup.ps1
```
This will:
- Download Xray-core to `C:\kyro-vpn\bin\xray`.
- Download the AmneziaWG installer to `C:\kyro-vpn`.
- Build the `kyro-node.exe` daemon.

### 3. Manual Steps
1. **Install AmneziaWG**: Run the `.msi` in `C:\kyro-vpn`.
2. **Configure AmneziaWG**: Generate a server config on port `51820`.

### 4. Start the Kyro Node
Run the daemon with your Portmap (or other) public address:
```powershell
cd C:\kyro-vpn\bin
.\kyro-node.exe --endpoint [YOUR_PORTMAP_PUBLIC_ADDRESS] --city [YOUR_CITY] --country [YOUR_COUNTRY_CODE]
```

### 5. Update MEMORY.md
Once running, fill in the public addresses and keys in the `Key values` section of `MEMORY.md`.
