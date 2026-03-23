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

  Future<void> connect() async {
    state = const Connecting();
    try {
      // 1. Fetch Best Node from Coordinator
      final nodeData = await ref.read(apiClientProvider).getBestNode();
      final node = VpnNode.fromJson(nodeData);

      // In production, generate this securely via WireGuard dart package or native code
      final tempClientPrivKey = "mH2Z+...=";

      // 2. Start Native Tunnel
      final bool success = await _tunnelService.startVpn(
        clientPrivateKey: tempClientPrivKey,
        serverPublicKey: node.publicKey,
        endpoint: node.endpoint,
        localAddress: '10.0.0.2',
      );

      if (success) {
        state = Connected(nodeId: node.city, since: DateTime.now());
      } else {
        // If false, it might mean permissions are pending on Android
        // We'll just stay in Connecting state or show a message
      }
    } catch (e) {
      state = VpnError(e.toString());
    }
  }

  Future<void> disconnect() async {
    await _tunnelService.stopVpn();
    state = const Disconnected();
  }
}
