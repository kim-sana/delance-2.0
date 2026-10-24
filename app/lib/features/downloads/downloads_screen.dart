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
import '../../core/widgets/progress.dart';
import '../../mock/mock_data.dart';
import '../../mock/mock_state.dart';
import '../../mock/models.dart';
import '../player/now_playing_screen.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = MockScope.of(context);
    final running = MockData.downloads
        .where((item) => item.status == DownloadStatus.running)
        .toList(growable: false);
    final done = MockData.downloads
        .where((item) => item.status == DownloadStatus.done)
        .toList(growable: false);
    final totalMb = done.fold<double>(0, (sum, item) => sum + item.sizeMb);
    return Scaffold(
      body: ListView(
        key: const Key('screen-downloads'),
        padding: EdgeInsets.only(
          top: AppLayout.safeTop(context),
          bottom: AppLayout.pushedScreenBottom(context),
        ),
        children: <Widget>[
          const LargeTitleHeader(
            title: 'Downloads',
            leading: BackCircleButton(),
          ),
          _SummaryCard(items: running),
          const FieldLabel(title: 'In progress'),
          ListCard(
            children: <Widget>[
              for (final item in running) _RunningRow(item: item),
            ],
          ),
          FieldLabel(
            title: 'Completed',
            detail: '${done.length} songs · ${formatMegabytes(totalMb)}',
          ),
          ListCard(
            children: <Widget>[
              for (final item in done) _DoneRow(item: item, state: state),
            ],
          ),
          _StorageCard(totalMb: totalMb),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.items});

  final List<DownloadItem> items;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final item = items.isEmpty ? null : items.first;
    final track = item == null ? null : MockData.trackById(item.trackId);
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppLayout.screenMargin,
        4,
        AppLayout.screenMargin,
        2,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          ProgressRing(value: item?.progress ?? 0),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item == null
                      ? 'No active downloads'
                      : items.length == 1
                      ? '1 active download'
                      : '${items.length} active downloads',
                  style: context.texts.titleSmall?.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 2),
                Text(
                  item == null || track == null
                      ? 'All tracks are offline'
                      : '${track.title} · '
                            '${(item.sizeMb * item.progress).toStringAsFixed(1)} MB / '
                            '${formatMegabytes(item.sizeMb)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.texts.bodySmall?.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RunningRow extends StatelessWidget {
  const _RunningRow({required this.item});

  final DownloadItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final track = MockData.trackById(item.trackId);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: <Widget>[
          Artwork(
            index: track.artIndex,
            size: 50,
            borderRadius: BorderRadius.circular(6),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  track.title,
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
                  '${track.artist} · ${item.bitrate} ${item.format}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.texts.bodySmall?.copyWith(fontSize: 12),
                ),
                const SizedBox(height: 7),
                LinearProgress(value: item.progress, height: 3),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${(item.progress * 100).round()}%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colors.accent,
              fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

class _DoneRow extends StatelessWidget {
  const _DoneRow({required this.item, required this.state});

  final DownloadItem item;
  final MockState state;

  @override
  Widget build(BuildContext context) {
    final track = MockData.trackById(item.trackId);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: <Widget>[
          Artwork(
            index: track.artIndex,
            size: 50,
            borderRadius: BorderRadius.circular(6),
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
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.35,
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
                  '${item.bitrate} ${item.format} · '
                  '${formatMegabytes(item.sizeMb)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.texts.bodySmall?.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          IconHit(
            icon: CupertinoIcons.play_fill,
            size: 18,
            onTap: () {
              state.selectTrack(track);
              Navigator.of(
                context,
              ).push(mockSheetRoute(const NowPlayingScreen()));
            },
            semanticLabel: 'Play ${track.title}',
          ),
        ],
      ),
    );
  }
}

class _StorageCard extends StatelessWidget {
  const _StorageCard({required this.totalMb});

  final double totalMb;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppLayout.screenMargin,
        14,
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
            'Storage',
            style: context.texts.titleSmall?.copyWith(fontSize: 15),
          ),
          const SizedBox(height: 3),
          Text(
            'Music/CloudThought · ${formatMegabytes(totalMb)} used',
            style: context.texts.bodySmall,
          ),
          const SizedBox(height: 12),
          LinearProgress(value: (totalMb / 2048).clamp(0.02, 1), height: 6),
          const SizedBox(height: 7),
          Row(
            children: <Widget>[
              Text(
                formatMegabytes(totalMb),
                style: context.texts.labelSmall?.copyWith(
                  letterSpacing: 0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              Text(
                '2 GB cache limit',
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
