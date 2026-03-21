import 'package:flutter/material.dart';

class NodesScreen extends StatelessWidget {
  const NodesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Nodes'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return const _NodeCard(
            city: 'Bangalore',
            countryCode: 'IN',
            latency: 45,
            bandwidth: 120,
            isOnline: true,
          );
        },
      ),
    );
  }
}

class _NodeCard extends StatelessWidget {
  final String city;
  final String countryCode;
  final int latency;
  final int bandwidth;
  final bool isOnline;

  const _NodeCard({
    required this.city,
    required this.countryCode,
    required this.latency,
    required this.bandwidth,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOnline ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$city, $countryCode',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${latency}ms • ${bandwidth}Mbps',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'JetBrains Mono',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton.tonal(
              onPressed: () {},
              child: const Text('Connect'),
            ),
          ],
        ),
      ),
    );
  }
}
