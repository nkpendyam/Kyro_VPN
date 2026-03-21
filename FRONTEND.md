# FRONTEND.md — Kyro VPN Flutter App
## Complete Frontend Specification

---

## Design system: M3 Expressive + 21st.dev patterns

### Google Stitch (Material Design 3 Expressive) — 2026
Google Stitch is the internal name for Material Design 3 Expressive.
It's the latest evolution of M3 with expressive motion, dynamic color, and adaptive layouts.

Key 2026 M3 Expressive features:
- **Expressive motion tokens** — `Easing.emphasizedDecelerate`, `Durations.long4`
- **Dynamic color** — `ColorScheme.fromSeed()` adapts to wallpaper on Android 12+
- **Shape expressiveness** — more dramatic shape changes between states
- **Typography expressiveness** — `displayLarge` for hero numbers, `labelSmall` for chips

### 21st.dev patterns for Flutter
21st.dev is a modern component pattern library. For Flutter we apply:
- **Generous whitespace** — minimum 24dp padding on screen edges
- **Subtle borders** — `Border.all(width: 0.5, color: colorScheme.outlineVariant)`
- **Clean cards** — no elevation shadows, border instead
- **Monospace for technical** — `fontFamily: 'JetBrains Mono'` for IPs, latency, keys
- **Status dots not text** — colored circle indicator, not "Connected" text
- **Progressive disclosure** — show simple, expand to detail on tap
- **Skeleton loading** — `Shimmer` effect while nodes load, not spinners

---

## Theme setup

```dart
// lib/ui/theme/kyro_colors.dart
abstract class KyroColors {
  static const seedColor = Color(0xFF5B21B6);  // deep violet

  // Status — hardcoded (not from theme, intentional)
  static const connected    = Color(0xFF10B981);
  static const connecting   = Color(0xFFF59E0B);
  static const disconnected = Color(0xFF6B7280);
  static const error        = Color(0xFFEF4444);

  // Latency tiers
  static const fast   = Color(0xFF10B981);  // < 50ms
  static const medium = Color(0xFFF59E0B);  // 50-150ms
  static const slow   = Color(0xFFEF4444);  // > 150ms
}

// lib/ui/theme/kyro_theme.dart
ThemeData kyroLight() => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: KyroColors.seedColor,
    brightness: Brightness.light,
  ),
  cardTheme: CardTheme(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(width: 0.5,
        color: ThemeData().colorScheme.outlineVariant),
    ),
  ),
  // 21st.dev: generous padding, clean typography
  textTheme: GoogleFonts.interTextTheme(),
);

ThemeData kyroDark() => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: KyroColors.seedColor,
    brightness: Brightness.dark,
  ),
  cardTheme: CardTheme(elevation: 0),
);
```

---

## pubspec.yaml — all dependencies

```yaml
name: kyro_vpn
description: Open source VPN — privacy, streaming, zero logs
version: 0.1.0+1
publish_to: 'none'

environment:
  sdk: '>=3.10.0 <4.0.0'
  flutter: '>=3.41.0'

dependencies:
  flutter:
    sdk: flutter

  # State management (Riverpod 2.6 codegen)
  flutter_riverpod: ^2.6.0
  riverpod_annotation: ^2.6.0

  # Navigation
  go_router: ^14.0.0

  # HTTP
  dio: ^5.4.1

  # Secure storage (Android Keystore + iOS Secure Enclave)
  flutter_secure_storage: ^9.0.0

  # Security
  flutter_jailbreak_detection: ^1.9.0
  flutter_windowmanager: ^0.2.0

  # Serialisation
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1

  # UI — 21st.dev patterns
  shimmer: ^3.0.0           # skeleton loading
  google_fonts: ^6.2.1      # Inter font
  flutter_animate: ^4.5.0   # expressive M3 motion

  # Localisation
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  build_runner: ^2.4.8
  freezed: ^2.4.6
  json_serializable: ^6.7.1
  riverpod_generator: ^2.6.0
  flutter_launcher_icons: ^0.14.0
  msix: ^3.16.7              # Windows Store package
```

