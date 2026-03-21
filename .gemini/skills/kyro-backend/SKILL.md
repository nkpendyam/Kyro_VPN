---
name: kyro-backend
description: >
  Expert Go backend development for Kyro VPN coordinator and node daemon.
  Activate when writing Go code for coordinator/, node-daemon/, or any
  backend services. Enforces Go 1.24 standards, Gin patterns, zerolog,
  SQLite queries, and VPN-specific backend requirements.
---

# Kyro Backend Skill — Go 1.24

## Go 1.24 standards

```go
// Range over integer (Go 1.22+)
for i := range 10 { }

// Wrapped errors
return fmt.Errorf("registerNode: %w", err)

// Structured logging — zerolog always
log.Info().Str("node_id", id).Int("latency", ms).Msg("heartbeat received")
// NEVER: fmt.Println, log.Printf

// context.Context in ALL I/O functions
func (s *Store) GetNode(ctx context.Context, id string) (*Node, error) {}

// No panic() in production handlers
// All errors returned and handled
```

## Gin handler pattern

```go
func (h *Handler) RegisterNode(c *gin.Context) {
    var req RegisterNodeRequest
    if err := c.ShouldBindJSON(&req); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": "invalid request"})
        return
    }
    // Validate WireGuard public key
    if _, err := wgtypes.ParseKey(req.PublicKey); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": "invalid public key"})
        return
    }
    node, err := h.store.Register(c.Request.Context(), req)
    if err != nil {
        log.Error().Err(err).Msg("register node failed")
        c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
        return
    }
    c.JSON(http.StatusCreated, node)
}
```

## SQLite — parameterised always

```go
// CORRECT
db.QueryContext(ctx, "SELECT * FROM nodes WHERE city = ?", city)

// NEVER
db.Query("SELECT * FROM nodes WHERE city = '" + city + "'")
```

## Node scoring algorithm

```go
// coordinator/selector/selector.go
func ScoreNode(n Node, uc UseCase) float64 {
    bw  := min(float64(n.BandwidthMbps)/100.0, 1.0)
    up  := n.UptimePct / 100.0
    lat := 1.0 - min(float64(n.LatencyMs)/500.0, 1.0)
    fresh := freshness(n)

    switch uc {
    case Streaming:
        if isBlacklisted(n) { return 0 }
        return bw*0.5 + lat*0.3 + up*0.1 + fresh*0.1
    case Privacy:
        anon := min(float64(n.OnlineUsers)/20.0, 1.0)
        return up*0.4 + anon*0.3 + lat*0.2 + fresh*0.1
    case Speed:
        return bw*0.6 + lat*0.3 + up*0.1
    default: // auto
        return bw*0.4 + up*0.3 + lat*0.2 + fresh*0.1
    }
}
```

## Credit rates (constants)

```go
const (
    CreditsPerGB     = 10   // earn 10 credits per GB shared
    CostPerGB        = 10   // spend 10 credits per GB on premium nodes
    PremiumThreshold = 500  // 500 credits unlocks premium nodes
)
```

## go.mod packages

```
github.com/gin-gonic/gin
github.com/rs/zerolog
github.com/mattn/go-sqlite3
github.com/jmoiron/sqlx
github.com/google/uuid
golang.zx2c4.com/wireguard
github.com/gin-contrib/cors
golang.org/x/time  (rate limiting)
```

## After every Go file
Run: go vet ./...
Run: go test ./...
Must be clean.
