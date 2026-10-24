import 'package:flutter/cupertino.dart';

import '../../core/layout.dart';
import '../../core/navigation.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_avatar.dart';
import '../../core/widgets/artwork.dart';
import '../../core/widgets/headers.dart';
import '../../core/widgets/list_card.dart';
import '../../core/widgets/pressable.dart';
import '../../mock/mock_data.dart';
import '../../mock/mock_state.dart';
import '../../mock/models.dart';
import '../artist/artist_screen.dart';
import '../capsule/capsule_screen.dart';
import '../downloads/downloads_screen.dart';
import '../playlist/playlist_screen.dart';
import '../settings/settings_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = MockScope.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth =
            (constraints.maxWidth - AppLayout.screenMargin * 2 - 14) / 2;
        return ListView(
          key: const Key('screen-library'),
          padding: EdgeInsets.only(
            top: AppLayout.safeTop(context),
            bottom: AppLayout.scrollClearance(context),
          ),
          children: <Widget>[
            LargeTitleHeader(
              title: 'Library',
              trailing: AppAvatar(
                onTap: () =>
                    showMockSnack(context, 'Mockup: profile screen not built'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppLayout.screenMargin,
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: MockData.libraryTiles.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: tileWidth / (tileWidth + 62),
                ),
                itemBuilder: (context, index) {
                  final tile = MockData.libraryTiles[index];
                  return _LibraryTile(
                    tile: tile,
                    onTap: () => _openTile(context, tile.playlistId),
                  );
                },
              ),
            ),
            const FieldLabel(title: 'Collection'),
            ListCard(
              children: <Widget>[
                ListRow(
                  title: 'Capsule',
                  subtitle: '3 months saved',
                  icon: CupertinoIcons.archivebox,
                  accentIcon: true,
                  showChevron: true,
                  onTap: () => Navigator.of(
                    context,
                  ).push(mockPushRoute(const CapsuleScreen())),
                ),
                ListRow(
                  title: 'Downloads',
                  subtitle: '4 songs · 1 in progress',
                  icon: CupertinoIcons.arrow_down_to_line,
                  showChevron: true,
                  onTap: () => Navigator.of(
                    context,
                  ).push(mockPushRoute(const DownloadsScreen())),
                ),
                ListRow(
                  title: 'My playlists',
                  subtitle: '6 playlists',
                  icon: CupertinoIcons.music_note_list,
                  showChevron: true,
                  onTap: () => Navigator.of(context).push(
                    mockPushRoute(
                      PlaylistScreen(
                        playlist: MockData.playlistById('late-night'),
                      ),
                    ),
                  ),
                ),
                ListRow(
                  title: 'Listening history',
                  subtitle: 'Tracking on',
                  icon: CupertinoIcons.clock,
                  showChevron: true,
                  onTap: () => showMockSnack(
                    context,
                    'Mockup: listening history not built',
                  ),
                ),
              ],
            ),
            const FieldLabel(title: 'Quick settings'),
            ListCard(
              children: <Widget>[
                ListRow(
                  title: 'App volume',
                  subtitle: 'Separate from system volume',
                  icon: CupertinoIcons.speaker_2,
                  trailing: Text(
                    formatVolume(state.volume),
                    style: context.texts.labelLarge?.copyWith(
                      fontSize: 14,
                      color: context.colors.labelSecondary,
                    ),
                  ),
                  onTap: () => Navigator.of(
                    context,
                  ).push(mockPushRoute(const SettingsScreen())),
                ),
                ListRow(
                  title: 'Download on Wi-Fi only',
                  subtitle: 'Save mobile data',
                  icon: CupertinoIcons.wifi,
                  trailing: Text(
                    'On',
                    style: context.texts.labelLarge?.copyWith(
                      fontSize: 14,
                      color: context.colors.labelSecondary,
                    ),
                  ),
                ),
                ListRow(
                  title: 'Download quality',
                  subtitle: 'Opus 160 kbps',
                  icon: CupertinoIcons.square_stack,
                  showChevron: true,
                  onTap: () => Navigator.of(
                    context,
                  ).push(mockPushRoute(const SettingsScreen())),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _openTile(BuildContext context, String playlistId) {
    if (playlistId == 'artist') {
      Navigator.of(context).push(mockPushRoute(const ArtistScreen()));
      return;
    }
    Navigator.of(context).push(
      mockPushRoute(
        PlaylistScreen(playlist: MockData.playlistById(playlistId)),
      ),
    );
  }
}

class _LibraryTile extends StatelessWidget {
  const _LibraryTile({required this.tile, required this.onTap});

  final LibraryTileData tile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Pressable(
      onTap: onTap,
      semanticLabel: tile.label,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: colors.bgSecondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: Artwork(
                index: tile.artIndex,
                borderRadius: BorderRadius.zero,
                glyphOpacity: 0.10,
                showGlyph: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    tile.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.texts.titleSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    tile.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.texts.labelMedium?.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
