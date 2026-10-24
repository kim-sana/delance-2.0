import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.accent,
    required this.accentPressed,
    required this.accentTint,
    required this.bgPrimary,
    required this.bgSecondary,
    required this.bgElevated,
    required this.bgFill,
    required this.materialBar,
    required this.labelPrimary,
    required this.labelSecondary,
    required this.labelTertiary,
    required this.separator,
    required this.explicit,
    required this.nowPlayingText,
    required this.nowPlayingTextSecondary,
  });

  final Color accent;
  final Color accentPressed;
  final Color accentTint;
  final Color bgPrimary;
  final Color bgSecondary;
  final Color bgElevated;
  final Color bgFill;
  final Color materialBar;
  final Color labelPrimary;
  final Color labelSecondary;
  final Color labelTertiary;
  final Color separator;
  final Color explicit;
  final Color nowPlayingText;
  final Color nowPlayingTextSecondary;

  static const light = AppColors(
    accent: Color(0xFFFA2D48),
    accentPressed: Color(0xFFD92638),
    accentTint: Color(0x1FFA2D48),
    bgPrimary: Color(0xFFFFFFFF),
    bgSecondary: Color(0xFFF2F2F7),
    bgElevated: Color(0xFFFFFFFF),
    bgFill: Color(0x1F787880),
    materialBar: Color(0xF0F9F9F9),
    labelPrimary: Color(0xFF000000),
    labelSecondary: Color(0x993C3C43),
    labelTertiary: Color(0x4D3C3C43),
    separator: Color(0x263C3C43),
    explicit: Color(0xFF8E8E93),
    nowPlayingText: Color(0xFFFFFFFF),
    nowPlayingTextSecondary: Color(0xB8FFFFFF),
  );

  static const dark = AppColors(
    accent: Color(0xFFFA2D48),
    accentPressed: Color(0xFFD92638),
    accentTint: Color(0x1FFA2D48),
    bgPrimary: Color(0xFF000000),
    bgSecondary: Color(0xFF1C1C1E),
    bgElevated: Color(0xFF2C2C2E),
    bgFill: Color(0x3D787880),
    materialBar: Color(0xE6161618),
    labelPrimary: Color(0xFFFFFFFF),
    labelSecondary: Color(0x99EBEBF5),
    labelTertiary: Color(0x4DEBEBF5),
    separator: Color(0x73545458),
    explicit: Color(0xFF636366),
    nowPlayingText: Color(0xFFFFFFFF),
    nowPlayingTextSecondary: Color(0xB8FFFFFF),
  );

  @override
  AppColors copyWith({
    Color? accent,
    Color? accentPressed,
    Color? accentTint,
    Color? bgPrimary,
    Color? bgSecondary,
    Color? bgElevated,
    Color? bgFill,
    Color? materialBar,
    Color? labelPrimary,
    Color? labelSecondary,
    Color? labelTertiary,
    Color? separator,
    Color? explicit,
    Color? nowPlayingText,
    Color? nowPlayingTextSecondary,
  }) {
    return AppColors(
      accent: accent ?? this.accent,
      accentPressed: accentPressed ?? this.accentPressed,
      accentTint: accentTint ?? this.accentTint,
      bgPrimary: bgPrimary ?? this.bgPrimary,
      bgSecondary: bgSecondary ?? this.bgSecondary,
      bgElevated: bgElevated ?? this.bgElevated,
      bgFill: bgFill ?? this.bgFill,
      materialBar: materialBar ?? this.materialBar,
      labelPrimary: labelPrimary ?? this.labelPrimary,
      labelSecondary: labelSecondary ?? this.labelSecondary,
      labelTertiary: labelTertiary ?? this.labelTertiary,
      separator: separator ?? this.separator,
      explicit: explicit ?? this.explicit,
      nowPlayingText: nowPlayingText ?? this.nowPlayingText,
      nowPlayingTextSecondary:
          nowPlayingTextSecondary ?? this.nowPlayingTextSecondary,
    );
  }

  @override
  AppColors lerp(covariant ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      accent: Color.lerp(accent, other.accent, t)!,
      accentPressed: Color.lerp(accentPressed, other.accentPressed, t)!,
      accentTint: Color.lerp(accentTint, other.accentTint, t)!,
      bgPrimary: Color.lerp(bgPrimary, other.bgPrimary, t)!,
      bgSecondary: Color.lerp(bgSecondary, other.bgSecondary, t)!,
      bgElevated: Color.lerp(bgElevated, other.bgElevated, t)!,
      bgFill: Color.lerp(bgFill, other.bgFill, t)!,
      materialBar: Color.lerp(materialBar, other.materialBar, t)!,
      labelPrimary: Color.lerp(labelPrimary, other.labelPrimary, t)!,
      labelSecondary: Color.lerp(labelSecondary, other.labelSecondary, t)!,
      labelTertiary: Color.lerp(labelTertiary, other.labelTertiary, t)!,
      separator: Color.lerp(separator, other.separator, t)!,
      explicit: Color.lerp(explicit, other.explicit, t)!,
      nowPlayingText: Color.lerp(nowPlayingText, other.nowPlayingText, t)!,
      nowPlayingTextSecondary: Color.lerp(
        nowPlayingTextSecondary,
        other.nowPlayingTextSecondary,
        t,
      )!,
    );
  }
}

extension AppThemeContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;

  TextTheme get texts => Theme.of(this).textTheme;
}
