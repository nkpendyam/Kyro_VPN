---
name: kyro-context
description: >
  Loads full Kyro VPN project context. Use this skill at the start of
  any Kyro VPN development session, or when context about the project
  architecture, infrastructure, tech stack, or coding rules is needed.
  Activate when working on anything related to Kyro VPN.
---

# Kyro VPN — Project Context Skill

## Project identity
- Open source VPN app — Flutter + Go + AmneziaWG + Xray-core
- Server: developer's laptop (residential IP — best for streaming)
- Tunneling: playit.gg (free UDP+TCP, no port forwarding)
- Backend: Railway.app (free Go, GitHub login)
- Domain: kyrovpn.is-a.dev (is-a.dev free subdomain)

## Infrastructure (₹0)
- Laptop runs: AmneziaWG + Xray-core XTLS-Reality
- playit.gg tunnels: UDP→51820 (WireGuard), TCP→443 (Xray)
- Railway: Go coordinator backend
- GitHub Actions: CI/CD + APK builds (free, public repo)
- GitHub Releases: app distribution

## Key repos (fork, don't rewrite)
- amnezia-vpn/amnezia-client — Flutter base (GPL-3.0)
- XTLS/Xray-core — obfuscation engine (MPL-2.0)
- amnezia-vpn/amneziawg-go — WireGuard variant (MIT)
- mysteriumnetwork/node — P2P discovery (GPL-3.0)

## We build (only these 4)
1. Credit + contribution system (no crypto)
2. Smart node selector algorithm
3. New M3 Expressive + 21st.dev UI
4. Abuse monitoring + health dashboard

## Flutter rules (Flutter 3.41, Dart 3.10)
- useMaterial3: true always
- Dart 3.10 dot shorthands: .all(16) not EdgeInsets.all(16)
- Sealed classes for VpnState
- Riverpod @riverpod codegen — never setState
- Colors from Theme.of(context).colorScheme only
- M3 components: FilledButton, NavigationBar, Card, SearchBar
- NEVER: RaisedButton, FlatButton, BottomNavigationBar

## Go rules (Go 1.24)
- Return all errors — no panic() in production
- context.Context in all I/O
- zerolog — no fmt.Println in production
- for i := range 10 {} (range over integer)
- Parameterised SQL always

## Security (never break)
- WireGuard keys: memory only, never stored, never logged
- Always AmneziaWG not vanilla WireGuard
- XTLS-Reality domain: apple.com
- .env for secrets, always gitignored
- flutter_secure_storage for client secrets

## Current phase
Check MEMORY.md for current phase and last session notes.
Never work on features outside the current phase.

## Before writing any code
1. Check if amnezia-client already has this feature
2. Check MEMORY.md for architectural decisions
3. Confirm task is in current phase scope
