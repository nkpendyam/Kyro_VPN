import 'dart:io';

import 'package:flutter/services.dart';

class AmneziaCore {
  static const MethodChannel _channel = MethodChannel('com.kyrovpn/vpn');

  /// Generates an AmneziaWG configuration based on backend parameters
  static String generateConfig({
    required String privateKey,
    required String serverPublicKey,
    required String endpoint,
    required String localAddress,
  }) {
    // 21st.dev style strict configuration
    return '''[Interface]
PrivateKey = $privateKey
Address = $localAddress
DNS = 1.1.1.1, 1.0.0.1
Jc = 4
Jmin = 40
Jmax = 70
S1 = 15
S2 = 25
H1 = 1
H2 = 2
H3 = 3
H4 = 4

[Peer]
PublicKey = $serverPublicKey
Endpoint = $endpoint
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
''';
  }

  /// Starts the VPN tunnel by passing the config to native code
  static Future<bool> startTunnel(String config) async {
    // SECURITY: The config file is written to a temporary location
    // read by the native Android/iOS VpnService, and immediately deleted.
    try {
      final configFile = File('\${Directory.systemTemp.path}/kyro-wg0.conf');
      await configFile.writeAsString(config);

      final result = await _channel.invokeMethod('startVpnWithConfig', {
        'configPath': configFile.path,
      });

      // Cleanup immediately
      if (await configFile.exists()) {
        await configFile.delete();
      }

      return result ?? false;
    } catch (e) {
      return false;
    }
  }
}
