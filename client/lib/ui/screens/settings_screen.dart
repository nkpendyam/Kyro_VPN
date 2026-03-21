import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text('Protocol'),
            subtitle: Text('AmneziaWG + XTLS-Reality'),
            leading: Icon(Icons.security),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Kill Switch'),
            subtitle: const Text('Block internet if VPN drops'),
            value: true,
            onChanged: (val) {},
            secondary: const Icon(Icons.block),
          ),
          SwitchListTile(
            title: const Text('Connect on Boot'),
            value: false,
            onChanged: (val) {},
            secondary: const Icon(Icons.power_settings_new),
          ),
        ],
      ),
    );
  }
}
