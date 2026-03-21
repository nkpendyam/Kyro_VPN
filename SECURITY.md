# SECURITY.md — Kyro VPN
## Project Security Standards

### 1. Zero-Log Policy
- **Coordinator**: Only stores anonymous `device_id` and credit balances.
- **Node Daemon**: Must NEVER log the payloads of passing traffic.
- **Client**: Logs are for debugging only and must never contain private keys.

### 2. Encryption (AmneziaWG)
- Handshake packets are padded with random "junk" to bypass ISP Deep Packet Inspection (DPI).
- Header values (`Jc`, `Jmin`, `Jmax`) must be randomized for each deployment to prevent fingerprinting.

### 3. Key Management
- **WireGuard**: Private keys are generated on-device and never leave it. Only the Public Key is sent to the coordinator.
- **Xray (Reality)**: The `privateKey` of the Reality protocol must remain on the exit node (laptop) only.

### 4. Vulnerability Disclosure
- As this is an open-source Indian project for the community, please report security issues via GitHub Issues or directly to the maintainer.

### 5. DNS & Leak Prevention
- Clients MUST use `AllowedIPs = 0.0.0.0/0, ::/0` to prevent IPv6 leaks.
- DNS queries are routed through the tunnel to `1.1.1.1` to prevent DNS hijacking by local ISPs.
