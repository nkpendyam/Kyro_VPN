package main

import (
	"context"
	"database/sql"
	"net/http"
	"os"
	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	_ "github.com/mattn/go-sqlite3"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

type Node struct {
	ID            string    `json:"id"`
	PublicKey     string    `json:"public_key"`
	PlayitAddress string    `json:"playit_address"`
	City          string    `json:"city"`
	CountryCode   string    `json:"country_code"`
	IsSeed        bool      `json:"is_seed"`
	IsOnline      bool      `json:"is_online"`
	LastSeen      time.Time `json:"last_seen"`
}

func main() {
	// Setup logger
	zerolog.TimeFieldFormat = zerolog.TimeFormatUnix
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stderr})

	// Database setup
	db, err := sql.Open("sqlite3", "./kyro.db")
	if err != nil {
		log.Fatal().Err(err).Msg("failed to open database")
	}
	defer db.Close()

	// Initialize schema
	schema, err := os.ReadFile("db/schema.sql")
	if err != nil {
		log.Fatal().Err(err).Msg("failed to read schema file")
	}
	if _, err := db.Exec(string(schema)); err != nil {
		log.Fatal().Err(err).Msg("failed to initialize schema")
	}

	// Router setup
	r := gin.New()
	r.Use(gin.Recovery())
	r.Use(cors.Default())

	// Health check
	r.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"status": "ok"})
	})

	// Node API
	r.GET("/nodes/best", func(c *gin.Context) {
		// Placeholder for smart node selector logic
		c.JSON(http.StatusOK, gin.H{"message": "Node selector not implemented yet"})
	})

	// Start server
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	log.Info().Str("port", port).Msg("starting Kyro coordinator")
	if err := r.Run(":" + port); err != nil {
		log.Fatal().Err(err).Msg("server failed")
	}
}

// Helper to wrap context (Go 1.24 pattern)
func withTimeout(ctx context.Context) (context.Context, context.CancelFunc) {
	return context.WithTimeout(ctx, 5*time.Second)
}
