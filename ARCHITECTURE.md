# ARCHITECTURE.md — Kyro VPN
## Full System Architecture

---

## Traffic flow — how a user's data travels

```
USER PHONE (Kyro app)
  │
  │ 1. App asks coordinator for best node
  │    GET https://kyrovpn.is-a.dev/nodes/best
  │
  ▼
RAILWAY COORDINATOR (Go backend)
  │
  │ 2. Returns best node config
  │    { node_id, playit_endpoint, server_pubkey, xray_uuid }
  │
  ▼
USER PHONE
  │
  │ 3. App builds WireGuard config in memory
  │    Writes to /tmp/kyro-wg0.conf
  │    Starts AmneziaWG tunnel
  │    Deletes /tmp/kyro-wg0.conf immediately
  │
  ▼
playit.gg RELAY SERVER
  │
  │ 4. UDP traffic forwarded to your laptop
  │    (playit tunnels the WireGuard UDP packets)
  │
  ▼
YOUR LAPTOP (exit node)
  │
  │ 5. AmneziaWG decrypts tunnel
  │    Xray-core wraps in XTLS-Reality
  │    ISP sees: normal HTTPS to apple.com
  │
  ▼
YOUR HOME INTERNET (residential IP — never blacklisted)
  │
  ▼
JIOHOTSTAR / NETFLIX / ANY SITE
  │ Sees: your home IP, not user's IP
  │ Result: streams content normally
```

---

## System components

```
┌─────────────────────────────────────────────────────┐
│                  KYRO VPN SYSTEM                    │
│                                                     │
│  ┌─────────────────────────────────────────────┐   │
│  │         FLUTTER APP  (client/)              │   │
│  │  ┌──────────────────────────────────────┐   │   │
│  │  │  UI Layer (our code — M3 + 21st.dev) │   │   │
│  │  │  Home, Nodes, Contribute, Settings   │   │   │
│  │  └──────────────┬───────────────────────┘   │   │
│  │                 │                           │   │
│  │  ┌──────────────▼───────────────────────┐   │   │
│  │  │  Core Layer (Amnezia — don't touch)  │   │   │
│  │  │  WireGuard tunnel, Xray, Kill switch │   │   │
│  │  └──────────────────────────────────────┘   │   │
│  └─────────────────────────────────────────────┘   │
│                      │ HTTPS                       │
│                      ▼                             │
│  ┌─────────────────────────────────────────────┐   │
│  │   COORDINATOR  (coordinator/) on Railway    │   │
│  │   Node registry  │  Selector  │  Credits    │   │
│  │   Health check   │  Abuse     │  API        │   │
│  │   SQLite DB                                 │   │
│  └─────────────────────────────────────────────┘   │
│                      │                             │
│                      ▼                             │
│  ┌─────────────────────────────────────────────┐   │
│  │         EXIT NODES                          │   │
│  │  ┌─────────────────────────────────────┐   │   │
│  │  │  YOUR LAPTOP (seed node)            │   │   │
│  │  │  AmneziaWG + Xray + node-daemon     │   │   │
│  │  │  playit.gg tunnel (UDP+TCP)         │   │   │
│  │  │  Residential IP — never blacklisted │   │   │
│  │  └─────────────────────────────────────┘   │   │
│  │  ┌─────────────────────────────────────┐   │   │
│  │  │  COMMUNITY NODES (later)            │   │   │
│  │  │  Volunteer laptops running daemon   │   │   │
│  │  │  Each earns credits for bandwidth   │   │   │
│  │  └─────────────────────────────────────┘   │   │
│  └─────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────┘
```

---

## Folder structure

