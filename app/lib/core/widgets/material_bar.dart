import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class MaterialBar extends StatelessWidget {
  const MaterialBar({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.color,
    this.border,
    this.shadow,
    this.blur = 20,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final Color? color;
  final Border? border;
  final BoxShadow? shadow;
  final double blur;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: shadow == null ? null : <BoxShadow>[shadow!],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color ?? colors.materialBar,
              borderRadius: borderRadius,
              border: border,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
