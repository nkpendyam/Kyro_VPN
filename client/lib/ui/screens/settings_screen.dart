import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(
            title: Text('Settings'),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildSectionHeader(context, 'SECURITY'),
              _buildSwitchTile(
                context,
                title: 'Kill switch',
                subtitle: 'Block internet if VPN disconnects',
                value: settings.killSwitch,
                onChanged: (val) => ref.read(settingsProvider.notifier).setKillSwitch(val),
              ),
              _buildSwitchTile(
                context,
                title: 'DNS leak protection',
                subtitle: 'Always use Kyro DNS',
                value: settings.dnsLeakProtection,
                onChanged: (val) => ref.read(settingsProvider.notifier).setDnsLeakProtection(val),
              ),
              _buildSwitchTile(
                context,
                title: 'Block IPv6',
                subtitle: 'Prevent IP leaks over IPv6',
                value: settings.blockIpv6,
                onChanged: (val) => ref.read(settingsProvider.notifier).setBlockIpv6(val),
              ),
              const SizedBox(height: 16),
              _buildSectionHeader(context, 'NETWORK'),
              _buildActionTile(
                context,
                title: 'Split tunneling',
                trailing: 'OFF',
              ),
              _buildActionTile(
                context,
                title: 'Protocol',
                trailing: settings.protocol,
              ),
              _buildActionTile(
                context,
                title: 'DNS server',
                trailing: settings.dnsServer,
              ),
              const SizedBox(height: 16),
              _buildSectionHeader(context, 'APPEARANCE'),
              Padding(
                padding: .symmetric(horizontal: 24, vertical: 8),
                child: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'System', label: Text('System')),
                    ButtonSegment(value: 'Light', label: Text('Light')),
                    ButtonSegment(value: 'Dark', label: Text('Dark')),
                  ],
                  selected: {settings.themeMode},
                  onSelectionChanged: (newSelection) {
                    ref.read(settingsProvider.notifier).setThemeMode(newSelection.first);
                  },
                ),
              ),
              const SizedBox(height: 16),
              _buildSectionHeader(context, 'ABOUT'),
              _buildActionTile(
                context,
                title: 'Version',
                trailing: 'v0.1.0',
              ),
              _buildActionTile(
                context,
                title: 'View source code',
                onTap: () {},
              ),
              _buildActionTile(
                context,
                title: 'Privacy policy',
                onTap: () {},
              ),
              const SizedBox(height: 48),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: .fromLTRB(24, 24, 24, 8),
      child: Text(
        title,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      contentPadding: .symmetric(horizontal: 24, vertical: 4),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildActionTile(BuildContext context, {
    required String title,
    String? trailing,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: .symmetric(horizontal: 24, vertical: 4),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(
              trailing,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontFamily: 'JetBrains Mono',
              ),
            ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, size: 20),
        ],
      ),
      onTap: onTap ?? () {},
    );
  }
}
