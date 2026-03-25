import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/vpn_node.dart';
import 'api_provider.dart';

part 'node_provider.g.dart';

@riverpod
class NodeList extends _$NodeList {
  @override
  Future<List<VpnNode>> build() async {
    final data = await ref.read(apiClientProvider).fetchNodes();
    return data.map((e) => VpnNode.fromJson(e)).toList();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final data = await ref.read(apiClientProvider).fetchNodes();
      return data.map((e) => VpnNode.fromJson(e)).toList();
    });
  }
}
