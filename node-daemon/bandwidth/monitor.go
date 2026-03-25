package bandwidth

import (
	"context"
	"time"

	"github.com/rs/zerolog/log"
	"golang.zx2c4.com/wireguard/wgctrl"
)

type Monitor struct {
	client      *wgctrl.Client
	ifaceName   string
	lastBytes   int64
	coordinator string
}

func NewMonitor(ifaceName string, coordinator string) (*Monitor, error) {
	c, err := wgctrl.New()
	if err != nil {
		return nil, err
	}
	return &Monitor{
		client:      c,
		ifaceName:   ifaceName,
		coordinator: coordinator,
	}, nil
}

func (m *Monitor) Start(ctx context.Context) {
	ticker := time.NewTicker(1 * time.Minute)
	defer ticker.Stop()

	log.Info().Str("iface", m.ifaceName).Msg("Bandwidth monitor started")

	for {
		select {
		case <-ctx.Done():
			return
		case <-ticker.C:
			m.check(ctx)
		}
	}
}

func (m *Monitor) check(ctx context.Context) {
	dev, err := m.client.Device(m.ifaceName)
	if err != nil {
		// Device might not be up yet
		return
	}

	var totalBytes int64
	for _, peer := range dev.Peers {
		totalBytes += peer.ReceiveBytes + peer.TransmitBytes
	}

	if m.lastBytes == 0 {
		m.lastBytes = totalBytes
		return
	}

	delta := totalBytes - m.lastBytes
	if delta > 0 {
		mb := delta / (1024 * 1024)
		log.Debug().Int64("delta_mb", mb).Msg("Bandwidth recorded")
		
		// In a real implementation, we would send this to the coordinator
		// to credit the node owner.
		// m.reportToCoordinator(ctx, delta)
		
		m.lastBytes = totalBytes
	}
}

func (m *Monitor) reportToCoordinator(ctx context.Context, bytes int64) error {
	// TODO: POST /nodes/bandwidth with signed report
	return nil
}
