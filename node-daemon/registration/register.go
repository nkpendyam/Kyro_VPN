package registration

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"time"
)

type Config struct {
	CoordinatorURL string
	PlayitAddress  string
	City           string
	CountryCode    string
	PublicKey      string
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
	// 1. Prepare Request
	reqBody, _ := json.Marshal(RegisterRequest{
		PublicKey:     cfg.PublicKey,
		PlayitAddress: cfg.PlayitAddress,
		City:           cfg.City,
		CountryCode:   cfg.CountryCode,
	})

	// 2. Send to Coordinator
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

	return res.NodeID, "ok", nil
}
