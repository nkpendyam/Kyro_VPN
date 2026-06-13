# Kyro VPN — turn your laptop into a personal VPN exit node

Kyro VPN is a self-hosted VPN system: an Android client connects through a coordinator service to your own laptop, which acts as the VPN exit node over an obfuscated WireGuard/AmneziaWG + Xray-core (XTLS-Reality) tunnel.

## Features

- **Flutter mobile client** (`client/`) — connects to the best available exit node and builds the tunnel config in memory
- **Go coordinator service** (`coordinator/`) — picks the best exit node and hands out connection configs (designed for Railway deployment)
- **Go node daemon** (`node-daemon/`) — runs on your laptop, turning it into the VPN exit node
- **Obfuscated tunnel** — AmneziaWG/WireGuard wrapped in Xray-core XTLS-Reality so traffic looks like normal HTTPS
- **Web dashboard** (`kyro-dashboard/`) — TypeScript monorepo (React, TanStack Router, Hono, TRPC) for managing nodes
- **Free-tier exit-node tunneling** — works with Portmap.io, Localtonet, or playit.gg

## Prerequisites

- Flutter SDK (for `client/`)
- Go 1.26+ (for `coordinator/` and `node-daemon/`)
- Node.js + npm/bun (for `kyro-dashboard/`, a Turborepo workspace)
- AmneziaWG/WireGuard tooling on the laptop used as the exit node
- An account with a free tunneling provider (Portmap.io, Localtonet, or playit.gg)

## Installation

```bash
git clone https://github.com/nkpendyam/Kyro_VPN.git
cd Kyro_VPN

# Mobile client
cd client && flutter pub get && cd ..

# Coordinator (Go backend)
cd coordinator && go mod download && cd ..

# Node daemon (exit-node agent)
cd node-daemon && go mod download && cd ..

# Web dashboard (Turborepo monorepo)
cd kyro-dashboard && npm install && cd ..
```

## Usage

```bash
# Run the coordinator service
cd coordinator && go run .

# Run the node daemon on the exit-node laptop
cd node-daemon && go run .

# Run the dashboard in dev mode
cd kyro-dashboard && npm run dev

# Run the Flutter client
cd client && flutter run
```

For the full traffic-flow architecture, see [ARCHITECTURE.md](ARCHITECTURE.md). For a from-zero setup walkthrough, see [SETUP_GUIDE.md](SETUP_GUIDE.md). For exit-node tunneling setup, see [INFRA.md](INFRA.md). For the coordinator API, see [API.md](API.md).

## License

GPL-3.0 — see [LICENSE](LICENSE).
