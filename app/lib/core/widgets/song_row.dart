import 'package:flutter/material.dart';

import '../../mock/models.dart';
import '../theme/app_colors.dart';
import 'artwork.dart';
import 'badges.dart';
import 'pressable.dart';

class SongRow extends StatelessWidget {
  const SongRow({
    super.key,
    required this.track,
    this.onTap,
    this.trailing,
    this.playing = false,
    this.paused = false,
    this.showDivider = true,
    this.artSize = 50,
    this.subtitle,
  });

  final Track track;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool playing;
  final bool paused;
  final bool showDivider;
  final double artSize;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Pressable(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 64),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                children: <Widget>[
                  Artwork(
                    index: track.artIndex,
                    size: artSize,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                track.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.texts.bodyLarge?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: 1.35,
                                  color: playing
                                      ? colors.accent
                                      : colors.labelPrimary,
                                ),
                              ),
                            ),
                            if (track.explicit) ...<Widget>[
                              const SizedBox(width: 6),
                              const ExplicitBadge(),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle ?? track.artist,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.texts.bodySmall?.copyWith(
                            fontSize: 14,
                            color: colors.labelSecondary,
                          ),
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
          ),
          if (showDivider)
            Padding(
              padding: const EdgeInsets.only(left: 62),
              child: Divider(height: 1, thickness: 1, color: colors.separator),
            ),
        ],
      ),
    );
  }
}
