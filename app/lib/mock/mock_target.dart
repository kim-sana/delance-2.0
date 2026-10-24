import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MockTarget {
  const MockTarget({this.screen = 'home', this.themeMode});

  final String screen;
  final ThemeMode? themeMode;

  factory MockTarget.fromEnvironment() {
    if (!kIsWeb) return const MockTarget();
    final params = Uri.base.queryParameters;
    final screen = (params['screen'] ?? 'home').toLowerCase();
    final theme = params['theme']?.toLowerCase();
    return MockTarget(
      screen: screen,
      themeMode: switch (theme) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        'system' => ThemeMode.system,
        _ => null,
      },
    );
  }
}
