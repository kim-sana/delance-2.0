import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/layout.dart';
import '../../core/navigation.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/badges.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/headers.dart';
import '../../core/widgets/list_card.dart';
import '../../core/widgets/media_tile.dart';
import '../../core/widgets/song_row.dart';
import '../../mock/mock_data.dart';
import '../../mock/mock_state.dart';
import '../../mock/models.dart';
import '../player/now_playing_screen.dart';
import '../playlist/playlist_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const List<String> _filters = <String>[
    'YouTube',
    'Local',
    'Downloads',
    'Playlist',
  ];

  final TextEditingController _controller = TextEditingController(
    text: 'cloud thought',
  );
  int _filter = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setQuery(String value) {
    _controller.text = value;
    _controller.selection = TextSelection.collapsed(offset: value.length);
    setState(() => _filter = 0);
  }

  @override
  Widget build(BuildContext context) {
    final state = MockScope.of(context);
    final hasQuery = _controller.text.trim().isNotEmpty;
    return ListView(
      key: const Key('screen-search'),
      padding: EdgeInsets.only(
        top: AppLayout.safeTop(context),
        bottom: AppLayout.scrollClearance(context),
      ),
      children: <Widget>[
        const LargeTitleHeader(title: 'Search'),
        _SearchField(
          controller: _controller,
          onChanged: () => setState(() {}),
          onClear: () {
            _controller.clear();
            setState(() {});
          },
        ),
        _FilterRail(
          filters: _filters,
          index: _filter,
          onChanged: (index) => setState(() => _filter = index),
        ),
        if (!hasQuery)
          _RecentSearches(onSelect: _setQuery)
        else ...<Widget>[
          if (_filter == 0) ...<Widget>[
            FieldLabel(title: 'YouTube', detail: 'Piped API · 3 results'),
            _YouTubeResults(state: state),
            FieldLabel(title: 'On device', detail: '2 results'),
            _LocalResults(state: state),
          ],
          if (_filter == 1) ...<Widget>[
            FieldLabel(title: 'On device', detail: '2 results'),
            _LocalResults(state: state),
          ],
          if (_filter == 2) _DownloadResults(state: state),
          if (_filter == 3) const _PlaylistResults(),
        ],
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final VoidCallback onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppLayout.screenMargin,
        4,
        AppLayout.screenMargin,
        0,
      ),
      child: Container(
        height: 44,
        padding: const EdgeInsets.only(left: 12, right: 4),
        decoration: BoxDecoration(
          color: colors.bgSecondary,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Row(
          children: <Widget>[
            Icon(CupertinoIcons.search, size: 18, color: colors.labelSecondary),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                key: const Key('search-field'),
                controller: controller,
                onChanged: (_) => onChanged(),
                textInputAction: TextInputAction.search,
                style: TextStyle(
                  fontSize: 15,
                  color: colors.labelPrimary,
                  height: 1.3,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: 'Songs, artists, videos',
                  hintStyle: TextStyle(
                    fontSize: 15,
                    color: colors.labelTertiary,
                  ),
                ),
              ),
            ),
            if (controller.text.isNotEmpty)
              IconHit(
                icon: CupertinoIcons.clear_thick_circled,
                size: 15,
                hitSize: 34,
                color: colors.labelTertiary,
                onTap: onClear,
                semanticLabel: 'Clear search',
              ),
          ],
        ),
      ),
    );
  }
}

class _FilterRail extends StatelessWidget {
  const _FilterRail({
    required this.filters,
    required this.index,
    required this.onChanged,
  });

