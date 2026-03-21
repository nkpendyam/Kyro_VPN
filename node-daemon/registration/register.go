package registration

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"time"

	"github.com/rs/zerolog/log"
	"golang.zx2c4.com/wireguard/wgctrl/wgtypes"
)

type Config struct {
	CoordinatorURL string
	PlayitAddress  string
	City           string
	CountryCode    string
}

type RegisterRequest struct {
	PublicKey     string `json:"public_key"`
	PlayitAddress string `json:"playit_address"`
	City           string `json:"city"`
	CountryCode   string `json:"country_code"`
}

type RegisterResponse struct {
	NodeID string `json:"node_id"`
	Status string `json:"status"`
}

func Register(cfg Config) (string, string, error) {
	// 1. Generate WireGuard Keys
	priv, err := wgtypes.GeneratePrivateKey()
	if err != nil {
		return "", "", fmt.Errorf("generate key: %w", err)
	}
	pub := priv.PublicKey().String()

	// 2. Prepare Request
	reqBody, _ := json.Marshal(RegisterRequest{
		PublicKey:     pub,
		PlayitAddress: cfg.PlayitAddress,
		City:           cfg.City,
		CountryCode:   cfg.CountryCode,
	})

	// 3. Send to Coordinator
	client := &http.Client{Timeout: 10 * time.Second}
	resp, err := client.Post(cfg.CoordinatorURL+"/nodes/register", "application/json", bytes.NewBuffer(reqBody))
	if err != nil {
		return "", "", fmt.Errorf("request failed: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return "", "", fmt.Errorf("server returned %d", resp.StatusCode)
	}

	var res RegisterResponse
	if err := json.NewDecoder(resp.Body).Decode(&res); err != nil {
		return "", "", fmt.Errorf("decode response: %w", err)
	}

	log.Info().Str("node_id", res.NodeID).Msg("node registered successfully")
	return res.NodeID, priv.String(), nil
}
