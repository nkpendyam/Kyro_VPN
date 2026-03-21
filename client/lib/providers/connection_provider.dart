import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/vpn_state.dart';

part 'connection_provider.g.dart';

@riverpod
class ConnectionNotifier extends _$ConnectionNotifier {
  @override
  VpnState build() => const Disconnected();

  Future<void> connect(String nodeId) async {
    state = const Connecting();
    try {
      // TODO: Implement tunnel startup logic via Amnezia core
      await Future.delayed(const Duration(seconds: 2));
      state = Connected(nodeId: nodeId, since: DateTime.now());
    } catch (e) {
      state = VpnError(e.toString());
    }
  }

  Future<void> disconnect() async {
    // TODO: Implement tunnel shutdown logic
    state = const Disconnected();
  }
}
