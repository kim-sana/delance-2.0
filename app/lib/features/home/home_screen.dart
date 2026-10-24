import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/layout.dart';
import '../../core/navigation.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_avatar.dart';
import '../../core/widgets/artwork.dart';
import '../../core/widgets/badges.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/equalizer.dart';
import '../../core/widgets/headers.dart';
import '../../core/widgets/song_row.dart';
import '../../mock/mock_data.dart';
import '../../mock/mock_state.dart';
import '../../mock/models.dart';
import '../player/now_playing_screen.dart';
import '../playlist/playlist_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = MockScope.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth * 0.86;
        final columnWidth = constraints.maxWidth - 96;
        return ListView(
          key: const Key('screen-home'),
          padding: EdgeInsets.only(
            top: AppLayout.safeTop(context),
            bottom: AppLayout.scrollClearance(context),
          ),
          children: <Widget>[
            LargeTitleHeader(
              title: 'New',
              trailing: AppAvatar(
                onTap: () =>
                    showMockSnack(context, 'Mockup: profile screen not built'),
              ),
            ),
            _EditorialRail(cardWidth: cardWidth),
            SectionTitle(
              title: 'Latest Songs',
              showChevron: true,
              onTap: () => Navigator.of(context).push(
                mockPushRoute(
                  PlaylistScreen(playlist: MockData.playlistById('today-hits')),
                ),
              ),
            ),
            _SongsRail(state: state, columnWidth: columnWidth),
          ],
        );
      },
    );
  }
}

class _EditorialRail extends StatelessWidget {
  const _EditorialRail({required this.cardWidth});

  final double cardWidth;

  @override
  Widget build(BuildContext context) {
    final height = cardWidth * 0.85 + 86;
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppLayout.screenMargin),
        physics: const BouncingScrollPhysics(),
        itemCount: MockData.editorial.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return _EditorialCard(
            item: MockData.editorial[index],
            width: cardWidth,
          );
        },
      ),
    );
  }
}

class _EditorialCard extends StatelessWidget {
  const _EditorialCard({required this.item, required this.width});

  final EditorialItem item;
  final double width;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            item.eyebrow,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.texts.labelSmall,
          ),
          const SizedBox(height: 4),
          Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.texts.titleLarge,
          ),
          Text(
            item.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.texts.bodyMedium?.copyWith(
              color: colors.labelSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: width,
            height: width * 0.85,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Artwork(
                    index: item.artIndex,
                    borderRadius: BorderRadius.zero,
                    showGlyph: true,
                    glyphOpacity: 0.12,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.62),
                        ],
                        stops: const <double>[0.55, 1],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 14,
                    right: 14,
                    bottom: 12,
                    child: Text(
                      item.caption,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SongsRail extends StatelessWidget {
  const _SongsRail({required this.state, required this.columnWidth});

  final MockState state;
  final double columnWidth;

  @override
  Widget build(BuildContext context) {
    final tracks = MockData.tracksByIds(MockData.latestSongIds);
    final columns = <List<Track>>[tracks.sublist(0, 4), tracks.sublist(4, 8)];
    return SizedBox(
      height: 264,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppLayout.screenMargin),
        physics: const BouncingScrollPhysics(),
        itemCount: columns.length,
        separatorBuilder: (_, _) => const SizedBox(width: 24),
        itemBuilder: (context, index) {
          return SizedBox(
            width: columnWidth,
            child: Column(
              children: <Widget>[
                for (var i = 0; i < columns[index].length; i++)
                  SongRow(
                    track: columns[index][i],
                    showDivider: i < columns[index].length - 1,
                    playing: state.currentTrack.id == columns[index][i].id,
                    paused: !state.isPlaying,
                    trailing: _trailingFor(context, state, columns[index][i]),
                    onTap: () => _openTrack(context, state, columns[index][i]),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget? _trailingFor(BuildContext context, MockState state, Track track) {
    if (state.currentTrack.id == track.id) {
      return Equalizer(paused: !state.isPlaying);
    }
    if (track.id == 'schizo') {
      return IconHit(
        icon: CupertinoIcons.ellipsis,
        color: context.colors.labelSecondary,
        onTap: () => showMockSnack(context, 'Mockup: track menu not built'),
        semanticLabel: 'Track menu',
      );
    }
    if (track.id == 'espiritu') {
      return const TagChip(label: 'Opus');
    }
    if (track.id == 'neon-echo') {
      return const TagChip(label: '320k');
    }
    return SourceBadge(
      source: track.source == TrackSource.youtube
          ? SourceKind.youtube
          : SourceKind.local,
    );
  }

  void _openTrack(BuildContext context, MockState state, Track track) {
    state.selectTrack(track);
    Navigator.of(context).push(mockSheetRoute(const NowPlayingScreen()));
  }
}
