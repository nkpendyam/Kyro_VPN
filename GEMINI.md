# GEMINI.md — Kyro VPN
## Master Context — Gemini CLI loads this automatically every session

@MEMORY.md
@ARCHITECTURE.md

---

## Project identity
- **Name:** Kyro VPN
- **Package:** com.kyrovpn.app
- **License:** GPL-3.0
- **GitHub:** github.com/[yourusername]/kyro-vpn (public)
- **Developer:** Solo student, India, zero budget, zero credit card
- **Goal:** Open source VPN, laptop as server, release v1.0, mostly automated

---

## How to use Gemini CLI on this project

```bash
# Start Gemini CLI in project folder
gemini

# Check all loaded skills
/skills

# Check loaded context (GEMINI.md + MEMORY.md)
/memory show

# Reload context after updating MEMORY.md
/memory reload

# Use a specific skill
Use kyro-architecture skill to design the node selector
Use kyro-frontend skill to build the home screen
Use kyro-security skill to audit the WireGuard config
```

---

## Install skills (run once in project root)

```bash
# Install 1000+ skills from antigravity-awesome-skills
npx antigravity-awesome-skills --gemini

# Install official Google Gemini skills
npx skills add google-gemini/gemini-skills --global

# Verify skills installed
ls .gemini/skills/
```

Skills Gemini will auto-activate for this project:
- `kyro-context` — project context (in `.gemini/skills/kyro-context/`)
- `kyro-frontend` — Flutter M3 + 21st.dev patterns
- `kyro-backend` — Go coordinator + node daemon
- `kyro-security` — VPN security audit
- `@architecture` — system design
- `@frontend-design` — UI/UX patterns
- `@security-auditor` — security review
- `@api-design-principles` — API design
- `@test-driven-development` — TDD
- `@debugging-strategies` — debugging
- `@docker-expert` — containerisation
- `@create-pr` — GitHub PR packaging

---

## Infrastructure — laptop as server (₹0 forever)

```
YOUR LAPTOP
├── AmneziaWG (obfuscated WireGuard) — port 51820
├── Xray-core XTLS-Reality — port 443
└── Node daemon — health reporter

playit.gg (free tunnel, no port forwarding, no card)
├── UDP tunnel → laptop:51820 (WireGuard)
└── TCP tunnel → laptop:443 (Xray)
→ Public address: abc.at.ply.gg:PORT

Railway.app (free Go backend, GitHub login)
└── Coordinator API → kyrovpn.is-a.dev

Cloudflare (free DNS + tunnel)
GitHub Actions (free for public repos — CI/CD + APK builds)
GitHub Releases (free app distribution)

TOTAL COST: ₹0
```

---

## 2026 Tech stack

### Flutter client
- Flutter 3.41, Dart 3.10 (latest stable 2026)
- Impeller renderer (default — never disable)
- Material Design 3 Expressive (Google Stitch 2026)
- 21st.dev component patterns (modern minimal UI)
- Riverpod 2.6+ with @riverpod codegen
- Go Router 14+, Dio 5.x
- Android API 35 (16KB pages), NDK r28
- flutter_secure_storage, flutter_launcher_icons

### Backend
- Go 1.24, Gin 1.9+, zerolog, sqlx + SQLite
- AmneziaWG (obfuscated WireGuard)
- Xray-core latest (XTLS-Reality + VLESS)

---

## Repos we fork — NEVER rewrite

| Repo | Use | License |
|------|-----|---------|
| amnezia-vpn/amnezia-client | Flutter app base | GPL-3.0 |
| XTLS/Xray-core | Obfuscation engine | MPL-2.0 |
| amnezia-vpn/amneziawg-go | Modified WireGuard | MIT |
| mysteriumnetwork/node | P2P discovery | GPL-3.0 |

---

## We build from scratch (only these 4)

1. Node credit + contribution system (no crypto)
2. Smart node selector algorithm
3. New M3 Expressive + 21st.dev UI
4. Abuse monitoring + health dashboard

---

## Coding rules — Flutter (Dart 3.10)

```dart
// Dot shorthands
padding: .all(16)         // not: EdgeInsets.all(16)
alignment: .center        // not: Alignment.center

// Sealed classes for VPN state
sealed class VpnState {}
final class Disconnected extends VpnState {}
final class Connecting extends VpnState {}
final class Connected extends VpnState {
  final VpnNode node;
  final DateTime since;
}
final class VpnError extends VpnState { final String message; }

// Riverpod codegen — always
@riverpod
class ConnectionNotifier extends _$ConnectionNotifier {
  @override VpnState build() => const Disconnected();
}

// M3 components only
// FilledButton, NavigationBar, Card, SearchBar, SegmentedButton
// NEVER: RaisedButton, FlatButton, BottomNavigationBar

// Colors from theme ONLY
Theme.of(context).colorScheme.primary
// NEVER: Color(0xFF5B21B6) in widgets

// 21st.dev patterns
// Clean spacing, generous whitespace, subtle borders
// Monospace for technical values (IPs, keys, latency)
// Status dots not text labels for connection state
```

## Coding rules — Go 1.24

```go
for i := range 10 {}               // range over integer
fmt.Errorf("op: %w", err)          // wrapped errors
// No panic() in production
// context.Context in all I/O
// zerolog — no fmt.Println in production
// Parameterised SQL always
```

## Security rules (never break these)

```
WireGuard private keys: memory only, never stored, never logged
Always AmneziaWG not vanilla WireGuard
XTLS-Reality domain: apple.com (real live HTTPS site)
.env for all secrets — in .gitignore always
flutter_secure_storage for client sensitive data
DNS: 1.1.1.1 in WireGuard config
AllowedIPs: 0.0.0.0/0, ::/0 (prevents IPv6 leaks)
```

---

## Current phase (update after each step)

```
Phase 0 — Proof of concept
[ ] GitHub repo + all files pushed
[ ] playit.gg account + Railway account
[ ] AmneziaWG + Xray on laptop
[ ] playit.gg UDP + TCP tunnels
[ ] Phone connects via WireGuard
[ ] JioHotstar streams ← MILESTONE
[ ] Amnezia client forked
[ ] Flutter 3.41 installed
[ ] APK builds locally
[ ] GitHub Actions pipeline working
```
