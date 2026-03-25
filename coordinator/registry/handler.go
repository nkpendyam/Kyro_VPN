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

	"github.com/nkpendyam/Kyro_VPN/coordinator/vpnconfig"
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

type GetConfigRequest struct {
	NodeID       string `json:"node_id" binding:"required"`
	ClientPubKey string `json:"client_pubkey" binding:"required"`
}

// GetConfig returns a WireGuard configuration for a specific node
func (h *Handler) GetConfig(c *gin.Context) {
	var req GetConfigRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid request body"})
		return
	}

	ctx, cancel := context.WithTimeout(c.Request.Context(), 5*time.Second)
	defer cancel()

	var pubKey, endpoint string
	err := h.db.QueryRowContext(ctx, "SELECT public_key, playit_address FROM nodes WHERE id = ? AND is_online = 1", req.NodeID).Scan(&pubKey, &endpoint)
	if err == sql.ErrNoRows {
		c.JSON(http.StatusNotFound, gin.H{"error": "node not found or offline"})
		return
	} else if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "database error"})
		return
	}

	// In a real system, we'd add the client as a peer on the node here via RPC or similar.
	// For this prototype, the node-daemon will allow any peer with a valid handshake.

	config, err := vpnconfig.Generate(vpnconfig.ConfigParams{
		ClientPrivateKey: "<CLIENT_PRIVATE_KEY>", // Placeholder: client fills this
		ClientAddress:    "10.0.0.2/24",
		ServerPublicKey:  pubKey,
		ServerEndpoint:   endpoint,
	})

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to generate config"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"config": config})
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

// FetchNodes returns all online nodes
func (h *Handler) FetchNodes(c *gin.Context) {
	ctx, cancel := context.WithTimeout(c.Request.Context(), 5*time.Second)
	defer cancel()

	rows, err := h.db.QueryContext(ctx, "SELECT id, public_key, playit_address, city, country_code, bandwidth_mbps, latency_ms FROM nodes WHERE is_online = 1")
	if err != nil {
		log.Error().Err(err).Msg("failed to fetch nodes")
		c.JSON(http.StatusInternalServerError, gin.H{"error": "database error"})
		return
	}
	defer rows.Close()

	var nodes []gin.H
	for rows.Next() {
		var id, pubKey, addr, city, country string
		var bandwidth, latency int
		if err := rows.Scan(&id, &pubKey, &addr, &city, &country, &bandwidth, &latency); err != nil {
			continue
		}
		nodes = append(nodes, gin.H{
			"node_id":      id,
			"public_key":   pubKey,
			"endpoint":     addr,
			"city":         city,
			"country_code": country,
			"bandwidth":    bandwidth,
			"latency":      latency,
		})
	}

	c.JSON(http.StatusOK, gin.H{"nodes": nodes})
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
