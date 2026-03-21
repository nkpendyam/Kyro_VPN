package main

import (
	"flag"
	"os"
	"os/signal"
	"syscall"

	"github.com/nkpendyam/Kyro_VPN/node-daemon/health"
	"github.com/nkpendyam/Kyro_VPN/node-daemon/registration"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

func main() {
	// 1. Setup logger
	zerolog.TimeFieldFormat = zerolog.TimeFormatUnix
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stderr})

	// 2. Flags
	coordinator := flag.String("coordinator", "http://localhost:8080", "Coordinator API URL")
	endpoint := flag.String("endpoint", "", "Public tunnel endpoint (e.g. yourname.portmap.io:12345)")
	city := flag.String("city", "Unknown", "Node city")
	country := flag.String("country", "??", "Node country code")
	flag.Parse()

	if *endpoint == "" {
		log.Fatal().Msg("Endpoint is required. Use --endpoint flag (e.g. from Portmap.io).")
	}

	// 3. Register Node
	cfg := registration.Config{
		CoordinatorURL: *coordinator,
		PlayitAddress:  *endpoint,
		City:           *city,
		CountryCode:    *country,
	}

	nodeID, privateKey, err := registration.Register(cfg)
	if err != nil {
		log.Fatal().Err(err).Msg("failed to register node")
	}

	log.Info().Str("node_id", nodeID).Msg("Node registered successfully")
	log.Info().Str("private_key", privateKey).Msg("IMPORTANT: Secure this private key")

	// 4. Start Heartbeat (Background)
	go health.StartHeartbeat(nodeID, *coordinator)

	// 5. Wait for Signal
	log.Info().Msg("Kyro Node Daemon is running. Press Ctrl+C to stop.")
	stop := make(chan os.Signal, 1)
	signal.Notify(stop, syscall.SIGINT, syscall.SIGTERM)
	<-stop

	log.Info().Msg("Shutting down node...")
}
