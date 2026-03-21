---
name: kyro-frontend
description: >
  Expert Flutter UI development for Kyro VPN using Material Design 3
  Expressive (Google Stitch 2026) and 21st.dev component patterns.
  Activate when building any Flutter screens, widgets, themes, or
  UI components. Use Flutter 3.41 + Dart 3.10 standards always.
---

# Kyro Frontend Skill — M3 Expressive + 21st.dev

## Design system

### Material Design 3 Expressive (Google Stitch 2026)
```dart
ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xFF5B21B6),
  ),
)
```

### 21st.dev patterns for Flutter
- Generous whitespace: 24dp screen padding minimum
- Cards: no elevation, subtle 0.5px border instead
- Monospace: JetBrains Mono for IPs, latency, keys, technical values
- Status: colored dots (10px circle), not text labels
- Loading: Shimmer skeleton, not CircularProgressIndicator
- Progressive disclosure: simple view → detail on tap (ModalBottomSheet)

## Dart 3.10 — always use these features
```dart
// Dot shorthands
padding: .all(16)
alignment: .center
color: .blue

// Sealed classes
sealed class VpnState {}
final class Connected extends VpnState {
  final VpnNode node;
}

// Records
(String private, String public) = generateKeypair();

// Patterns in switch
switch (state) {
  case Connected(:final node) => ConnectedView(node),
  case Connecting() => LoadingView(),
  case Disconnected() => ConnectView(),
  case VpnError(:final message) => ErrorView(message),
}
```

## Riverpod — always codegen
```dart
@riverpod
class ConnectionNotifier extends _$ConnectionNotifier {
  @override
  VpnState build() => const Disconnected();
}
```
Never use StateProvider, ChangeNotifier, or setState for business logic.

## Components to use
✓ FilledButton (primary action)
✓ OutlinedButton (secondary)
✓ NavigationBar (bottom nav)
✓ Card (borderless, 0.5px border)
✓ SearchBar (M3 style)
✓ FilterChip (node filtering)
✓ SegmentedButton (theme toggle)
✓ SwitchListTile (kill switch, etc)
✓ ModalBottomSheet (node detail)
✓ LinearProgressIndicator (credit progress)

✗ NEVER RaisedButton, FlatButton
✗ NEVER BottomNavigationBar
✗ NEVER hardcoded Color() in widgets
✗ NEVER hardcoded fontSize in TextStyle

## Screen order to build
1. home_screen.dart — shield + connect button
2. nodes_screen.dart — list + search + filter
3. settings_screen.dart — toggles + segmented
4. contribute_screen.dart — credits + stats
5. shell.dart — NavigationBar wrapper

## After every UI file
Run: flutter analyze
Must show: No issues found
