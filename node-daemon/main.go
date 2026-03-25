package main

import (
	"context"
	"flag"
	"os"
	"os/signal"
	"syscall"

	"github.com/nkpendyam/Kyro_VPN/node-daemon/bandwidth"
	"github.com/nkpendyam/Kyro_VPN/node-daemon/health"
	"github.com/nkpendyam/Kyro_VPN/node-daemon/registration"
	"github.com/nkpendyam/Kyro_VPN/node-daemon/wireguard"
	"github.com/nkpendyam/Kyro_VPN/node-daemon/xray"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

func main() {
	// 1. Setup logger
	zerolog.TimeFieldFormat = zerolog.TimeFormatUnix
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stderr})

	// 2. Flags
	coordinator := flag.String("coordinator", "https://kyrovpn.is-a.dev", "Coordinator API URL")
	endpoint := flag.String("endpoint", "", "Public tunnel endpoint (e.g. yourname.portmap.io:12345)")
	city := flag.String("city", "Unknown", "Node city")
	country := flag.String("country", "??", "Node country code")
	iface := flag.String("iface", "awg0", "WireGuard interface name")
	wgPort := flag.Int("wg-port", 51820, "WireGuard listen port")
	xrayPort := flag.Int("xray-port", 443, "Xray listen port")
	flag.Parse()

	if *endpoint == "" {
		log.Fatal().Msg("Endpoint is required. Use --endpoint flag (e.g. from Portmap.io).")
	}

	// 3. Setup Services
	wgManager, err := wireguard.NewManager()
	if err != nil {
		log.Fatal().Err(err).Msg("failed to initialize wireguard manager")
	}

	privKey, pubKey, err := wgManager.GenerateKeys()
	if err != nil {
		log.Fatal().Err(err).Msg("failed to generate wireguard keys")
	}

	// 4. Register Node
	cfg := registration.Config{
		CoordinatorURL: *coordinator,
		PlayitAddress:  *endpoint,
		City:           *city,
		CountryCode:    *country,
		PublicKey:      pubKey, // Ensure registration uses our generated key
	}

	nodeID, _, err := registration.Register(cfg)
	if err != nil {
		log.Fatal().Err(err).Msg("failed to register node")
	}

	log.Info().Str("node_id", nodeID).Msg("Node registered successfully")

	// 5. Start WireGuard & Xray
	err = wgManager.SetupInterface(*iface, privKey, *wgPort)
	if err != nil {
		log.Error().Err(err).Msg("failed to setup wireguard interface (continuing...)")
	}

	xrayCfg, err := xray.GenerateConfig(*xrayPort, "apple.com")
	if err != nil {
		log.Fatal().Err(err).Msg("failed to generate xray config")
	}

	err = xray.WriteConfig("xray_config.json", xrayCfg)
	if err != nil {
		log.Fatal().Err(err).Msg("failed to write xray config")
	}

	xrayCmd, err := xray.StartXray("xray_config.json")
	if err != nil {
		log.Error().Err(err).Msg("failed to start xray-core")
	} else {
		defer xrayCmd.Process.Kill()
	}

	// 6. Start Monitoring (Background)
	go health.StartHeartbeat(nodeID, *coordinator)

	monitor, err := bandwidth.NewMonitor(*iface, *coordinator)
	if err == nil {
		go monitor.Start(context.Background())
	}

	// 7. Wait for Signal
	log.Info().Msg("Kyro Node Daemon is running. Press Ctrl+C to stop.")
	stop := make(chan os.Signal, 1)
	signal.Notify(stop, syscall.SIGINT, syscall.SIGTERM)
	<-stop

	log.Info().Msg("Shutting down node...")
}
