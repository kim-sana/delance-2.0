import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'artwork.dart';
import 'pressable.dart';

class MediaTile extends StatelessWidget {
  const MediaTile({
    super.key,
    required this.artIndex,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
    this.leading,
    this.circle = false,
    this.artSize = 50,
    this.showArtwork = true,
    this.padding = const EdgeInsets.symmetric(vertical: 7),
  });

  final int artIndex;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Widget? leading;
  final bool circle;
  final double artSize;
  final bool showArtwork;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Pressable(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            if (leading != null)
              leading!
            else if (showArtwork)
              Artwork(
                index: artIndex,
                size: artSize,
                borderRadius: circle
                    ? BorderRadius.circular(artSize / 2)
                    : BorderRadius.circular(6),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.texts.bodyLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.4,
                    ).copyWith(color: colors.labelSecondary),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...<Widget>[
              const SizedBox(width: 8),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
