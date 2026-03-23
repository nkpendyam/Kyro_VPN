package vpnconfig

import (
	"bytes"
	"fmt"
	"text/template"
)

// ConfigParams holds the data needed to generate an AmneziaWG config
type ConfigParams struct {
	ClientPrivateKey string
	ClientAddress    string
	ServerPublicKey  string
	ServerEndpoint   string // e.g. address.portmap.io:12345
	Jc               int
	Jmin             int
	Jmax             int
	S1               int
	S2               int
	H1               int
	H2               int
	H3               int
	H4               int
}

const amneziawgTemplate = `[Interface]
PrivateKey = {{.ClientPrivateKey}}
Address = {{.ClientAddress}}
DNS = 1.1.1.1, 1.0.0.1
Jc = {{.Jc}}
Jmin = {{.Jmin}}
Jmax = {{.Jmax}}
S1 = {{.S1}}
S2 = {{.S2}}
H1 = {{.H1}}
H2 = {{.H2}}
H3 = {{.H3}}
H4 = {{.H4}}

[Peer]
PublicKey = {{.ServerPublicKey}}
Endpoint = {{.ServerEndpoint}}
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
`

// Generate generates a standard AmneziaWG configuration string
func Generate(params ConfigParams) (string, error) {
	// Set default obfuscation parameters if not provided
	if params.Jc == 0 {
		params.Jc = 4
		params.Jmin = 40
		params.Jmax = 70
		params.S1 = 15
		params.S2 = 25
		params.H1 = 1
		params.H2 = 2
		params.H3 = 3
		params.H4 = 4
	}

	tmpl, err := template.New("amneziawg").Parse(amneziawgTemplate)
	if err != nil {
		return "", fmt.Errorf("failed to parse template: %w", err)
	}

	var buf bytes.Buffer
	if err := tmpl.Execute(&buf, params); err != nil {
		return "", fmt.Errorf("failed to execute template: %w", err)
	}

	return buf.String(), nil
}
