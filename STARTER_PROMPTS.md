# STARTER_PROMPTS.md — Kyro VPN
## All Gemini CLI Prompts

---

## THE ONE PROMPT — paste this to start everything

```
Read GEMINI.md and all @imported files.
Use the kyro-context skill.

Project: Kyro VPN — open source Flutter VPN.
Server: my laptop with playit.gg tunnels (no port forwarding, no VPS).
Stack: Flutter 3.41 + Dart 3.10 + Go 1.24 + AmneziaWG + Xray-core XTLS-Reality.
UI: Material Design 3 Expressive (Google Stitch 2026) + 21st.dev patterns.
Backend: Go coordinator on Railway.app (free).
Distribution: GitHub Releases (free, automatic on push to tag).

Check MEMORY.md for what was done last session.
Tell me what phase I am in and what to do next.
Then help me with: [DESCRIBE WHAT YOU WANT TODAY]
```

---

## DAILY STARTER (paste every session)

```
Read GEMINI.md. Use kyro-context skill.
Check MEMORY.md — what phase, what's next.
Today I want to: [YOUR GOAL]
```

---

## PROMPT: Laptop server setup

```
Use kyro-context skill. Read INFRA.md.

My laptop OS: [LINUX/WINDOWS/MACOS]

Write complete setup commands for my laptop as Kyro VPN server:
1. Install AmneziaWG + generate server + client keypairs
2. Create wg0.conf with Jc=4 junk packet settings
3. Install Xray-core + generate XTLS-Reality keys (apple.com destination)
4. Create Xray config.json
5. Install + configure playit.gg agent
6. Create UDP tunnel (port 51820) + TCP tunnel (port 443) in playit.gg
7. Autostart all services on laptop boot

Write commands for [MY OS] only.
I will run them manually — do NOT execute anything.
Use kyro-security skill to audit the WireGuard and Xray configs.
```

---

## PROMPT: Update Amnezia to Flutter 3.41 + Dart 3.10

```
Use kyro-context and kyro-frontend skills. Read FRONTEND.md.

I forked amnezia-client into client/
Update it to Flutter 3.41 + Dart 3.10:

1. client/pubspec.yaml — full dependency list from FRONTEND.md
2. android/app/build.gradle — compileSdk 35, targetSdk 35, NDK r28
3. client/lib/ui/theme/kyro_theme.dart — M3 Expressive, seed #5B21B6
4. client/lib/ui/theme/kyro_colors.dart — status colors

Do NOT touch client/core/ (Amnezia tunnel code).
After: run flutter analyze — must be clean.
Update MEMORY.md.
```

---

## PROMPT: Build home screen

```
Use kyro-frontend skill. Read FRONTEND.md home screen spec.

Build client/lib/ui/screens/home_screen.dart:
- Dart 3.10: dot shorthands, sealed VpnState
- Shield widget (pulse ring when connected, rotating when connecting)
- FilledButton "Connect"/"Disconnect" — 56dp full width
- Status text from displayMedium typography
- Node card: flag + city + latency dot (21st.dev style, 0.5px border)
- Session timer when connected
- NavigationBar: Home/Nodes/Contribute/Settings

Create separately:
- lib/providers/connection_provider.dart (Riverpod @riverpod)
- lib/ui/widgets/shield_animation.dart
- lib/ui/widgets/connect_button.dart
- lib/models/vpn_state.dart (sealed class)

No hardcoded colors. Colors from colorScheme only.
Run flutter analyze after. Update MEMORY.md.
```

---

## PROMPT: Build coordinator Go backend

```
Use kyro-backend skill. Read BACKEND.md and API.md.

Build coordinator v0 (deploys to Railway):
- coordinator/main.go — Gin server + all routes
- coordinator/config/config.go — env vars
- coordinator/db/schema.sql — full schema from ARCHITECTURE.md
- coordinator/db/migrate.go — run on startup
- coordinator/registry/models.go — Node struct json tags
- coordinator/registry/store.go — SQLite parameterised queries
- coordinator/registry/handler.go — GET /nodes, POST /register, POST /heartbeat
- coordinator/registry/handler_test.go
- coordinator/middleware/ratelimit.go
- coordinator/Dockerfile — for Railway

Go 1.24: range integers, wrapped errors, zerolog.
Use kyro-security skill on handler.go.
Run go test ./... + go vet ./...
Update MEMORY.md.
```

---

## PROMPT: GitHub Actions pipeline

```
Use kyro-context skill. Read APPSTORE.md.

Create complete GitHub Actions pipeline:

.github/workflows/build.yml:
- Trigger: push to tags v*
- Job 1: Android APK (Flutter 3.41, NDK r28, signed)
- Job 2: Linux AppImage
- Job 3: Windows exe
- Job 4: GitHub Release with all artifacts + release notes

.github/workflows/go-test.yml:
- Trigger: push to main + PRs
- go test + go vet + golangci-lint on coordinator/ + node-daemon/

.github/dependabot.yml:
- Flutter: weekly, Go: weekly, Actions: monthly

List GitHub Secrets I need to add (KEYSTORE_BASE64, etc).
Public repo = unlimited Actions minutes.
```

---

## PROMPT: Smart node selector

```
Use kyro-backend skill. Read BACKEND.md selector section.

Build coordinator/selector/selector.go:

Scoring formula:
- streaming: bw*0.5 + lat_inv*0.3 + uptime*0.1 + fresh*0.1 (skip blacklisted)
- privacy: uptime*0.4 + anonymity*0.3 + lat_inv*0.2 + fresh*0.1
- speed: bw*0.6 + lat_inv*0.3 + uptime*0.1
- auto: bw*0.4 + uptime*0.3 + lat_inv*0.2 + fresh*0.1

coordinator/selector/selector_test.go:
- Edge: no nodes online
- Edge: all nodes blacklisted
- Edge: single node

Use @test-driven-development skill.
Go 1.24 standards. Run go test.
```

---

## PROMPT: Pre-release check

```
Use kyro-security skill. Read SECURITY.md.

I am releasing v[VERSION]. Run full security audit:

1. flutter analyze — zero issues required
2. go vet ./... on coordinator/ and node-daemon/
3. Security check:
   - No private keys in any file
   - .gitignore covers .env *.key *.jks key.properties wg0.conf
   - No hardcoded addresses in client code
   - playit.gg addresses from config not hardcoded
4. Prepare release:
   - Write GitHub release notes
   - List what was tested and what wasn't

After approval:
git tag -a v[VERSION] -m "Release v[VERSION]"
git push origin v[VERSION]
(GitHub Actions builds and creates release automatically)

Update MEMORY.md with release version and date.
```

---

## PROMPT: Debugging

```
Use kyro-context skill. Read MEMORY.md.

Stuck on: [EXACT PROBLEM]
File: [FILE]
Error: [EXACT ERROR]

Use @debugging-strategies skill.
Check if amnezia-client has this same issue (GitHub MCP).
Diagnose step by step.
Show exact fix with line numbers.
Run flutter analyze / go vet after fix.
Update MEMORY.md bug log.
```
