---
name: kyro-security
description: >
  Security audit and review for Kyro VPN code. Activate when writing
  or reviewing any code involving WireGuard keys, Xray configuration,
  coordinator API handlers, network configuration, Android permissions,
  or anything security-sensitive. Also activate before any commit or release.
---

# Kyro VPN Security Skill

## Core security rules (never break)

### WireGuard keys
- Private keys: generated in memory only, NEVER stored in DB, file, or log
- Config files: written to /tmp/, tunnel started, file deleted immediately
- Never log any key material — not even first/last characters

### AmneziaWG vs WireGuard
- Always use AmneziaWG (amneziawg-go) — never vanilla WireGuard
- Vanilla WireGuard has a unique handshake signature ISPs detect in <1s
- AmneziaWG junk packets destroy the signature

### XTLS-Reality
- Destination domain MUST be a real live high-traffic HTTPS site
- Use: apple.com (recommended), microsoft.com, cloudflare.com
- NEVER use your own domain — too low traffic, suspicious
- Private key: never in any committed file, always in .env

### Secrets management
- All secrets in .env files
- .env must be in .gitignore — verify before every commit
- flutter_secure_storage for client-side secrets (uses Android Keystore)
- No hardcoded UUIDs, keys, or addresses in any source file

### Network security (Flutter)
```xml
<!-- network_security_config.xml — no cleartext except localhost -->
<base-config cleartextTrafficPermitted="false"/>
```

### Android permissions audit
VPN apps need these — no more:
- INTERNET ✓
- FOREGROUND_SERVICE ✓
- BIND_VPN_SERVICE ✓
- RECEIVE_BOOT_COMPLETED ✓ (auto-connect on boot)
- No: READ_CONTACTS, ACCESS_FINE_LOCATION, CAMERA

### Go backend security
- Rate limit ALL endpoints (gin-contrib/limiter)
- Validate ALL inputs before processing
- Parameterised SQL — never string concatenation
- No user PII stored — anonymous device IDs only
- HTTPS only in production (Cloudflare handles this)

## Pre-commit checklist
- [ ] No private keys in any .go or .dart file
- [ ] No .env files tracked by git
- [ ] No hardcoded server addresses in client code
- [ ] .gitignore covers: .env, *.key, *.jks, key.properties, wg0.conf
- [ ] flutter analyze clean
- [ ] go vet clean
- [ ] No fmt.Println in production Go code (use zerolog)
- [ ] All error paths handled (no silent failures)

## DNS + IPv6 leak prevention
WireGuard client config must always include:
```ini
DNS = 1.1.1.1, 1.0.0.1
AllowedIPs = 0.0.0.0/0, ::/0
```
Missing ::/0 → IPv6 traffic bypasses tunnel → real IP leaks to sites.

## ProGuard (Android release builds)
```
-keep class com.wireguard.** { *; }
-keep class org.amnezia.** { *; }
-keep class io.flutter.** { *; }
```
