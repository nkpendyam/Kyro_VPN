package selector

import (
	"context"
	"database/sql"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/rs/zerolog/log"
)

type Node struct {
	ID            string
	PublicKey     string
	PlayitAddress string
	City          string
	CountryCode   string
	BandwidthMbps int
	LatencyMs     int
	UptimePct     float64
	JoinedAt      time.Time
}

type Handler struct {
	db *sql.DB
}

func NewHandler(db *sql.DB) *Handler {
	return &Handler{db: db}
}

// GetBestNode selects a node based on the scoring algorithm
func (h *Handler) GetBestNode(c *gin.Context) {
	ctx, cancel := context.WithTimeout(c.Request.Context(), 5*time.Second)
	defer cancel()

	// Simple fetching of online nodes for scoring (limit 50 for efficiency)
	query := `
		SELECT id, public_key, playit_address, city, country_code, bandwidth_mbps, latency_ms, uptime_pct, joined_at
		FROM nodes
		WHERE is_online = 1
		LIMIT 50
	`
	rows, err := h.db.QueryContext(ctx, query)
	if err != nil {
		log.Error().Err(err).Msg("failed to fetch nodes for selection")
		c.JSON(http.StatusInternalServerError, gin.H{"error": "database error"})
		return
	}
	defer rows.Close()

	var bestNode *Node
	var maxScore float64 = -1

	for rows.Next() {
		var n Node
		if err := rows.Scan(&n.ID, &n.PublicKey, &n.PlayitAddress, &n.City, &n.CountryCode, &n.BandwidthMbps, &n.LatencyMs, &n.UptimePct, &n.JoinedAt); err != nil {
			continue
		}

		score := scoreNode(n)
		if score > maxScore {
			maxScore = score
			bestNode = &n
		}
	}

	if bestNode == nil {
		c.JSON(http.StatusServiceUnavailable, gin.H{"error": "no nodes available"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"node_id": bestNode.ID,
		"public_key": bestNode.PublicKey,
		"endpoint": bestNode.PlayitAddress,
		"city": bestNode.City,
		"country_code": bestNode.CountryCode,
	})
}

// scoreNode algorithm from Kyro specs
func scoreNode(n Node) float64 {
	bw := min(float64(n.BandwidthMbps)/100.0, 1.0)
	up := n.UptimePct / 100.0
	lat := 1.0 - min(float64(n.LatencyMs)/500.0, 1.0)
	
	// Freshness: slightly favor nodes that joined recently but not too recently (to encourage turnover)
	hours := time.Since(n.JoinedAt).Hours()
	fresh := 1.0
	if hours > 0 {
		fresh = min(24.0 / hours, 1.0)
	}

	// Auto use-case weights: Bandwidth(40%) + Uptime(30%) + Latency(20%) + Freshness(10%)
	return bw*0.4 + up*0.3 + lat*0.2 + fresh*0.1
}

func min(a, b float64) float64 {
	if a < b {
		return a
	}
	return b
}
