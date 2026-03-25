import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/connection_provider.dart';
import '../../models/vpn_state.dart';
import '../widgets/shield_animation.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnState = ref.watch(connectionProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: .all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              ShieldAnimation(state: vpnState),
              const SizedBox(height: 48),
              _buildStatusText(context, vpnState),
              const SizedBox(height: 16),
              if (vpnState is Connected)
                _buildConnectionDetails(context, vpnState),
              const Spacer(),
              _buildConnectButton(context, ref, vpnState),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusText(BuildContext context, VpnState state) {
    final theme = Theme.of(context);
    String text;
    
    switch (state) {
      case Connected():
        text = 'SECURED';
      case Connecting():
        text = 'PROTECTING...';
      case VpnError():
        text = 'CONNECTION FAILED';
      case Disconnected():
        text = 'NOT PROTECTED';
    }

    return Column(
      children: [
        Text(
          text,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: state is Connected 
                ? theme.colorScheme.primary 
                : theme.colorScheme.onSurface,
          ),
        ),
        if (state is Connected)
          Padding(
            padding: .only(top: 8),
            child: Text(
              'Your traffic is now encrypted',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildConnectionDetails(BuildContext context, Connected state) {
    final theme = Theme.of(context);
    return Container(
      padding: .symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            state.nodeId,
            style: theme.textTheme.labelLarge?.copyWith(
              fontFamily: 'JetBrains Mono',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectButton(BuildContext context, WidgetRef ref, VpnState state) {
    final theme = Theme.of(context);
    final bool isDisconnected = state is Disconnected || state is VpnError;
    final bool isConnecting = state is Connecting;

    return SizedBox(
      width: double.infinity,
      height: 64,
      child: FilledButton(
        onPressed: isConnecting 
            ? null 
            : () {
                if (isDisconnected) {
                  ref.read(connectionProvider.notifier).connect();
                } else {
                  ref.read(connectionProvider.notifier).disconnect();
                }
              },
        style: FilledButton.styleFrom(
          backgroundColor: isDisconnected 
              ? theme.colorScheme.primary 
              : theme.colorScheme.errorContainer,
          foregroundColor: isDisconnected 
              ? theme.colorScheme.onPrimary 
              : theme.colorScheme.onErrorContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isConnecting
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 3),
              )
            : Text(
                isDisconnected ? 'CONNECT' : 'DISCONNECT',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
      ),
    );
  }
}
