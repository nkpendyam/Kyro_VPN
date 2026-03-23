package xray

import (
	"encoding/json"
	"fmt"
	"os"
	"os/exec"

	"github.com/google/uuid"
	"github.com/rs/zerolog/log"
)

type RealityConfig struct {
	UUID        string
	PrivateKey  string
	PublicKey   string
	ShortID     string
	DestDomain  string
	ListenPort  int
}

// GenerateConfig generates a basic XTLS-Reality configuration for Xray-core
func GenerateConfig(port int, destDomain string) (RealityConfig, error) {
	// In production, we use Xray's key generation commands.
	// For this daemon, we simulate it with UUIDs.
	id := uuid.New().String()
	
	cfg := RealityConfig{
		UUID:       id,
		DestDomain: destDomain,
		ListenPort: port,
		// Mock keys for demonstration
		PrivateKey: "private-key-generated-by-xray-x25519",
		PublicKey:  "public-key-for-reality",
		ShortID:    "0123456789abcdef",
	}

	log.Info().Str("domain", destDomain).Int("port", port).Msg("Generated Xray XTLS-Reality configuration")
	return cfg, nil
}

func WriteConfig(path string, cfg RealityConfig) error {
	// A minimal XTLS-Reality JSON
	rawJSON := map[string]interface{}{
		"inbounds": []map[string]interface{}{
			{
				"listen": "0.0.0.0",
				"port":   cfg.ListenPort,
				"protocol": "vless",
				"settings": map[string]interface{}{
					"clients": []map[string]interface{}{
						{"id": cfg.UUID, "flow": "xtls-rprx-vision"},
					},
					"decryption": "none",
				},
				"streamSettings": map[string]interface{}{
					"network": "tcp",
					"security": "reality",
					"realitySettings": map[string]interface{}{
						"dest": cfg.DestDomain + ":443",
						"serverNames": []string{cfg.DestDomain},
						"privateKey": cfg.PrivateKey,
						"shortIds": []string{cfg.ShortID},
					},
				},
			},
		},
		"outbounds": []map[string]interface{}{
			{"protocol": "freedom"},
		},
	}

	data, err := json.MarshalIndent(rawJSON, "", "  ")
	if err != nil {
		return err
	}

	return os.WriteFile(path, data, 0600)
}

func StartXray(configPath string) (*exec.Cmd, error) {
	cmd := exec.Command("xray", "run", "-c", configPath)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	
	if err := cmd.Start(); err != nil {
		return nil, fmt.Errorf("failed to start Xray: %w", err)
	}
	
	log.Info().Str("config", configPath).Msg("Xray-core started")
	return cmd, nil
}
