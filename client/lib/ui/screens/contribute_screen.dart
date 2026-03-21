import 'package:flutter/material.dart';

class ContributeScreen extends StatelessWidget {
  const ContributeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Host a Node'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.volunteer_activism, size: 64),
            const SizedBox(height: 24),
            const Text(
              'Earn Credits by Sharing Bandwidth',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Run the Kyro daemon on your computer to provide a decentralized VPN node for others, earning credits to use premium nodes yourself.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text('Your Balance', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Text('0', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                    Text('Credits', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {},
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Get Setup Instructions'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
