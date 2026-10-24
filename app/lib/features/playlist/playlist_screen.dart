import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/layout.dart';
import '../../core/navigation.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/artwork.dart';
import '../../core/widgets/badges.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/equalizer.dart';
import '../../core/widgets/headers.dart';
import '../../core/widgets/pressable.dart';
import '../../mock/mock_data.dart';
import '../../mock/mock_state.dart';
import '../../mock/models.dart';
import '../player/now_playing_screen.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key, required this.playlist});

  final PlaylistData playlist;

  @override
  Widget build(BuildContext context) {
    final state = MockScope.of(context);
    final tracks = MockData.tracksByIds(playlist.trackIds);
    final totalSeconds = tracks.fold<int>(
      0,
      (sum, track) => sum + track.durationSeconds,
    );
    return Scaffold(
      body: ListView(
        key: const Key('screen-playlist'),
        padding: EdgeInsets.only(
          top: AppLayout.safeTop(context),
          bottom: AppLayout.pushedScreenBottom(context),
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppLayout.screenMargin,
              6,
              AppLayout.screenMargin,
              0,
            ),
            child: Row(
              children: <Widget>[
                const BackCircleButton(),
                const Spacer(),
                IconHit(
                  icon: CupertinoIcons.ellipsis,
                  color: context.colors.labelSecondary,
                  semanticLabel: 'Playlist menu',
                  onTap: () =>
                      showMockSnack(context, 'Mockup: playlist menu not built'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.22),
                    blurRadius: 30,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Artwork(
                index: playlist.artIndex,
                size: 156,
                borderRadius: BorderRadius.circular(16),
                showGlyph: true,
                glyphOpacity: 0.10,
              ),
            ),
          ),
          const SizedBox(height: 18),
          if (playlist.isCapsule)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Center(
                child: TagChip(
                  label: 'Capsule',
                  color: context.colors.accent,
                  borderColor: context.colors.accentTint,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              playlist.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.texts.headlineLarge,
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              playlist.description,
              textAlign: TextAlign.center,
              style: context.texts.bodySmall?.copyWith(
                color: context.colors.labelSecondary,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${tracks.length} tracks · ${formatMinutes(totalSeconds)}',
            textAlign: TextAlign.center,
            style: context.texts.labelMedium?.copyWith(
              color: context.colors.labelTertiary,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              PillButton(
                label: 'Play',
                icon: CupertinoIcons.play_fill,
                fontSize: 15,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 13,
                ),
                background: context.colors.accent,
                color: Colors.white,
                onTap: () {
                  state.selectTrack(tracks.first);
                  Navigator.of(
                    context,
                  ).push(mockSheetRoute(const NowPlayingScreen()));
                },
              ),
              const SizedBox(width: 12),
              CircleIconButton(
                icon: CupertinoIcons.shuffle,
                size: 44,
                iconSize: 18,
                background: context.colors.bgSecondary,
                semanticLabel: 'Shuffle',
                onTap: () {
                  state.selectTrack(
                    tracks[tracks.length > 2 ? 2 : 0],
                    autoplay: true,
                  );
                  Navigator.of(
                    context,
                  ).push(mockSheetRoute(const NowPlayingScreen()));
                },
              ),
              const SizedBox(width: 10),
              CircleIconButton(
                icon: CupertinoIcons.arrow_down_to_line,
                size: 44,
                iconSize: 18,
                background: context.colors.bgSecondary,
                semanticLabel: 'Download playlist',
                onTap: () => showMockSnack(
                  context,
                  'Mockup: playlist download not built',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppLayout.screenMargin,
            ),
            child: Row(
              children: <Widget>[
                Text(
                  'Track list',
                  style: context.texts.titleSmall?.copyWith(fontSize: 15),
                ),
                const Spacer(),
                Text(
                  '${tracks.length} tracks',
                  style: context.texts.labelMedium?.copyWith(
                    color: context.colors.labelTertiary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          for (var i = 0; i < tracks.length; i++)
            _PlaylistTrackRow(
              index: i + 1,
              track: tracks[i],
              state: state,
              showDivider: i < tracks.length - 1,
              onTap: () {
                state.selectTrack(tracks[i]);
                Navigator.of(
                  context,
                ).push(mockSheetRoute(const NowPlayingScreen()));
              },
            ),
        ],
      ),
    );
  }
}

class _PlaylistTrackRow extends StatelessWidget {
  const _PlaylistTrackRow({
    required this.index,
    required this.track,
    required this.state,
    required this.showDivider,
    required this.onTap,
  });

  final int index;
  final Track track;
  final MockState state;
  final bool showDivider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isCurrent = state.currentTrack.id == track.id;
    return Pressable(
      onTap: onTap,
      semanticLabel: '${track.title} by ${track.artist}',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppLayout.screenMargin,
              vertical: 8,
            ),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 24,
                  child: isCurrent
                      ? Equalizer(paused: !state.isPlaying)
                      : Text(
                          '$index',
                          textAlign: TextAlign.center,
                          style: context.texts.labelMedium?.copyWith(
                            color: colors.labelTertiary,
                            fontFeatures: const <FontFeature>[
                              FontFeature.tabularFigures(),
                            ],
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              track.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.texts.bodyLarge?.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: isCurrent
                                    ? colors.accent
                                    : colors.labelPrimary,
                              ),
                            ),
                          ),
                          if (track.explicit) ...<Widget>[
                            const SizedBox(width: 6),
                            const ExplicitBadge(),
                          ],
                          if (state.isDownloaded(track.id)) ...<Widget>[
                            const SizedBox(width: 6),
                            Icon(
                              CupertinoIcons.arrow_down_to_line,
                              size: 11,
                              color: colors.labelTertiary,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 1),
                      Text(
                        track.artist,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.texts.bodySmall?.copyWith(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  formatSeconds(track.durationSeconds),
                  style: context.texts.labelMedium?.copyWith(
                    color: colors.labelTertiary,
                    fontFeatures: const <FontFeature>[
                      FontFeature.tabularFigures(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (showDivider)
            Padding(
              padding: const EdgeInsets.only(left: 56),
              child: Divider(height: 1, thickness: 1, color: colors.separator),
            ),
        ],
      ),
    );
  }
}
