# Kyro VPN - Tunnel Alternative Implementation Plan

## Objective
To replace **playit.gg** with a free, high-performance tunneling alternative that supports UDP (AmneziaWG) and TCP (Xray) without premium fees. 

## Chosen Alternative: Portmap.io + OpenVPN Tunnel
**Why?**
- **Portmap.io** allows 1 free UDP or TCP rule permanently.
- It uses **OpenVPN** as the transport layer, which is extremely stable and works on Windows/Linux without specialized drivers.
- Unlike playit.gg, it has a clear free tier for single-port forwarding.

## Implementation Steps

### 1. Update Infrastructure Setup (`infra/laptop/setup.ps1`)
- Add instructions to download the **OpenVPN Connect** or **OpenVPN GUI**.
- Add instructions to generate a configuration on **Portmap.io**.
- Update the Node Daemon startup command to reflect the new Portmap endpoint.

### 2. Update Node Daemon (`node-daemon/main.go`)
- Update the `--playit` flag to `--endpoint` to be provider-agnostic.
- Ensure the daemon correctly registers the Portmap address (e.g., `yourname-12345.portmap.host:12345`) with the Coordinator.

### 3. Update Documentation
- **INFRA.md**: Complete rewrite of the "Tunnelling" section to guide users through Portmap.io setup.
- **MEMORY.md**: Update key values to reflect Portmap addresses.

### 4. Code Refactor
- Update `client/lib/models/vpn_node.dart` if any fields changed (none expected, but will verify).
- Ensure the Flutter UI reflects the "Node Address" correctly.

## Verification
- Manually verify a Portmap.io tunnel connection.
- Ensure the Node Daemon registers successfully using the new endpoint format.

## Alternative Consideration (Backup)
- **Localtonet**: If Portmap.io has latency issues, we will provide a secondary guide for Localtonet (1GB/month free).

## Action Items
1. Rewrite `INFRA.md` with the new Portmap.io steps.
2. Update `infra/laptop/setup.ps1` to remove playit references.
3. Update `node-daemon/main.go` flags.
4. Final Git push.