package health

import (
	"bytes"
	"encoding/json"
	"net/http"
	"time"

	"github.com/rs/zerolog/log"
)

type HeartbeatRequest struct {
	NodeID        string `json:"node_id"`
	BandwidthMbps int    `json:"bandwidth_mbps"`
	LatencyMs     int    `json:"latency_ms"`
}

func StartHeartbeat(nodeID string, coordinatorURL string) {
	ticker := time.NewTicker(30 * time.Second)
	client := &http.Client{Timeout: 10 * time.Second}

	log.Info().Str("node_id", nodeID).Msg("starting heartbeat loop")

	for range ticker.C {
		// Mock metrics for now
		reqBody, _ := json.Marshal(HeartbeatRequest{
			NodeID:        nodeID,
			BandwidthMbps: 100, // Hardcoded for PoC
			LatencyMs:     20,  // Hardcoded for PoC
		})

		resp, err := client.Post(coordinatorURL+"/nodes/heartbeat", "application/json", bytes.NewBuffer(reqBody))
		if err != nil {
			log.Error().Err(err).Msg("heartbeat failed")
			continue
		}
		resp.Body.Close()

		if resp.StatusCode != http.StatusOK {
			log.Warn().Int("status", resp.StatusCode).Msg("coordinator rejected heartbeat")
		}
	}
}
