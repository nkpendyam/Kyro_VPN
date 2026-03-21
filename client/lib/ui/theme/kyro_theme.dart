import 'package:flutter/material.dart';

class KyroTheme {
  static const _seedColor = Color(0xFF5B21B6); // Deep Violet

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _seedColor,
      brightness: Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: 'JetBrains Mono', // For technical feel, or use default M3
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _seedColor,
      brightness: Brightness.dark,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: 'JetBrains Mono',
    );
  }
}
