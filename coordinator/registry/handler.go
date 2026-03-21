package registry

import (
	"context"
	"database/sql"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/rs/zerolog/log"
	"golang.zx2c4.com/wireguard/wgctrl/wgtypes"
)

type Handler struct {
	db *sql.DB
}

func NewHandler(db *sql.DB) *Handler {
	return &Handler{db: db}
}

type RegisterRequest struct {
	PublicKey     string `json:"public_key" binding:"required"`
	PlayitAddress string `json:"playit_address" binding:"required"`
	City          string `json:"city"`
	CountryCode   string `json:"country_code"`
}

type HeartbeatRequest struct {
	NodeID        string `json:"node_id" binding:"required"`
	BandwidthMbps int    `json:"bandwidth_mbps"`
	LatencyMs     int    `json:"latency_ms"`
}

// RegisterNode handles new daemon connections
func (h *Handler) RegisterNode(c *gin.Context) {
	var req RegisterRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid request body"})
		return
	}

	// Validate WireGuard key
	if _, err := wgtypes.ParseKey(req.PublicKey); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid wireguard public key"})
		return
	}

	nodeID := uuid.New().String()
	ctx, cancel := context.WithTimeout(c.Request.Context(), 5*time.Second)
	defer cancel()

	query := `
		INSERT INTO nodes (id, public_key, playit_address, city, country_code, is_online, last_seen)
		VALUES (?, ?, ?, ?, ?, 1, CURRENT_TIMESTAMP)
		ON CONFLICT(public_key) DO UPDATE SET
			playit_address = excluded.playit_address,
			city = excluded.city,
			country_code = excluded.country_code,
			is_online = 1,
			last_seen = CURRENT_TIMESTAMP;
	`
	_, err := h.db.ExecContext(ctx, query, nodeID, req.PublicKey, req.PlayitAddress, req.City, req.CountryCode)
	if err != nil {
		log.Error().Err(err).Msg("failed to register node")
		c.JSON(http.StatusInternalServerError, gin.H{"error": "database error"})
		return
	}

	log.Info().Str("node_id", nodeID).Msg("node registered successfully")
	c.JSON(http.StatusOK, gin.H{"node_id": nodeID, "status": "registered"})
}

// Heartbeat updates node status
func (h *Handler) Heartbeat(c *gin.Context) {
	var req HeartbeatRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid request body"})
		return
	}

	ctx, cancel := context.WithTimeout(c.Request.Context(), 5*time.Second)
	defer cancel()

	query := `
		UPDATE nodes 
		SET bandwidth_mbps = ?, latency_ms = ?, is_online = 1, last_seen = CURRENT_TIMESTAMP
		WHERE id = ?
	`
	res, err := h.db.ExecContext(ctx, query, req.BandwidthMbps, req.LatencyMs, req.NodeID)
	if err != nil {
		log.Error().Err(err).Msg("failed to update heartbeat")
		c.JSON(http.StatusInternalServerError, gin.H{"error": "database error"})
		return
	}

	rows, _ := res.RowsAffected()
	if rows == 0 {
		c.JSON(http.StatusNotFound, gin.H{"error": "node not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "ok"})
}
