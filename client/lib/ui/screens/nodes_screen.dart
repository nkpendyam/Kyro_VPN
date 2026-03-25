import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/node_provider.dart';
import '../../models/vpn_node.dart';

class NodesScreen extends ConsumerWidget {
  const NodesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nodesAsync = ref.watch(nodeListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.read(nodeListProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              title: const Text('Global Network'),
              centerTitle: false,
            ),
            nodesAsync.when(
              data: (nodes) => SliverPadding(
                padding: .all(16),
                sliver: nodes.isEmpty 
                  ? const SliverFillRemaining(
                      child: Center(child: Text('No nodes available')),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final node = nodes[index];
                          return _NodeCard(
                            node: node,
                            isOnline: true,
                          );
                        },
                        childCount: nodes.length,
                      ),
                    ),
              ),
              loading: () => SliverPadding(
                padding: .all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _LoadingCard(),
                    childCount: 5,
                  ),
                ),
              ),
              error: (err, stack) => SliverFillRemaining(
                child: Center(child: Text('Error: \$err')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NodeCard extends StatelessWidget {
  final VpnNode node;
  final bool isOnline;

  const _NodeCard({
    required this.node,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: .only(bottom: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            ref.read(connectionProvider.notifier).connect(preferred: node);
            // Optionally navigate back to home screen
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          child: Padding(
            padding: .all(20),
            child: Row(
              children: [
                _buildStatusIndicator(colorScheme),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\${node.city}, \${node.countryCode}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.speed,
                            size: 14,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '\${node.bandwidth}Mbps',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontFamily: 'JetBrains Mono',
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.network_check,
                            size: 14,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '\${node.latency}ms',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontFamily: 'JetBrains Mono',
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: colorScheme.outline,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(ColorScheme colorScheme) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: (isOnline ? Colors.green : Colors.red).withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: isOnline ? Colors.green : Colors.red,
            shape: BoxShape.circle,
            boxShadow: [
              if (isOnline)
                BoxShadow(
                  color: Colors.green.withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 88,
      margin: .only(bottom: 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
      ),
    );
  }
}
