import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'pressable.dart';

class IconHit extends StatelessWidget {
  const IconHit({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 22,
    this.color,
    this.semanticLabel,
    this.hitSize = 44,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final Color? color;
  final String? semanticLabel;
  final double hitSize;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      semanticLabel: semanticLabel,
      child: SizedBox.square(
        dimension: hitSize,
        child: Icon(
          icon,
          size: size,
          color: color ?? context.colors.labelPrimary,
        ),
      ),
    );
  }
}

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.background,
    this.color,
    this.size = 36,
    this.iconSize = 20,
    this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Color? background;
  final Color? color;
  final double size;
  final double iconSize;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Pressable(
      onTap: onTap,
      semanticLabel: semanticLabel,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: background ?? colors.bgFill,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: iconSize, color: color ?? colors.labelPrimary),
      ),
    );
  }
}

class SaveButton extends StatelessWidget {
  const SaveButton({super.key, required this.saved, this.onTap, this.color});

  final bool saved;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Pressable(
      onTap: onTap,
      semanticLabel: saved ? 'Saved' : 'Download audio',
      child: SizedBox.square(
        dimension: 44,
        child: Center(
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: saved ? Colors.transparent : colors.accentTint,
            ),
            alignment: Alignment.center,
            child: Icon(
              saved
                  ? CupertinoIcons.check_mark_circled
                  : CupertinoIcons.arrow_down_to_line,
              size: 17,
              color: saved
                  ? (color ?? colors.labelTertiary)
                  : (color ?? colors.accent),
            ),
          ),
        ),
      ),
    );
  }
}

class GlassButton extends StatelessWidget {
  const GlassButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 42,
    this.iconSize = 20,
    this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final double iconSize;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      semanticLabel: semanticLabel,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            ),
            child: Icon(icon, size: iconSize, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    this.onTap,
    this.background,
    this.color,
    this.icon,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
    this.expanded = false,
    this.fontSize = 13,
  });

  final String label;
  final VoidCallback? onTap;
  final Color? background;
  final Color? color;
  final IconData? icon;
  final EdgeInsets padding;
  final bool expanded;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background ?? colors.bgFill,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: expanded
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, size: 16, color: color ?? colors.labelPrimary),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: color ?? colors.labelPrimary,
            ),
          ),
        ],
      ),
    );
    return Pressable(
      onTap: onTap,
      semanticLabel: label,
      child: expanded
          ? SizedBox(width: double.infinity, child: content)
          : content,
    );
  }
}