---

## Screen specifications

### Home Screen — lib/ui/screens/home_screen.dart

```
┌──────────────────────────────┐
│  Kyro VPN              ⚙    │  ← AppBar minimal
│                              │
│                              │
│         ╭─────────╮         │
│         │    🛡    │         │  ← Shield widget
│         │         │         │    Pulsing ring: connected
│         ╰─────────╯         │    Rotating gradient: connecting
│                              │    Static gray: disconnected
│   Not connected              │  ← Status (displayMedium)
│                              │
│  ┌──────────────────────┐   │
│  │       Connect        │   │  ← FilledButton 56dp full width
│  └──────────────────────┘   │
│                              │
│  ╭──────────────────────╮   │
│  │ 🇮🇳  Mumbai    ●  8ms│   │  ← Node info card (21st.dev style)
│  │ Seed node  •  24 users│  │    Subtle border, no shadow
│  ╰──────────────────────╯   │
│                              │
│  Protected for 2h 14m        │  ← Timer (shown when connected)
│                              │
└──────────────────────────────┘
│ Home │ Nodes │ Contrib │ Set │  ← NavigationBar M3
```

### Nodes Screen — lib/ui/screens/nodes_screen.dart

```
┌──────────────────────────────┐
│  ╭ Search nodes...        🔍╮│  ← M3 SearchBar
│  ╰──────────────────────────╯│
│                              │
│ [All] [Fast ⚡] [Stream 📺]  │  ← FilterChip row
│                              │
│ ╭──────────────────────────╮ │
│ │ 🇮🇳 Mumbai          8ms  │ │  ← Node card (21st.dev)
│ │ Seed · 24 users · ████  │ │    Latency bar visual
│ ╰──────────────────────────╯ │
│ ╭──────────────────────────╮ │
│ │ 🇩🇪 Frankfurt       120ms│ │
│ │ Community · 8 users      │ │
│ ╰──────────────────────────╯ │
└──────────────────────────────┘
```

Node card tap → M3 ModalBottomSheet with full details + Connect button.

### Contribute Screen — lib/ui/screens/contribute_screen.dart

```
┌──────────────────────────────┐
│  Contribute                  │
│                              │
│  Share bandwidth     [●   ] │  ← SwitchListTile
│  Earn credits for premium    │
│                              │
│         1,240                │  ← displayLarge (21st.dev hero number)
│       credits earned         │
│                              │
│  ████████░░░░░░░░░░░░░░░    │  ← LinearProgressIndicator to next tier
│  260 to Premium              │
│                              │
│  4.2 GB  │  42 pts  │  99%  │  ← Stats row (monospace values)
│  shared  │  today   │ uptime│
│                              │
│  Uploading: 0.8 Mbps ▲      │  ← Live upload indicator
└──────────────────────────────┘
```

### Settings Screen — lib/ui/screens/settings_screen.dart

```
┌──────────────────────────────┐
│  Settings                    │
│                              │
│  SECURITY                    │  ← Section header labelLarge
│  Kill switch         [ON]   │
│  DNS leak protection  [ON]   │
│  Block IPv6           [ON]   │
│                              │
│  NETWORK                     │
│  Split tunneling      [OFF]  │
│  Protocol             AUTO > │  ← ListTile → bottom sheet
│  DNS server       1.1.1.1 > │
│                              │
│  APPEARANCE                  │
│  Theme   [System][Light][Dk] │  ← SegmentedButton
│                              │
│  ABOUT                       │
│  Version                v0.1 │
│  View source code          > │  ← Opens GitHub
│  Privacy policy            > │
└──────────────────────────────┘
```

---

## Riverpod state management

