import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ExplicitBadge extends StatelessWidget {
  const ExplicitBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15,
      height: 15,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.colors.explicit,
        borderRadius: BorderRadius.circular(3),
      ),
      child: const Text(
        'E',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          height: 1,
          color: Colors.white,
        ),
      ),
    );
  }
}

class TagChip extends StatelessWidget {
  const TagChip({
    super.key,
    required this.label,
    this.color,
    this.borderColor,
    this.uppercase = true,
  });

  final String label;
  final Color? color;
  final Color? borderColor;
  final bool uppercase;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor ?? colors.separator),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        uppercase ? label.toUpperCase() : label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          height: 1.3,
          color: color ?? colors.labelSecondary,
        ),
      ),
    );
  }
}

class SourceBadge extends StatelessWidget {
  const SourceBadge({super.key, required this.source});

  final SourceKind source;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isYoutube = source == SourceKind.youtube;
    final color = isYoutube ? colors.accent : colors.labelSecondary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          isYoutube
              ? CupertinoIcons.play_rectangle_fill
              : CupertinoIcons.arrow_down_to_line,
          size: 12,
          color: color,
        ),
        const SizedBox(width: 3),
        Text(
          isYoutube ? 'YT' : 'Local',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
            color: color,
          ),
        ),
      ],
    );
  }
}

enum SourceKind { youtube, local }
