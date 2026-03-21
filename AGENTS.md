# AGENTS.md — Kyro VPN
## Gemini CLI Agent Rules

---

## Start of every task
1. Read GEMINI.md (auto-loaded by Gemini CLI)
2. Check MEMORY.md for last session + decisions
3. Check phase tracker in MEMORY.md — current phase only
4. State which skill activating: "Activating kyro-frontend skill"

---

## Safe to do autonomously

### Files
- Read any project file
- Create in: client/lib/, coordinator/, node-daemon/, docs/
- Edit files in those directories
- Create *_test.go and *_test.dart files

### Commands
```bash
go build ./...
go test ./...
go vet ./...
flutter analyze
flutter test
flutter pub get
flutter build apk --debug
dart format .
dart run build_runner build
git status
git diff
git add .
git commit -m "message"
```

---

## STOP — ask first

### Laptop server (never touch without permission)
- systemctl start/stop/restart on production services
- Changes to wg0.conf or Xray config.json
- playit.gg tunnel creation or deletion
- Any SSH command

### Costs money
- Any paid service signup
- Anything beyond Railway free tier

### Security-sensitive
- Writing WireGuard keys to any file
- Logging any key, UUID, or password

### Destructive
- rm -rf outside /tmp
- Drop database
- git push --force on main
- Overwriting GEMINI.md, MEMORY.md, AGENTS.md

### Out of current phase
- iOS builds (Phase 3+, needs Mac)
- Play Store upload (Phase 3, needs $25)
- Firebase or any analytics (banned permanently)
- User login / accounts (Phase 3)

---

## MCP tools available

```json
{
  "filesystem": "read/write project files",
  "github": "read upstream repos via GitHub API"
}
```

Use GitHub MCP to read:
- amnezia-vpn/amnezia-client (before writing tunnel code)
- XTLS/Xray-core/infra/conf (Xray config examples)
- mysteriumnetwork/node/p2p (P2P discovery patterns)

---

## After every task
1. Run flutter analyze or go vet
2. Update MEMORY.md session log
3. Report: what changed, what files, what is next

---

## Gemini CLI specific commands
```
/skills          — list all available skills
/memory show     — see full loaded context
/memory reload   — reload GEMINI.md + imports after updating MEMORY.md
/memory add      — add a quick note to global GEMINI.md
```
