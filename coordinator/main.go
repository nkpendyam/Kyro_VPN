package main

import (
	"context"
	"database/sql"
	"net/http"
	"os"
	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	_ "modernc.org/sqlite"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"

	"github.com/nkpendyam/Kyro_VPN/coordinator/credits"
	"github.com/nkpendyam/Kyro_VPN/coordinator/middleware"
	"github.com/nkpendyam/Kyro_VPN/coordinator/registry"
	"github.com/nkpendyam/Kyro_VPN/coordinator/selector"
)

func main() {
	// Setup logger
	zerolog.TimeFieldFormat = zerolog.TimeFormatUnix
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stderr})

	// Database setup
	db, err := sql.Open("sqlite", "./kyro.db")
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

	// Handlers
	registryHandler := registry.NewHandler(db)
	selectorHandler := selector.NewHandler(db)
	creditsHandler := credits.NewHandler(db)

	// Router setup
	r := gin.New()
	r.Use(gin.Recovery())
	r.Use(cors.Default())
	r.Use(middleware.RateLimit())

	// Health check
	r.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"status": "ok"})
	})

	// Public APIs
	nodesGroup := r.Group("/nodes")
	{
		nodesGroup.GET("", registryHandler.FetchNodes)
		nodesGroup.GET("/best", selectorHandler.GetBestNode)
		nodesGroup.POST("/register", registryHandler.RegisterNode)
		nodesGroup.POST("/heartbeat", registryHandler.Heartbeat)
	}

	r.POST("/vpn/config", registryHandler.GetConfig)

	// Protected APIs (Require Device ID)
	authGroup := r.Group("/auth")
	authGroup.Use(middleware.DeviceAuth())
	{
		authGroup.GET("/credits", creditsHandler.GetBalance)
		authGroup.POST("/credits/transaction", creditsHandler.AddTransaction)
	}

	// Start Pruning Task (Background)
	go func() {
		ticker := time.NewTicker(2 * time.Minute)
		for range ticker.C {
			query := "UPDATE nodes SET is_online = 0 WHERE last_seen < datetime('now', '-5 minutes') AND is_online = 1"
			res, err := db.Exec(query)
			if err != nil {
				log.Error().Err(err).Msg("failed to prune offline nodes")
				continue
			}
			count, _ := res.RowsAffected()
			if count > 0 {
				log.Info().Int64("count", count).Msg("pruned offline nodes")
			}
		}
	}()

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
