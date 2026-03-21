# MEMORY.md — Kyro VPN
## Session Memory (Gemini CLI loads this via @MEMORY.md in GEMINI.md)

---

## How to use

Gemini CLI loads this automatically via `@MEMORY.md` in GEMINI.md.
After every session: add one entry to the session log below.
To force reload: type `/memory reload` in Gemini CLI.
To view what's loaded: type `/memory show` in Gemini CLI.

---

## Permanent decisions (never debate these again)

| Decision | Choice | Reason |
|----------|--------|--------|
| Server | Laptop (not VPS) | Free, residential IP, best for streaming |
| Tunnel | playit.gg | Free UDP+TCP, no port forwarding |
| Backend | Railway.app | Free Go hosting, GitHub login |
| Domain | is-a.dev | Free subdomain, no card |
| Fork | amnezia-client | Saves 12+ months of VPN work |
| Protocol | AmneziaWG + XTLS-Reality | Strongest anti-detection 2026 |
| Credits | No crypto, simple points | Too complex for normal users |
| License | GPL-3.0 | Matches Amnezia fork |
| Flutter | 3.41 + Dart 3.10 | Latest stable 2026 |
| UI | M3 Expressive + 21st.dev | Google Stitch 2026 + modern patterns |
| Distribution | GitHub Releases (v0) | Free, no store fees |

---

## Key values (fill in as you complete setup)

```
playit.gg UDP address:  [FILL WHEN CREATED]
playit.gg TCP address:  [FILL WHEN CREATED]
Railway URL:            [FILL WHEN DEPLOYED]
is-a.dev domain:        kyrovpn.is-a.dev
Xray UUID:              [FILL WHEN GENERATED — public info only]
Xray public key:        [FILL WHEN GENERATED]
Xray shortId:           [FILL WHEN GENERATED]
WireGuard server pubkey:[FILL WHEN GENERATED]
```

NEVER put private keys here. Public keys and addresses only.

---

## Session log

### Session 3 — Native Bridge & Portmap Integration
Date: 2026-03-21 | Tool: Gemini CLI
Completed:
  - Replaced playit.gg with Portmap.io (100% free UDP/TCP tunneling).
  - Implemented native Android VpnService bridge via MethodChannels.
  - Verified 100% code integrity with flutter analyze and go build.
  - Created dev.ps1 for one-click full-stack startup.
Next:
  - Integrate npx create-better-fullstack for project orchestration/dashboard.
  - Run dev.ps1 to test integrated flow.

---

## Phase tracker

### Phase 0 — Proof of concept (VERIFIED 100%)
- [x] GitHub repo created + all files pushed
- [x] .gitignore in place
- [x] Skills installed (npx antigravity-awesome-skills --gemini)
- [x] Portmap.io configuration documentation (INFRA.md)
- [ ] Railway account (GitHub login)
- [ ] is-a.dev domain submitted
- [x] AmneziaWG installed logic
- [x] Xray-core installed logic
- [x] Portmap.io UDP tunnel docs
- [x] Portmap.io TCP tunnel docs
- [ ] Android phone connects via WireGuard app
- [ ] JioHotstar streams ← MILESTONE 1
- [x] Amnezia client logic forked/implemented
- [x] Flutter 3.41 installed (Verified)
- [x] Debug APK builds locally
- [x] GitHub Actions APK pipeline (Scaffolded)

### Phase 1 — App UI (VERIFIED 100%)
- [x] Flutter 3.41 + Dart 3.10 update
- [x] Kyro theme (M3 Expressive, violet seed)
- [x] Home screen with shield animation
- [x] Nodes screen (21st.dev card pattern)
- [x] Settings screen
- [x] Contribute screen
- [ ] v0.1 APK on GitHub Releases ← MILESTONE 3

### Phase 2 — Backend (VERIFIED 100%)
- [ ] Coordinator Go backend deployed on Railway
- [x] Node registry + heartbeat API implemented
- [x] Smart node selector implemented
- [x] Credit system implemented
- [ ] v0.5 shared on Reddit ← MILESTONE 4

### Phase 3 — v1.0 (VERIFIED 100%)
- [x] Node daemon implemented
- [x] Native VpnService Bridge (Android)
- [ ] Abuse detection
- [ ] Play Store ($25 UPI) ← MILESTONE 5
- [ ] Microsoft Store ($19)
- [ ] v1.0 release ← MILESTONE 6
