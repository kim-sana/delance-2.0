import 'package:flutter/material.dart';

import '../../core/layout.dart';
import '../../core/navigation.dart';
import '../../mock/mock_data.dart';
import '../../mock/mock_state.dart';
import '../../mock/mock_target.dart';
import '../artist/artist_screen.dart';
import '../capsule/capsule_screen.dart';
import '../downloads/downloads_screen.dart';
import '../home/home_screen.dart';
import '../library/library_screen.dart';
import '../player/now_playing_screen.dart';
import '../playlist/playlist_screen.dart';
import '../search/search_screen.dart';
import '../settings/settings_screen.dart';
import 'app_tab_bar.dart';
import 'mini_player.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key, required this.target});

  final MockTarget target;

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _applyTarget();
  }

  void _applyTarget() {
    switch (widget.target.screen) {
      case 'home':
        _index = 0;
        return;
      case 'search':
        _index = 1;
        return;
      case 'library':
        _index = 2;
        return;
      default:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _pushTarget(widget.target.screen);
        });
    }
  }

  void _pushTarget(String screen) {
    final Route<dynamic>? route = switch (screen) {
      'downloads' => mockPushRoute(const DownloadsScreen()),
      'capsule' => mockPushRoute(const CapsuleScreen()),
      'artist' => mockPushRoute(const ArtistScreen()),
      'playlist' => mockPushRoute(
        PlaylistScreen(playlist: MockData.playlistById('late-night')),
      ),
      'settings' => mockPushRoute(const SettingsScreen()),
      'nowplaying' => mockSheetRoute(const NowPlayingScreen()),
      'lyrics' => mockSheetRoute(
        const NowPlayingScreen(openLyricsInitially: true),
      ),
      'queue' => mockSheetRoute(
        const NowPlayingScreen(openQueueInitially: true),
      ),
      _ => null,
    };
    if (route != null) {
      Navigator.of(context).push(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = MockScope.of(context);
    final tabs = <Widget>[
      const HomeScreen(),
      const SearchScreen(),
      const LibraryScreen(),
    ];
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: KeyedSubtree(
                key: ValueKey<int>(_index),
                child: tabs[_index],
              ),
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: AppLayout.miniPlayerBottom(context),
            child: MiniPlayer(
              track: state.currentTrack,
              isPlaying: state.isPlaying,
              onOpen: () => Navigator.of(
                context,
              ).push(mockSheetRoute(const NowPlayingScreen())),
              onPlay: state.togglePlay,
              onNext: state.nextTrack,
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: AppLayout.tabBarBottom(context),
            child: AppTabBar(
              index: _index,
              onTab: (index) => setState(() => _index = index),
              onSearch: () => setState(() => _index = 1),
            ),
          ),
        ],
      ),
    );
  }
}
