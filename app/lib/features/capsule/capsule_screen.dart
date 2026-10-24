import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/layout.dart';
import '../../core/navigation.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/artwork.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/headers.dart';
import '../../core/widgets/list_card.dart';
import '../../core/widgets/progress.dart';
import '../../mock/mock_data.dart';
import '../../mock/mock_state.dart';
import '../../mock/models.dart';
import '../artist/artist_screen.dart';
import '../player/now_playing_screen.dart';
import '../playlist/playlist_screen.dart';

class CapsuleScreen extends StatelessWidget {
  const CapsuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = MockScope.of(context);
    final capsule = MockData.capsule;
    return Scaffold(
      body: ListView(
        key: const Key('screen-capsule'),
        padding: EdgeInsets.only(
          top: AppLayout.safeTop(context),
          bottom: AppLayout.pushedScreenBottom(context),
        ),
        children: <Widget>[
          const LargeTitleHeader(title: 'Capsule', leading: BackCircleButton()),
          _CapsuleHero(capsule: capsule),
          _ProgressCard(capsule: capsule),
          const FieldLabel(title: 'September Recap', detail: '11 cards'),
          ListCard(
            children: <Widget>[
              for (final entry in capsule.entries)
                ListRow(
                  title: entry.title,
                  subtitle: entry.subtitle,
                  icon: _iconFor(entry.category),
                  accentIcon: entry.category == CapsuleCategory.topSong,
                  showChevron: true,
                  onTap: () => _openEntry(context, entry.category),
                ),
            ],
          ),
          const FieldLabel(title: 'Open Capsule'),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppLayout.screenMargin,
              0,
              AppLayout.screenMargin,
              8,
            ),
            child: PillButton(
              label: 'Play all · 50 songs',
              icon: CupertinoIcons.play_fill,
              expanded: true,
              fontSize: 15,
              padding: const EdgeInsets.symmetric(vertical: 13),
              background: context.colors.accent,
              color: Colors.white,
              onTap: () {
                final playlist = MockData.playlistById(capsule.playlistId);
                state.selectTrackById(playlist.trackIds.first);
                Navigator.of(
                  context,
                ).push(mockSheetRoute(const NowPlayingScreen()));
              },
            ),
          ),
        ],
      ),
    );
  }

  static IconData _iconFor(CapsuleCategory category) {
    return switch (category) {
      CapsuleCategory.topSong => CupertinoIcons.music_note,
      CapsuleCategory.topArtist => CupertinoIcons.person,
      CapsuleCategory.genre => CupertinoIcons.chart_bar,
      CapsuleCategory.habit => CupertinoIcons.calendar,
      CapsuleCategory.discovery => CupertinoIcons.sparkles,
    };
  }

  void _openEntry(BuildContext context, CapsuleCategory category) {
    switch (category) {
      case CapsuleCategory.topSong:
        Navigator.of(context).push(
          mockPushRoute(
            PlaylistScreen(
              playlist: MockData.playlistById(MockData.capsule.playlistId),
            ),
          ),
        );
        return;
      case CapsuleCategory.topArtist:
        Navigator.of(context).push(mockPushRoute(const ArtistScreen()));
        return;
      case CapsuleCategory.genre:
      case CapsuleCategory.habit:
      case CapsuleCategory.discovery:
        showMockSnack(context, 'Mockup: card details not built');
        return;
    }
  }
}

class _CapsuleHero extends StatelessWidget {
  const _CapsuleHero({required this.capsule});

  final CapsuleData capsule;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppLayout.screenMargin,
        4,
        AppLayout.screenMargin,
        16,
      ),
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Artwork(
                index: capsule.artIndex,
                borderRadius: BorderRadius.zero,
                showGlyph: true,
                glyphOpacity: 0.08,
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Color(0x4D000000),
                      Color(0x14000000),
                      Color(0xD1000000),
                    ],
                    stops: <double>[0, 0.35, 1],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                top: 16,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        capsule.monthYear.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                          color: Color(0xCCFFFFFF),
                        ),
                      ),
                    ),
                    PillButton(
                      label: 'Share',
                      background: Colors.white.withValues(alpha: 0.92),
                      color: const Color(0xFF111111),
                      onTap: () => showMockSnack(
                        context,
                        'Mockup: capsule sharing not built',
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 18,
                right: 18,
                bottom: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      capsule.month,
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                        letterSpacing: -0.8,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: <Widget>[
                        _Stat(
                          value: formatThousands(capsule.minutes),
                          label: 'minutes',
                        ),
                        const SizedBox(width: 18),
                        _Stat(
                          value: formatThousands(capsule.plays),
                          label: 'plays',
                        ),
                        const SizedBox(width: 18),
                        _Stat(
                          value: formatThousands(capsule.artists),
                          label: 'artists',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            height: 1.2,
            color: Colors.white,
            fontFeatures: <FontFeature>[FontFeature.tabularFigures()],
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xC7FFFFFF)),
        ),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.capsule});

  final CapsuleData capsule;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppLayout.screenMargin,
        0,
        AppLayout.screenMargin,
        8,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            capsule.currentMonth,
            style: context.texts.titleSmall?.copyWith(fontSize: 15),
          ),
          const SizedBox(height: 3),
          Text(capsule.currentSubtitle, style: context.texts.bodySmall),
          const SizedBox(height: 12),
          LinearProgress(value: capsule.progress, height: 6),
          const SizedBox(height: 7),
          Row(
            children: <Widget>[
              Text(
                capsule.progressLeft,
                style: context.texts.labelSmall?.copyWith(
                  letterSpacing: 0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              Text(
                capsule.progressRight,
                style: context.texts.labelSmall?.copyWith(
                  letterSpacing: 0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
