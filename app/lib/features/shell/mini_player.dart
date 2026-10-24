import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/layout.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/artwork.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/material_bar.dart';
import '../../core/widgets/pressable.dart';
import '../../mock/models.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({
    super.key,
    required this.track,
    required this.isPlaying,
    required this.onOpen,
    required this.onPlay,
    required this.onNext,
  });

  final Track track;
  final bool isPlaying;
  final VoidCallback onOpen;
  final VoidCallback onPlay;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MaterialBar(
      borderRadius: BorderRadius.circular(AppLayout.miniPlayerRadius),
      shadow: isDark
          ? null
          : BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
      border: isDark ? Border.all(color: colors.separator) : null,
      child: SizedBox(
        height: AppLayout.miniPlayerHeight,
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Pressable(
                  key: const Key('mini-player-body'),
                  onTap: onOpen,
                  semanticLabel: 'Open Now Playing',
                  child: Row(
                    children: <Widget>[
                      Artwork(
                        index: track.artIndex,
                        size: 40,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              track.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                                color: colors.labelPrimary,
                              ),
                            ),
                            Text(
                              track.artist,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.labelSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconHit(
                key: const Key('mini-player-play'),
                icon: isPlaying
                    ? CupertinoIcons.pause_fill
                    : CupertinoIcons.play_fill,
                size: 18,
                color: colors.labelPrimary,
                onTap: onPlay,
                semanticLabel: isPlaying ? 'Pause' : 'Play',
              ),
              IconHit(
                key: const Key('mini-player-next'),
                icon: CupertinoIcons.forward_end_fill,
                size: 18,
                color: colors.labelPrimary,
                onTap: onNext,
                semanticLabel: 'Next',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
