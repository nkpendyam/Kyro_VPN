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

### Session 1 — Project setup
Date: 2026-03-20 | Tool: Claude.ai / Gemini CLI
Completed:
  - All project files generated for Gemini CLI
  - Laptop-as-server architecture finalised
  - playit.gg chosen for tunneling (no port forwarding)
  - Gemini CLI skills structure set up
  - 21st.dev + Google Stitch M3 UI decided
Next:
  - Create GitHub repo, push all files
  - Sign up playit.gg and Railway
  - Install AmneziaWG on laptop
  - Run INFRA.md steps 1-6

---

## Phase tracker

### Phase 0 — Proof of concept (CURRENT)
- [ ] GitHub repo created + all files pushed
- [ ] .gitignore in place
- [ ] Skills installed (npx antigravity-awesome-skills --gemini)
- [ ] playit.gg account created
- [ ] Railway account (GitHub login)
- [ ] is-a.dev domain submitted
- [ ] AmneziaWG installed on laptop
- [ ] Xray-core installed on laptop
- [ ] playit.gg UDP tunnel (WireGuard port 51820)
- [ ] playit.gg TCP tunnel (Xray port 443)
- [ ] Android phone connects via WireGuard app
- [ ] JioHotstar streams ← MILESTONE 1
- [ ] Amnezia client forked into client/
- [ ] Flutter 3.41 installed
- [ ] Debug APK builds locally
- [ ] GitHub Actions APK pipeline ← MILESTONE 2

### Phase 1 — App UI (Month 2)
- [ ] Flutter 3.41 + Dart 3.10 update
- [ ] Kyro theme (M3 Expressive, violet seed)
- [ ] Home screen with shield animation
- [ ] Nodes screen (21st.dev card pattern)
- [ ] Settings screen
- [ ] Contribute screen
- [ ] v0.1 APK on GitHub Releases ← MILESTONE 3

### Phase 2 — Backend (Month 3)
- [ ] Coordinator Go backend deployed on Railway
- [ ] Node registry + heartbeat API
- [ ] Smart node selector
- [ ] Credit system
- [ ] v0.5 shared on Reddit ← MILESTONE 4

### Phase 3 — v1.0 (Month 4-6)
- [ ] Node daemon (community nodes)
- [ ] Abuse detection
- [ ] Play Store ($25 UPI) ← MILESTONE 5
- [ ] Microsoft Store ($19)
- [ ] v1.0 release ← MILESTONE 6
