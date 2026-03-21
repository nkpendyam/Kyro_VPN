import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/vpn_state.dart';
import '../models/vpn_node.dart';
import 'api_provider.dart';

part 'connection_provider.g.dart';

@riverpod
class ConnectionNotifier extends _$ConnectionNotifier {
  @override
  VpnState build() => const Disconnected();

  Future<void> connect() async {
    state = const Connecting();
    try {
      // 1. Fetch Best Node from Coordinator
      final nodeData = await ref.read(apiClientProvider).getBestNode();
      final node = VpnNode.fromJson(nodeData);

      // 2. Placeholder for Tunnel Logic
      // Actual Amnezia core call will be added in Phase 8 (Platform Integration)
      await Future.delayed(const Duration(seconds: 2));

      state = Connected(nodeId: node.city, since: DateTime.now());
    } catch (e) {
      state = VpnError(e.toString());
    }
  }

  Future<void> disconnect() async {
    state = const Disconnected();
  }
}
