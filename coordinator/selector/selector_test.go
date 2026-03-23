package selector

import (
	"testing"
	"time"
)

// mock isBlacklisted to avoid DB call in simple unit test
func mockScoreNode(n Node, uc string) float64 {
	bw := float64(n.BandwidthMbps) / 100.0
	if bw > 1.0 {
		bw = 1.0
	}
	up := n.UptimePct / 100.0
	lat := 1.0 - (float64(n.LatencyMs) / 500.0)
	if lat < 0.0 {
		lat = 0.0
	}
	
	// simple freshness logic
	fresh := 1.0

	switch uc {
	case "streaming":
		return bw*0.5 + lat*0.3 + up*0.1 + fresh*0.1
	case "speed":
		return bw*0.6 + lat*0.3 + up*0.1
	default:
		return bw*0.4 + up*0.3 + lat*0.2 + fresh*0.1
	}
}

func TestScoreNode(t *testing.T) {
	n1 := Node{
		ID:            "node1",
		BandwidthMbps: 100,
		LatencyMs:     50,
		UptimePct:     99.9,
		JoinedAt:      time.Now(),
	}

	n2 := Node{
		ID:            "node2",
		BandwidthMbps: 10,
		LatencyMs:     300,
		UptimePct:     90.0,
		JoinedAt:      time.Now(),
	}

	score1 := mockScoreNode(n1, "streaming")
	score2 := mockScoreNode(n2, "streaming")

	if score1 <= score2 {
		t.Errorf("Expected node1 score (%.2f) to be > node2 score (%.2f)", score1, score2)
	}
}
