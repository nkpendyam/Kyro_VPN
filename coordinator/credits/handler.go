package credits

import (
	"context"
	"database/sql"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/rs/zerolog/log"
)

const (
	CreditsPerGB     = 10
	CostPerGB        = 10
	PremiumThreshold = 500
)

type Handler struct {
	db *sql.DB
}

func NewHandler(db *sql.DB) *Handler {
	return &Handler{db: db}
}

type TransactionRequest struct {
	Amount int    `json:"amount" binding:"required"`
	Reason string `json:"reason" binding:"required"`
}

// GetBalance returns user credits
func (h *Handler) GetBalance(c *gin.Context) {
	deviceId := c.GetString("deviceId")

	ctx, cancel := context.WithTimeout(c.Request.Context(), 5*time.Second)
	defer cancel()

	var balance int
	err := h.db.QueryRowContext(ctx, "SELECT balance FROM credits WHERE device_id = ?", deviceId).Scan(&balance)
	
	if err == sql.ErrNoRows {
		// Auto-initialize balance for new devices
		_, _ = h.db.ExecContext(ctx, "INSERT INTO credits (device_id, balance) VALUES (?, 0)", deviceId)
		balance = 0
	} else if err != nil {
		log.Error().Err(err).Msg("failed to fetch credits")
		c.JSON(http.StatusInternalServerError, gin.H{"error": "database error"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"device_id": deviceId,
		"balance": balance,
		"premium_unlocked": balance >= PremiumThreshold,
	})
}

// AddTransaction modifies user credits (earn or spend)
func (h *Handler) AddTransaction(c *gin.Context) {
	deviceId := c.GetString("deviceId")
	var req TransactionRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid request body"})
		return
	}

	ctx, cancel := context.WithTimeout(c.Request.Context(), 5*time.Second)
	defer cancel()

	tx, err := h.db.BeginTx(ctx, nil)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "tx failed"})
		return
	}

	// Upsert credits
	_, err = tx.ExecContext(ctx, `
		INSERT INTO credits (device_id, balance, total_earned) 
		VALUES (?, ?, ?)
		ON CONFLICT(device_id) DO UPDATE SET 
			balance = balance + excluded.balance,
			total_earned = total_earned + excluded.total_earned,
			updated_at = CURRENT_TIMESTAMP
	`, deviceId, req.Amount, max(0, req.Amount))

	if err != nil {
		tx.Rollback()
		c.JSON(http.StatusInternalServerError, gin.H{"error": "update failed"})
		return
	}

	// Log transaction
	_, err = tx.ExecContext(ctx, `
		INSERT INTO credit_transactions (device_id, amount, reason)
		VALUES (?, ?, ?)
	`, deviceId, req.Amount, req.Reason)

	if err != nil {
		tx.Rollback()
		c.JSON(http.StatusInternalServerError, gin.H{"error": "log failed"})
		return
	}

	tx.Commit()
	c.JSON(http.StatusOK, gin.H{"status": "transaction applied"})
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}
