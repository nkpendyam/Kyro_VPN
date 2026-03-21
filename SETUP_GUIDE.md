# SETUP_GUIDE.md — Kyro VPN
## From Zero to First APK — Exact Steps

---

## What you need
- Laptop (Windows/Linux/macOS)
- Android phone
- Internet connection
- GitHub account + email
- ₹0

---

## DAY 1 — Accounts + repo (2 hours)

### Step 1 — Install Gemini CLI

```bash
# Requires Node.js (nodejs.org if not installed)

npm install -g @google/gemini-cli

# Verify
gemini --version

# First run — authenticate with Google account
gemini
# Opens browser → sign in with Google account → done
```

### Step 2 — Create GitHub repo
1. github.com → "+" → New repository
2. Name: `kyro-vpn`
3. Public (required — free Actions for public)
4. License: GPL-3.0
5. Add README: yes
6. Create

### Step 3 — Clone + create folders

```bash
git clone https://github.com/YOURUSERNAME/kyro-vpn.git
cd kyro-vpn

# Linux/macOS
mkdir -p .gemini/skills/{kyro-context,kyro-frontend,kyro-backend,kyro-security}
mkdir -p .github/workflows .github/ISSUE_TEMPLATE
mkdir -p client/lib/{core,ui/screens,ui/widgets,ui/theme,models,services,providers}
mkdir -p client/assets/{icons,images}
mkdir -p coordinator/{registry,selector,credits,monitoring,db,vpnconfig,middleware}
mkdir -p node-daemon/{wireguard,xray,health,abuse,bandwidth,registration}
mkdir -p infra/{laptop,cloudflare} docs

# Windows PowerShell
$dirs = ".gemini/skills/kyro-context", ".gemini/skills/kyro-frontend",
  ".gemini/skills/kyro-backend", ".gemini/skills/kyro-security",
  ".github/workflows", "client/lib/core", "client/lib/ui/screens",
  "client/lib/ui/widgets", "client/lib/ui/theme",
  "client/lib/models", "client/lib/services", "client/lib/providers",
  "client/assets/icons", "client/assets/images",
  "coordinator/registry", "coordinator/selector", "coordinator/credits",
  "coordinator/monitoring", "coordinator/db", "coordinator/vpnconfig",
  "coordinator/middleware", "node-daemon/wireguard", "node-daemon/xray",
  "node-daemon/health", "node-daemon/abuse", "node-daemon/bandwidth",
  "infra/laptop", "infra/cloudflare", "docs"
$dirs | ForEach-Object { New-Item -ItemType Directory -Force $_ }
```

### Step 4 — Place all downloaded files

```
kyro-vpn/
├── GEMINI.md          ← place here
├── MEMORY.md          ← place here
├── AGENTS.md          ← place here
├── ARCHITECTURE.md    ← place here
├── FRONTEND.md        ← place here
├── BACKEND.md         ← place here
├── API.md             ← place here
├── SECURITY.md        ← place here
├── INFRA.md           ← place here
├── APPSTORE.md        ← place here
├── SETUP_GUIDE.md     ← place here
├── STARTER_PROMPTS.md ← place here
├── TOOL_STRATEGY.md   ← place here
├── settings.json      ← place here (Gemini CLI config)
├── .cursorrules       ← place here
├── .antigravity.md    ← place here
├── opencode.json      ← place here
├── .github/copilot-instructions.md ← place here
└── .gemini/skills/
    ├── kyro-context/SKILL.md    ← place here
    ├── kyro-frontend/SKILL.md   ← place here
    ├── kyro-backend/SKILL.md    ← place here
    └── kyro-security/SKILL.md   ← place here
```

### Step 5 — Create .gitignore

```
.env
.env.*
*.key
*.pem
*.jks
*.keystore
key.properties
wg0.conf
server_private.key
client_private.key
config.json
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
build/
.pub-cache/
coordinator/dev.db
node-daemon/dev.db
.idea/
.vscode/
.DS_Store
__pycache__/
```

### Step 6 — Install 1000+ skills

```bash
# In project root
npx antigravity-awesome-skills --gemini

# Verify
ls .gemini/skills/ | head -10
# Should show: architecture, brainstorming, frontend-design, etc.
```

### Step 7 — Push to GitHub

```bash
git add .
git commit -m "chore: Kyro VPN initial setup with Gemini CLI"
git push origin main
```

### Step 8 — Sign up free services

**playit.gg** (5 min, email only)
→ playit.gg → sign up → download agent for your OS

**Railway.app** (2 min, GitHub login)
→ railway.app → Login with GitHub → done

**is-a.dev** (free domain, 48hr approval)
→ github.com/is-a-dev/register → fork → add domains/kyrovpn.json → PR

---

## DAY 2-3 — Laptop server (1-2 hours)

Open terminal in project folder. Start Gemini CLI:

```bash
gemini
```

Paste this prompt:

```
Use kyro-context skill. Read INFRA.md.
My laptop runs [LINUX/WINDOWS/MACOS].
Write all setup commands to make my laptop a Kyro VPN server.
Include AmneziaWG, Xray-core XTLS-Reality, and playit.gg tunnels.
I will run commands manually.
```

Gemini writes the scripts. You run them one by one.

---

## DAY 4 — THE MILESTONE

Connect phone via WireGuard app (INFRA.md Step 7).
Open JioHotstar. If it streams — Kyro VPN works.

Update MEMORY.md:
```
MILESTONE: JioHotstar streams through laptop + playit.gg tunnel
Date: [today]
```

Type in Gemini CLI: `/memory reload`

---

## DAY 5-7 — Flutter setup

### Install Flutter 3.41

**Linux:**
```bash
sudo snap install flutter --classic
flutter doctor
```

**Windows:**
```
Download from flutter.dev → extract → add bin to PATH
Open new PowerShell: flutter doctor
```

**macOS:**
```bash
brew install flutter
flutter doctor
```

Fix all red items from `flutter doctor`.

### Fork Amnezia client
```bash
# Fork on GitHub first: github.com/amnezia-vpn/amnezia-client
git clone https://github.com/YOURUSERNAME/amnezia-client.git client
cd client
flutter pub get
flutter build apk --debug
```

If APK builds → you have a working Flutter VPN base.

---

## WEEK 2 — Start building with Gemini CLI

Open project in terminal:
```bash
cd kyro-vpn
gemini
```

Paste THE ONE PROMPT from STARTER_PROMPTS.md.
Gemini reads all context, checks MEMORY.md, tells you what to build.

---

## Gemini CLI daily commands

```bash
# Start
gemini

# Inside Gemini CLI:
/skills              # see available skills
/memory show         # see what context is loaded
/memory reload       # reload after updating MEMORY.md

# After each session — update MEMORY.md then:
/memory reload
```

---

## Install Go (for coordinator backend)

**Linux:**
```bash
sudo snap install go --classic
go version  # should say go1.24.x
```

**Windows:**
```
Download from go.dev → run installer → restart terminal
go version
```

**macOS:**
```bash
brew install go
go version
```

---

## Common issues

**Gemini CLI can't find GEMINI.md:**
```bash
# Make sure you're in project root
pwd  # should end in /kyro-vpn
gemini
```

**Skills not showing up:**
```bash
gemini
/skills  # should list skills
# If empty: run npx antigravity-awesome-skills --gemini again
```

**WireGuard phone can't connect:**
- Check playit.gg dashboard — tunnel should be green/active
- Check endpoint in phone config matches playit address exactly
- Check: `sudo awg show` — should show interface + peer

**Flutter doctor shows issues:**
```bash
flutter doctor --android-licenses  # accept licenses
flutter doctor  # check again
```
