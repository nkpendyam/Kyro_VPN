import 'package:flutter/material.dart';

class KyroTheme {
  static const _seedColor = Color(0xFF6750A4); // M3 Standard Violet

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _seedColor,
      brightness: Brightness.light,
    );
    return _refine(base);
  }

  static ThemeData get dark {
    final base = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _seedColor,
      brightness: Brightness.dark,
    );
    return _refine(base);
  }

  static ThemeData _refine(ThemeData base) {
    return base.copyWith(
      textTheme: base.textTheme.apply(
        fontFamily: 'JetBrains Mono',
        displayColor: base.colorScheme.onSurface,
        bodyColor: base.colorScheme.onSurface,
      ),
      cardTheme: base.cardTheme.copyWith(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: base.colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        indicatorColor: base.colorScheme.secondaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: base.colorScheme.onSecondaryContainer);
          }
          return IconThemeData(color: base.colorScheme.onSurfaceVariant);
        }),
      ),
    );
  }
}
