import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/connection_provider.dart';
import '../../models/vpn_state.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnState = ref.watch(connectionProvider);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStatusIcon(vpnState),
            const SizedBox(height: 32),
            _buildStatusText(vpnState),
            const SizedBox(height: 48),
            _buildConnectButton(context, ref, vpnState),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon(VpnState state) {
    Color color;
    IconData icon;
    switch (state) {
      case Connected():
        color = Colors.green;
        icon = Icons.shield;
      case Connecting():
        color = Colors.orange;
        icon = Icons.shield_outlined;
      case VpnError():
        color = Colors.red;
        icon = Icons.error_outline;
      case Disconnected():
        color = Colors.grey;
        icon = Icons.shield_outlined;
    }

    return Icon(icon, size: 120, color: color);
  }

  Widget _buildStatusText(VpnState state) {
    String text;
    switch (state) {
      case Connected(:final nodeId):
        text = 'Connected to $nodeId';
      case Connecting():
        text = 'Connecting...';
      case VpnError(:final message):
        text = 'Error: $message';
      case Disconnected():
        text = 'Disconnected';
    }
    return Text(
      text,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildConnectButton(BuildContext context, WidgetRef ref, VpnState state) {
    final bool isDisconnected = state is Disconnected || state is VpnError;
    
    return FilledButton.tonal(
      onPressed: state is Connecting 
          ? null 
          : () {
              if (isDisconnected) {
                ref.read(connectionProvider.notifier).connect();
              } else {
                ref.read(connectionProvider.notifier).disconnect();
              }
            },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Text(isDisconnected ? 'CONNECT' : 'DISCONNECT'),
      ),
    );
  }
}
