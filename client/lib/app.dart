import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'ui/theme/kyro_theme.dart';
import 'ui/shell.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/nodes_screen.dart';
import 'ui/screens/contribute_screen.dart';
import 'ui/screens/settings_screen.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => KyroShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/nodes',
          builder: (context, state) => const NodesScreen(),
        ),
        GoRoute(
          path: '/contribute',
          builder: (context, state) => const ContributeScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
  ],
);

class KyroApp extends StatelessWidget {
  const KyroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Kyro VPN',
      debugShowCheckedModeBanner: false,
      theme: KyroTheme.light,
      darkTheme: KyroTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: goRouter,
    );
  }
}
