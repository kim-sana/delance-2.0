import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/layout.dart';
import '../../core/navigation.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/artwork.dart';
import '../../core/widgets/badges.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/headers.dart';
import '../../core/widgets/list_card.dart';
import '../../core/widgets/pressable.dart';
import '../../core/widgets/song_row.dart';
import '../../mock/mock_data.dart';
import '../../mock/mock_state.dart';
import '../../mock/models.dart';
import '../player/now_playing_screen.dart';
import '../playlist/playlist_screen.dart';

class ArtistScreen extends StatefulWidget {
  const ArtistScreen({super.key});

  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  bool _following = false;
  bool _bioExpanded = false;

  @override
  Widget build(BuildContext context) {
    final state = MockScope.of(context);
    final artist = MockData.artist;
    final topTracks = MockData.tracksByIds(artist.topTrackIds);
    return Scaffold(
      body: ListView(
        key: const Key('screen-artist'),
        padding: EdgeInsets.only(
          top: 0,
          bottom: AppLayout.pushedScreenBottom(context),
        ),
        children: <Widget>[
          _ArtistHero(
            artist: artist,
            onBack: () => Navigator.of(context).maybePop(),
            onShare: () =>
                showMockSnack(context, 'Mockup: artist sharing not built'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppLayout.screenMargin,
              0,
              AppLayout.screenMargin,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(artist.name, style: context.texts.displaySmall),
                const SizedBox(height: 2),
                Text(
                  '${formatThousands(artist.monthlyListeners)} monthly listeners',
                  style: context.texts.bodySmall,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: <Widget>[
                    for (final tag in artist.tags)
                      TagChip(label: tag, uppercase: false),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: <Widget>[
                    PillButton(
                      label: 'Play',
                      icon: CupertinoIcons.play_fill,
                      fontSize: 15,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 11,
                      ),
                      background: context.colors.accent,
                      color: Colors.white,
                      onTap: () {
                        state.selectTrack(topTracks.first);
                        Navigator.of(
                          context,
                        ).push(mockSheetRoute(const NowPlayingScreen()));
                      },
                    ),
                    const SizedBox(width: 10),
                    PillButton(
                      label: _following ? 'Following' : 'Follow',
                      icon: _following
                          ? CupertinoIcons.check_mark
                          : CupertinoIcons.add,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 11,
                      ),
                      background: context.colors.bgSecondary,
                      onTap: () => setState(() => _following = !_following),
                    ),
                    const Spacer(),
                    IconHit(
                      icon: CupertinoIcons.ellipsis,
                      color: context.colors.labelSecondary,
                      semanticLabel: 'Artist menu',
                      onTap: () => showMockSnack(
                        context,
                        'Mockup: artist menu not built',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  artist.bio,
                  maxLines: _bioExpanded ? null : 4,
                  overflow: _bioExpanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  style: context.texts.bodyMedium?.copyWith(
                    fontSize: 14,
                    height: 1.55,
                    color: context.colors.labelSecondary,
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _bioExpanded = !_bioExpanded),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      _bioExpanded ? 'Show less' : 'Show more',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: context.colors.accent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SectionTitle(
            title: 'Popular songs',
            showChevron: true,
            onTap: () => showMockSnack(context, 'Mockup: full list not built'),
          ),
          ListCard(
            children: <Widget>[
              for (final track in topTracks)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: SongRow(
                    track: track,
                    artSize: 44,
                    showDivider: false,
                    playing: state.currentTrack.id == track.id,
                    paused: !state.isPlaying,
                    subtitle: '${track.album} · ${track.genre}',
                    trailing: Text(
                      formatSeconds(track.durationSeconds),
                      style: context.texts.labelMedium?.copyWith(
                        color: context.colors.labelTertiary,
                        fontFeatures: const <FontFeature>[
                          FontFeature.tabularFigures(),
                        ],
                      ),
                    ),
                    onTap: () {
                      state.selectTrack(track);
                      Navigator.of(
                        context,
                      ).push(mockSheetRoute(const NowPlayingScreen()));
                    },
                  ),
                ),
            ],
          ),
          const SectionTitle(title: 'Album'),
          SizedBox(
            height: 194,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppLayout.screenMargin,
              ),
              itemCount: artist.albumTitles.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                return _AlbumCard(
                  title: artist.albumTitles[index],
                  artIndex: artist.albumArtIndices[index],
                  year: index == 0 ? 2026 : (2025 - index),
                  onTap: index == 0
                      ? () => Navigator.of(context).push(
                          mockPushRoute(
                            PlaylistScreen(
                              playlist: MockData.playlistById('never-ever'),
                            ),
                          ),
                        )
                      : () => showMockSnack(
                          context,
                          'Mockup: album ${artist.albumTitles[index]} not built',
                        ),
                );
              },
            ),
          ),
          const FieldLabel(title: 'Data sources'),
          ListCard(
            children: <Widget>[
              for (final source in MockData.artistSources)
                ListRow(
                  title: source.label,
                  subtitle: source.detail,
                  icon: CupertinoIcons.link,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ArtistHero extends StatelessWidget {
  const _ArtistHero({
    required this.artist,
    required this.onBack,
    required this.onShare,
  });

  final ArtistProfile artist;
  final VoidCallback onBack;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      height: 236,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 200,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Artwork(
                  index: artist.bannerArtIndex,
                  borderRadius: BorderRadius.zero,
                  showGlyph: true,
                  glyphOpacity: 0.10,
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Color(0x66000000),
                        Colors.transparent,
                        Color(0x99000000),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  right: 12,
                  top: AppLayout.safeTop(context) - 4,
                  child: Row(
                    children: <Widget>[
                      GlassButton(
                        icon: CupertinoIcons.chevron_left,
                        onTap: onBack,
                        semanticLabel: 'Back',
                      ),
                      const Spacer(),
                      GlassButton(
                        icon: CupertinoIcons.share,
                        onTap: onShare,
                        semanticLabel: 'Share',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: AppLayout.screenMargin,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: colors.bgPrimary,
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Artwork(
                index: artist.photoArtIndex,
                size: 92,
                borderRadius: BorderRadius.circular(46),
                showGlyph: true,
                glyphOpacity: 0.10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlbumCard extends StatelessWidget {
  const _AlbumCard({
    required this.title,
    required this.artIndex,
    required this.year,
    required this.onTap,
  });

  final String title;
  final int artIndex;
  final int year;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      semanticLabel: title,
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Artwork(
              index: artIndex,
              size: 140,
              borderRadius: BorderRadius.circular(10),
              showGlyph: true,
              glyphOpacity: 0.10,
            ),
            const SizedBox(height: 7),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.texts.titleSmall?.copyWith(fontSize: 14),
            ),
            Text(
              '$year · Album',
              style: context.texts.labelMedium?.copyWith(
                fontSize: 12,
                color: context.colors.labelSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