  final List<String> filters;
  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(
        AppLayout.screenMargin,
        12,
        AppLayout.screenMargin,
        2,
      ),
      child: Row(
        children: <Widget>[
          for (var i = 0; i < filters.length; i++) ...<Widget>[
            if (i > 0) const SizedBox(width: 8),
            GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: i == index ? colors.accentTint : colors.bgSecondary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  filters[i],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: i == index ? colors.accent : colors.labelPrimary,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RecentSearches extends StatelessWidget {
  const _RecentSearches({required this.onSelect});

  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    const recents = <String>[
      'cloud thought',
      'aria lune',
      'lo-fi',
      'never ever',
    ];
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SectionLabel(label: 'Recent searches'),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppLayout.screenMargin,
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              for (final query in recents)
                GestureDetector(
                  onTap: () => onSelect(query),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: colors.bgSecondary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          CupertinoIcons.clock,
                          size: 13,
                          color: colors.labelTertiary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          query,
                          style: TextStyle(
                            fontSize: 13,
                            color: colors.labelPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const EmptyState(
          icon: CupertinoIcons.search,
          title: 'Search for any song',
          message:
              'YouTube results and local tracks will appear here. '
              'Try "cloud thought" to see an example.',
        ),
      ],
    );
  }
}

class _YouTubeResults extends StatelessWidget {
  const _YouTubeResults({required this.state});

  final MockState state;

  @override
  Widget build(BuildContext context) {
    final tracks = MockData.tracksByIds(<String>[
      'cloud-thought',
      'midnight-echo',
      'schizo',
    ]);
    return ListCard(
      children: <Widget>[
        for (final track in tracks)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: SongRow(
              track: track,
              showDivider: false,
              subtitle:
                  '${track.artist} · ${formatSeconds(track.durationSeconds)} · ${track.codec ?? 'YouTube'}',
              trailing: SaveButton(
                saved: state.isSaved(track.id),
                onTap: () => state.toggleSaved(track.id),
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
    );
  }
}

class _LocalResults extends StatelessWidget {
  const _LocalResults({required this.state});

  final MockState state;

  @override
  Widget build(BuildContext context) {
    final tracks = MockData.tracksByIds(MockData.localSearchIds);
    return ListCard(
      children: <Widget>[
        for (final track in tracks)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: SongRow(
              track: track,
              showDivider: false,
              subtitle: '${track.artist} · ${track.bpm} BPM · Ready offline',
              trailing: SourceBadge(
                source: track.source == TrackSource.youtube
                    ? SourceKind.youtube
                    : SourceKind.local,
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
    );
  }
}

class _DownloadResults extends StatelessWidget {
  const _DownloadResults({required this.state});

  final MockState state;

  @override
  Widget build(BuildContext context) {
    final tracks = MockData.downloads
        .map((item) {
          return (track: MockData.trackById(item.trackId), item: item);
        })
        .toList(growable: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FieldLabel(title: 'Downloads', detail: '${tracks.length} tracks'),
        ListCard(
          children: <Widget>[
            for (final entry in tracks)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: SongRow(
                  track: entry.track,
                  showDivider: false,
                  subtitle:
                      '${entry.item.format} · ${entry.item.bitrate} · ${formatMegabytes(entry.item.sizeMb)}',
                  trailing: entry.item.status == DownloadStatus.done
                      ? Icon(
                          CupertinoIcons.check_mark_circled,
                          size: 18,
                          color: context.colors.labelTertiary,
                        )
                      : Text(
                          '${(entry.item.progress * 100).round()}%',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                  onTap: () {
                    state.selectTrack(entry.track);
                    Navigator.of(
                      context,
                    ).push(mockSheetRoute(const NowPlayingScreen()));
                  },
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _PlaylistResults extends StatelessWidget {
  const _PlaylistResults();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const FieldLabel(title: 'Playlist', detail: '6 playlists'),
        ListCard(
          children: <Widget>[
            for (final playlist in MockData.playlists)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: MediaTile(
                  artIndex: playlist.artIndex,
                  title: playlist.title,
                  subtitle: playlist.description,
                  trailing: Icon(
                    CupertinoIcons.chevron_right,
                    size: 15,
                    color: context.colors.labelTertiary,
                  ),
                  onTap: () => Navigator.of(
                    context,
                  ).push(mockPushRoute(PlaylistScreen(playlist: playlist))),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
