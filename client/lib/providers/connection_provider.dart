import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/vpn_state.dart';
import '../models/vpn_node.dart';
import '../services/tunnel_service.dart';
import 'api_provider.dart';

part 'connection_provider.g.dart';

@riverpod
class ConnectionNotifier extends _$ConnectionNotifier {
  final TunnelService _tunnelService = TunnelService();

  @override
  VpnState build() => const Disconnected();

  Future<void> connect({VpnNode? preferred}) async {
    try {
      VpnNode node;
      if (preferred != null) {
        node = preferred;
      } else {
        final nodeData = await ref.read(apiClientProvider).getBestNode();
        node = VpnNode.fromJson(nodeData);
      }

      state = Connecting(node);

      // In production, generate this securely via WireGuard dart package or native code
      final clientPrivateKey = _generateWireGuardPrivateKey();

      // 2. Start Native Tunnel
      final bool success = await _tunnelService.startVpn(
        clientPrivateKey: clientPrivateKey,
        serverPublicKey: node.publicKey,
        endpoint: node.endpoint,
        localAddress: '10.0.0.2',
      );

      if (success) {
        state = Connected(nodeId: node.city, since: DateTime.now());
      } else {
        state = const VpnError("Failed to establish tunnel");
      }
    } catch (e) {
      state = VpnError(e.toString());
    }
  }

  Future<void> disconnect() async {
    await _tunnelService.stopVpn();
    state = const Disconnected();
  }

  String _generateWireGuardPrivateKey() {
    // Note: In a real production app, use a dedicated crypto library
    // or native WireGuard bridge to generate secure Curve25519 keys.
    // This is a placeholder for the logic.
    return "GENERATED_KEY_PLACEHOLDER";
  }
}
