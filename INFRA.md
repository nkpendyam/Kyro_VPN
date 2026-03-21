# INFRA.md — Kyro VPN
## Laptop as Server Setup (₹0 — Windows)

---

## 1. Install playit.gg (Tunnelling)
- Download `playit-windows-x86_64.exe` from [playit.gg/download](https://playit.gg/download).
- Run it as Administrator.
- Open the playit.gg dashboard in your browser.
- **Create Tunnels:**
  - **UDP Tunnel:** Local port `51820` (WireGuard)
  - **TCP Tunnel:** Local port `443` (Xray)
- Note the `public_address` (e.g., `abc.at.ply.gg:12345`) for each.

## 2. Install AmneziaWG (Obfuscated WireGuard)
- Download the Windows Amnezia client from [amnezia.org](https://amnezia.org).
- Open PowerShell as Administrator.
- **Generate Keys:**
```powershell
# Create server keys
$wg_private = (awg genkey)
$wg_public = ($wg_private | awg pubkey)
Write-Host "Server Private Key: $wg_private"
Write-Host "Server Public Key: $wg_public" # SAVE TO MEMORY.md
```
- **Configure Interface:**
  - Create `C:\Program Files\AmneziaWG\config.conf` with:
```ini
[Interface]
PrivateKey = [YOUR_WG_PRIVATE_KEY]
Address = 10.0.0.1/24
ListenPort = 51820
MTU = 1280
Jc = 4
Jmin = 40
Jmax = 70
S1 = 5
S2 = 10
H1 = 1
H2 = 2
H3 = 3
H4 = 4

[Peer]
# Add client configs here later
```

## 3. Install Xray-core (XTLS-Reality)
- Download `Xray-windows-64.zip` from [XTLS/Xray-core/releases](https://github.com/XTLS/Xray-core/releases).
- Extract to `C:\kyro-vpn\xray`.
- **Generate Keys:**
```powershell
cd C:\kyro-vpn\xray
.\xray.exe x25519
# Note Private, Public key and shortId. SAVE Public/shortId TO MEMORY.md
.\xray.exe uuid
# Note UUID. SAVE TO MEMORY.md
```
- **Create config.json:**
```json
{
  "inbounds": [{
    "port": 443,
    "protocol": "vless",
    "settings": {
      "clients": [{"id": "[YOUR_XRAY_UUID]", "flow": "xtls-rprx-vision"}],
      "decryption": "none"
    },
    "streamSettings": {
      "network": "tcp",
      "security": "reality",
      "realitySettings": {
        "show": false,
        "dest": "apple.com:443",
        "xver": 0,
        "serverNames": ["apple.com", "www.apple.com"],
        "privateKey": "[YOUR_XRAY_PRIVATE_KEY]",
        "shortIds": ["[YOUR_XRAY_SHORT_ID]"]
      }
    }
  }],
  "outbounds": [{"protocol": "freedom"}]
}
```

## 4. Run Services
- Start `playit.gg`.
- Start `AmneziaWG`.
- Run Xray: `.\xray.exe run`.

---

## 5. Fill MEMORY.md
Update these in your root `MEMORY.md` immediately:
- `playit.gg UDP address`
- `playit.gg TCP address`
- `Xray UUID`
- `Xray public key`
- `Xray shortId`
- `WireGuard server pubkey`