```
kyro-vpn/
├── GEMINI.md                   ← Gemini CLI context (auto-loaded)
├── MEMORY.md                   ← Session memory (imported by GEMINI.md)
├── ARCHITECTURE.md             ← This file (imported by GEMINI.md)
├── AGENTS.md                   ← Agent behaviour rules
├── FRONTEND.md                 ← Flutter app full spec
├── BACKEND.md                  ← Go services full spec
├── API.md                      ← All API contracts
├── SECURITY.md                 ← Security implementation
├── INFRA.md                    ← Laptop + playit.gg setup
├── APPSTORE.md                 ← Play Store + stores
├── SETUP_GUIDE.md              ← Step by step start
├── STARTER_PROMPTS.md          ← AI prompts for every task
├── TOOL_STRATEGY.md            ← Free tool switching guide
│
├── settings.json               ← Gemini CLI settings
├── .gemini/
│   └── skills/                 ← Gemini project skills
│       ├── kyro-context/SKILL.md
│       ├── kyro-frontend/SKILL.md
│       ├── kyro-backend/SKILL.md
│       └── kyro-security/SKILL.md
│       └── [1000+ from npx install]
│
├── .cursorrules                ← Cursor
├── .antigravity.md             ← Antigravity/Codeium
├── opencode.json               ← OpenCode CLI
├── .github/
│   ├── copilot-instructions.md
│   ├── dependabot.yml
│   └── workflows/
│       ├── build.yml
│       └── go-test.yml
│
├── client/                     ← Flutter app (fork amnezia-client)
│   ├── lib/
│   │   ├── main.dart
│   │   ├── app.dart
│   │   ├── core/               ← Amnezia tunnel code — DO NOT TOUCH
│   │   ├── services/           ← coordinator_api, node_service, credit_service
│   │   ├── providers/          ← Riverpod: connection, nodes, credits, settings
│   │   ├── models/             ← VpnState, VpnNode, VpnConfig, Credit
│   │   └── ui/
│   │       ├── theme/          ← kyro_theme.dart, kyro_colors.dart
│   │       ├── screens/        ← home, nodes, contribute, settings
│   │       ├── widgets/        ← connect_button, node_card, shield_animation
│   │       └── shell.dart      ← NavigationBar shell
│   ├── assets/
│   │   ├── icons/              ← app icons (1024x1024 master)
│   │   └── images/
│   └── test/
│
├── coordinator/                ← Go backend (Railway)
│   ├── main.go
│   ├── config/config.go
│   ├── db/schema.sql + migrate.go
│   ├── registry/               ← node CRUD, heartbeat
│   ├── selector/               ← smart node algorithm
│   ├── credits/                ← earn/spend system
│   ├── vpnconfig/              ← WireGuard config generator
│   ├── monitoring/             ← health + abuse
│   ├── middleware/             ← rate limit, logger
│   └── go.mod
│
├── node-daemon/                ← Go (runs on laptop + community nodes)
│   ├── main.go
│   ├── registration/           ← self-register with coordinator
│   ├── wireguard/              ← AmneziaWG management
│   ├── xray/                   ← Xray-core config
│   ├── health/                 ← heartbeat to coordinator
│   ├── bandwidth/              ← measure GB contributed
│   ├── abuse/                  ← rate limit + blocklists
│   └── go.mod
│
└── infra/
    ├── laptop/                 ← Setup scripts for laptop server
    └── cloudflare/             ← Cloudflare tunnel config
```

---

## Database schema (SQLite — coordinator)

```sql
CREATE TABLE nodes (
    id             TEXT PRIMARY KEY,
    public_key     TEXT NOT NULL UNIQUE,
    playit_address TEXT NOT NULL,
    city           TEXT,
    country_code   TEXT,
    flag_emoji     TEXT,
    is_seed        INTEGER DEFAULT 0,
    is_online      INTEGER DEFAULT 0,
    bandwidth_mbps INTEGER DEFAULT 0,
    latency_ms     INTEGER DEFAULT 0,
    online_users   INTEGER DEFAULT 0,
    uptime_pct     REAL DEFAULT 0,
    last_seen      DATETIME,
    joined_at      DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE node_blacklists (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    node_id     TEXT REFERENCES nodes(id),
    platform    TEXT NOT NULL,
    detected_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    cleared_at  DATETIME
);

CREATE TABLE credits (
    device_id    TEXT PRIMARY KEY,
    balance      INTEGER DEFAULT 0,
    total_earned INTEGER DEFAULT 0,
    total_spent  INTEGER DEFAULT 0,
    updated_at   DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE credit_transactions (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    device_id  TEXT NOT NULL,
    amount     INTEGER NOT NULL,
    reason     TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE health_logs (
    id             INTEGER PRIMARY KEY AUTOINCREMENT,
    node_id        TEXT REFERENCES nodes(id),
    latency_ms     INTEGER,
    bandwidth_mbps INTEGER,
    peer_count     INTEGER,
    logged_at      DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE abuse_reports (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    node_id     TEXT REFERENCES nodes(id),
    report_type TEXT NOT NULL,
    reported_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    resolved    INTEGER DEFAULT 0
);
```

---

## Tech decisions rationale

| Choice | Reason |
|--------|--------|
| Laptop as server | Residential IP, ₹0 cost, best for streaming |
| playit.gg | Free UDP+TCP tunnel, no router config |
| AmneziaWG | Vanilla WireGuard fingerprinted in <1s by ISPs |
| XTLS-Reality | Only obfuscation that passes China GFW — strongest 2026 |
| M3 Expressive | Latest Google Stitch — most modern Flutter UI 2026 |
| 21st.dev patterns | Clean minimal design, professional look |
| Railway | Free Go backend, no sleep like Render, GitHub deploy |
| Riverpod | Best for VPN state complexity — async tunnel states |
| Go 1.24 | Same ecosystem as WireGuard tools, single binary |
| SQLite | Zero setup, Railway persistent volume, scales to 10k nodes |