```dart
// lib/models/vpn_state.dart — Dart 3.10 sealed classes
sealed class VpnState {
  const VpnState();
}
final class Disconnected extends VpnState {
  const Disconnected();
}
final class Connecting extends VpnState {
  final VpnNode targetNode;
  const Connecting(this.targetNode);
}
final class Connected extends VpnState {
  final VpnNode node;
  final DateTime since;
  const Connected({required this.node, required this.since});

  Duration get sessionDuration => DateTime.now().difference(since);
}
final class VpnError extends VpnState {
  final String message;
  const VpnError(this.message);
}

// lib/providers/connection_provider.dart
@riverpod
class ConnectionNotifier extends _$ConnectionNotifier {
  @override
  VpnState build() => const Disconnected();

  Future<void> connect({VpnNode? preferred}) async {
    state = Connecting(preferred ?? await _getBestNode());
    try {
      final node = (state as Connecting).targetNode;
      final config = await ref.read(coordinatorApiProvider).getConfig(node.id);
      await ref.read(tunnelManagerProvider).start(config);
      state = Connected(node: node, since: DateTime.now());
    } catch (e) {
      state = VpnError(e.toString());
    }
  }

  Future<void> disconnect() async {
    await ref.read(tunnelManagerProvider).stop();
    state = const Disconnected();
  }

  void toggle() =>
    state is Connected ? disconnect() : connect();
}

// lib/providers/node_provider.dart
@riverpod
class NodeList extends _$NodeList {
  @override
  Future<List<VpnNode>> build() =>
    ref.read(coordinatorApiProvider).fetchNodes();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(coordinatorApiProvider).fetchNodes());
  }
}

// lib/providers/settings_provider.dart
@riverpod
class Settings extends _$Settings {
  @override
  KyroSettings build() => KyroSettings.defaults();
}
```

---

## Coordinator API client

```dart
// lib/services/coordinator_api.dart
class CoordinatorApi {
  final Dio _dio;

  CoordinatorApi() : _dio = Dio(BaseOptions(
    baseUrl: const String.fromEnvironment(
      'COORDINATOR_URL',
      defaultValue: 'https://kyrovpn.is-a.dev',
    ),
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
  ));

  Future<List<VpnNode>> fetchNodes() async {
    final r = await _dio.get('/nodes');
    return (r.data['nodes'] as List).map(VpnNode.fromJson).toList();
  }

  Future<VpnNode> getBestNode({String useCase = 'auto'}) async {
    final r = await _dio.get('/nodes/best',
      queryParameters: {'use_case': useCase});
    return VpnNode.fromJson(r.data['node']);
  }

  Future<VpnConfig> getConfig(String nodeId) async {
    final keypair = await _generateKeypair();
    final r = await _dio.post('/vpn/config', data: {
      'node_id': nodeId,
      'client_pubkey': keypair.public,
    });
    return VpnConfig.fromJson(r.data);
  }
}
```

---

## Android setup (API 35, NDK r28)

```gradle
// android/app/build.gradle
android {
    compileSdk 35
    ndkVersion "28.0.12433566"
    defaultConfig {
        applicationId "com.kyrovpn.app"
        minSdk 24
        targetSdk 35
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }
}
```

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
<uses-permission android:name="android.permission.BIND_VPN_SERVICE"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>

<application
  android:networkSecurityConfig="@xml/network_security_config"
  ...>
```

```xml
<!-- android/app/src/main/res/xml/network_security_config.xml -->
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
  <base-config cleartextTrafficPermitted="false">
    <trust-anchors>
      <certificates src="system"/>
    </trust-anchors>
  </base-config>
  <domain-config cleartextTrafficPermitted="true">
    <domain includeSubdomains="false">localhost</domain>
  </domain-config>
</network-security-config>
```

---

## App icon setup

```yaml
# pubspec.yaml
flutter_icons:
  android: true
  ios: true
  windows:
    generate: true
    image_path: "assets/icons/kyro_icon.png"
  linux:
    generate: true
    image_path: "assets/icons/kyro_icon.png"
  image_path: "assets/icons/kyro_icon.png"
  adaptive_icon_background: "#1C0D4F"
  adaptive_icon_foreground: "assets/icons/kyro_foreground.png"
  remove_alpha_ios: true
  background_color_ios: "#5B21B6"
```

```bash
# Generate all icons
flutter pub run flutter_launcher_icons
```
