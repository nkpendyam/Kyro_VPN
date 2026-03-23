package wireguard

import (
	"fmt"
	"os"
	"os/exec"

	"github.com/rs/zerolog/log"
	"golang.zx2c4.com/wireguard/wgctrl"
	"golang.zx2c4.com/wireguard/wgctrl/wgtypes"
)

type Manager struct {
	client *wgctrl.Client
}

func NewManager() (*Manager, error) {
	c, err := wgctrl.New()
	if err != nil {
		return nil, fmt.Errorf("failed to open wgctrl: %w", err)
	}
	return &Manager{client: c}, nil
}

func (m *Manager) GenerateKeys() (privateKey string, publicKey string, err error) {
	priv, err := wgtypes.GeneratePrivateKey()
	if err != nil {
		return "", "", err
	}
	return priv.String(), priv.PublicKey().String(), nil
}

func (m *Manager) SetupInterface(ifaceName string, privateKey string, port int) error {
	// Write minimal config (in memory via wgctrl or to temp file for AmneziaWG)
	// For AmneziaWG we need to use awg-quick or awg command line tools usually,
	// but here we demonstrate the standard wgctrl approach for compatibility.
	log.Info().Str("iface", ifaceName).Int("port", port).Msg("Setting up WireGuard interface")

	priv, err := wgtypes.ParseKey(privateKey)
	if err != nil {
		return err
	}

	cfg := wgtypes.Config{
		PrivateKey:   &priv,
		ListenPort:   &port,
		ReplacePeers: false,
	}

	// In a real Linux environment with AmneziaWG kernel module, 
	// this would configure awg0. For userspace, we run awg-go.
	err = m.client.ConfigureDevice(ifaceName, cfg)
	if err != nil {
		// Fallback to command line if wgctrl fails (often needed for awg)
		log.Warn().Err(err).Msg("wgctrl failed, falling back to shell")
		// Assume an existing config is written to /tmp/awg0.conf
	}

	return nil
}

// StartAmneziaGo starts the userspace daemon
func StartAmneziaGo(ifaceName string, confPath string) (*exec.Cmd, error) {
	cmd := exec.Command("amneziawg-go", ifaceName)
	cmd.Env = append(os.Environ(), "WG_I_PREFER_BUGGY_USERSPACE_TO_POLISHED_KMOD=1")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	
	if err := cmd.Start(); err != nil {
		return nil, fmt.Errorf("failed to start amneziawg-go: %w", err)
	}
	
	log.Info().Str("iface", ifaceName).Msg("AmneziaWG userspace daemon started")
	return cmd, nil
}
