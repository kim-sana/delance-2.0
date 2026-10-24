import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/layout.dart';
import '../../core/navigation.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_icons.dart';
import '../../core/widgets/app_slider.dart';
import '../../core/widgets/artwork.dart';
import '../../core/widgets/badges.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/equalizer.dart';
import '../../core/widgets/pressable.dart';
import '../../mock/mock_data.dart';
import '../../mock/mock_state.dart';
import '../../mock/models.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({
    super.key,
    this.openLyricsInitially = false,
    this.openQueueInitially = false,
  });

  final bool openLyricsInitially;
  final bool openQueueInitially;

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  late bool _lyricsOpen = widget.openLyricsInitially;
  bool _shuffle = false;
  bool _repeat = false;
  int _lyricsMode = 0;
  int _lastActiveLyric = -1;
  final ScrollController _lyricsScroll = ScrollController();
  final List<GlobalKey> _lyricKeys = <GlobalKey>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.openQueueInitially) _openQueue();
    });
  }

  @override
  void dispose() {
    _lyricsScroll.dispose();
    super.dispose();
  }

  void _openLyrics() {
    setState(() => _lyricsOpen = true);
  }

  Future<void> _openQueue() {
    final state = MockScope.of(context);
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.42),
      builder: (sheetContext) {
        return SizedBox(
          height: MediaQuery.sizeOf(sheetContext).height * 0.62,
          child: _QueueSheet(state: state),
        );
      },
    );
  }

  void _scheduleLyricScroll(int activeIndex) {
    if (activeIndex < 0 || activeIndex >= _lyricKeys.length) return;
    final lineContext = _lyricKeys[activeIndex].currentContext;
    if (lineContext == null) return;
    Scrollable.ensureVisible(
      lineContext,
      alignment: 0.5,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }

  static int _activeLyricIndex(List<LyricLine> lines, double position) {
    var index = -1;
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].timeSeconds <= position) {
        index = i;
      } else {
        break;
      }
    }
    return index;
  }

  @override
  Widget build(BuildContext context) {
    final state = MockScope.of(context);
    final track = state.currentTrack;
    final lines = MockData.lyricsFor(track.id);
    final tint = Color(track.tint);
    final activeIndex = _activeLyricIndex(lines, state.positionSeconds);
    if (_lyricKeys.length != lines.length) {
      _lyricKeys
        ..clear()
        ..addAll(
          List<GlobalKey>.generate(
            lines.length,
            (index) => GlobalKey(debugLabel: 'lyric-$index'),
          ),
        );
    }
    if (_lyricsOpen && activeIndex != _lastActiveLyric) {
      _lastActiveLyric = activeIndex;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _scheduleLyricScroll(activeIndex);
      });
    }

    return PopScope(
      canPop: !_lyricsOpen,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _lyricsOpen) {
          setState(() => _lyricsOpen = false);
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: <Widget>[
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        Color.lerp(tint, Colors.black, 0.18)!,
                        Color.lerp(tint, Colors.black, 0.62)!,
                        Colors.black,
                      ],
                      stops: const <double>[0, 0.52, 1],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final artSize =
                        constraints.maxWidth - AppLayout.screenMargin * 2;
                    return SingleChildScrollView(
                      key: const Key('screen-nowplaying'),
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(
                        top: AppLayout.safeTop(context),
                        bottom: AppLayout.safeBottom(context) + 8,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppLayout.screenMargin,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            _Head(
                              onClose: () => Navigator.of(context).maybePop(),
                              onMenu: () => showMockSnack(
                                context,
                                'Mockup: player menu not built',
                              ),
                            ),
                            const SizedBox(height: 6),
                            _ArtworkShadow(
                              size: artSize,
                              index: track.artIndex,
                            ),
                            const SizedBox(height: 18),
                            _TrackMeta(
                              track: track,
                              saved: state.isSaved(track.id),
                              onSave: () => state.toggleSaved(track.id),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: <Widget>[
                                if (track.genre != null)
                                  TagChip(
                                    label: track.genre!,
                                    uppercase: false,
                                    color: Colors.white.withValues(alpha: 0.78),
                                    borderColor: Colors.white.withValues(
                                      alpha: 0.26,
                                    ),
                                  ),
                                if (track.bpm != null)
                                  TagChip(
                                    label: '${track.bpm} BPM',
                                    uppercase: false,
                                    color: Colors.white.withValues(alpha: 0.78),
                                    borderColor: Colors.white.withValues(
                                      alpha: 0.26,
                                    ),
                                  ),
                                if (track.codec != null)
                                  TagChip(
                                    label: track.codec!,
                                    uppercase: false,
                                    color: Colors.white.withValues(alpha: 0.78),
                                    borderColor: Colors.white.withValues(
                                      alpha: 0.26,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            AppSlider(
                              value: state.positionSeconds,
                              max: state.durationSeconds.toDouble(),
                              onChanged: state.setPosition,
                              activeColor: Colors.white,
                              inactiveColor: Colors.white.withValues(
                                alpha: 0.24,
                              ),
                              thumbColor: Colors.white,
                              height: 24,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    formatSeconds(
                                      state.positionSeconds.round(),
                                    ),
                                    style: _timeStyle,
                                  ),
                                  const Spacer(),
                                  Text(
                                    formatSeconds(state.durationSeconds),
                                    style: _timeStyle,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            _Controls(
                              isPlaying: state.isPlaying,
                              tint: tint,
                              shuffle: _shuffle,
                              repeat: _repeat,
                              onShuffle: () =>
                                  setState(() => _shuffle = !_shuffle),
                              onRepeat: () =>
                                  setState(() => _repeat = !_repeat),
                              onPrevious: state.previousTrack,
                              onPlay: state.togglePlay,
                              onNext: state.nextTrack,
                            ),
                            const SizedBox(height: 6),
                            _VolumeBlock(
                              value: state.volume,
                              onChanged: state.setVolume,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 2, 32, 4),
                              child: Text(
                                'App volume — doesn\'t affect notifications '
                                'or calls.',
                                style: TextStyle(
                                  fontSize: 11,
                                  height: 1.35,
                                  color: Colors.white.withValues(alpha: 0.50),
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                IconHit(
                                  icon: CupertinoIcons.text_alignleft,
                                  size: 20,
                                  color: Colors.white,
                                  semanticLabel: 'Lyrics',
                                  onTap: _openLyrics,
                                ),
                                IconHit(
                                  icon: CupertinoIcons.list_bullet,
                                  size: 20,
                                  color: Colors.white.withValues(alpha: 0.78),
                                  semanticLabel: 'Queue',
                                  onTap: _openQueue,
                                ),
                                Pressable(
                                  onTap: () => showMockSnack(
                                    context,
                                    'Mockup: audio output selection not built',
                                  ),
                                  semanticLabel: 'Audio output',
                                  child: SizedBox.square(
                                    dimension: 44,
                                    child: Center(
                                      child: AirplayIcon(
                                        size: 20,
                                        color: Colors.white.withValues(
                                          alpha: 0.78,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: !_lyricsOpen,
                  child: AnimatedSlide(
                    offset: _lyricsOpen ? Offset.zero : const Offset(0, 1),
                    duration: const Duration(milliseconds: 500),
                    curve: mockSheetCurve,
                    child: _LyricsPane(
                      track: track,
                      lines: lines,
                      lyricKeys: _lyricKeys,
                      tint: tint,
                      mode: _lyricsMode,
                      activeIndex: activeIndex,
                      scrollController: _lyricsScroll,
                      onModeChanged: (mode) => setState(() {
                        _lyricsMode = mode;
                        _lastActiveLyric = -1;
                      }),
                      onClose: () => setState(() => _lyricsOpen = false),
                      onSeek: (seconds) =>
                          state.setPosition(seconds.toDouble()),
                      onMenu: () => showMockSnack(
                        context,
                        'Mockup: lyrics menu not built',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const TextStyle _timeStyle = TextStyle(
  fontSize: 11,
  height: 1.3,
  color: Color(0x9EFFFFFF),
  fontFeatures: <FontFeature>[FontFeature.tabularFigures()],
);

class _Head extends StatelessWidget {
  const _Head({required this.onClose, required this.onMenu});

  final VoidCallback onClose;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        GlassButton(
          icon: CupertinoIcons.chevron_down,
          onTap: onClose,
          semanticLabel: 'Close player',
        ),
        Expanded(
          child: Text(
            'NOW PLAYING',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: Colors.white.withValues(alpha: 0.66),
            ),
          ),
        ),
        GlassButton(
          icon: CupertinoIcons.ellipsis,
          onTap: onMenu,
          semanticLabel: 'Player menu',
        ),
      ],
    );
  }
}

class _ArtworkShadow extends StatelessWidget {
  const _ArtworkShadow({required this.size, required this.index});

  final double size;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.45),
              blurRadius: 60,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Artwork(
          index: index,
          borderRadius: BorderRadius.circular(14),
          showGlyph: true,
          glyphOpacity: 0.10,
        ),
      ),
    );
  }
}

class _TrackMeta extends StatelessWidget {
  const _TrackMeta({
    required this.track,
    required this.saved,
    required this.onSave,
  });

  final Track track;
  final bool saved;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                track.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                  letterSpacing: -0.3,
                  color: Colors.white,
                ),
              ),
              Text(
                track.artist,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.3,
                  color: Colors.white.withValues(alpha: 0.72),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        SaveButton(
          saved: saved,
          onTap: onSave,
          color: Colors.white.withValues(alpha: 0.70),
        ),
      ],
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({
    required this.isPlaying,
    required this.tint,
    required this.shuffle,
    required this.repeat,
    required this.onShuffle,
    required this.onRepeat,
    required this.onPrevious,
    required this.onPlay,
    required this.onNext,
  });

  final bool isPlaying;
  final Color tint;
  final bool shuffle;
  final bool repeat;
  final VoidCallback onShuffle;
  final VoidCallback onRepeat;
  final VoidCallback onPrevious;
  final VoidCallback onPlay;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconHit(
          icon: CupertinoIcons.shuffle,
          size: 20,
          hitSize: 40,
          color: Colors.white.withValues(alpha: shuffle ? 1 : 0.50),
          onTap: onShuffle,
          semanticLabel: 'Shuffle',
        ),
        IconHit(
          icon: CupertinoIcons.backward_end_fill,
          size: 26,
          hitSize: 46,
          color: Colors.white,
          onTap: onPrevious,
          semanticLabel: 'Previous',
        ),
        Pressable(
          key: const Key('np-play'),
          onTap: onPlay,
          semanticLabel: isPlaying ? 'Pause' : 'Play',
          child: Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPlaying ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill,
              size: 23,
              color: Color.lerp(tint, Colors.black, 0.35),
            ),
          ),
        ),
        IconHit(
          icon: CupertinoIcons.forward_end_fill,
          size: 26,
          hitSize: 46,
          color: Colors.white,
          onTap: onNext,
          semanticLabel: 'Next',
        ),
        IconHit(
          icon: CupertinoIcons.repeat,
          size: 20,
          hitSize: 40,
          color: Colors.white.withValues(alpha: repeat ? 1 : 0.50),
          onTap: onRepeat,
          semanticLabel: 'Repeat',
        ),
      ],
    );
  }
}

class _VolumeBlock extends StatelessWidget {
  const _VolumeBlock({required this.value, required this.onChanged});

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          CupertinoIcons.speaker_1,
          size: 16,
          color: Colors.white.withValues(alpha: 0.70),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AppSlider(
            value: value,
            max: 100,
            onChanged: onChanged,
            activeColor: Colors.white.withValues(alpha: 0.92),
            inactiveColor: Colors.white.withValues(alpha: 0.24),
            thumbColor: Colors.white,
            height: 26,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 32,
          child: Text(
            formatVolume(value),
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.72),
              fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
            ),
          ),
        ),
      ],
    );
  }
}

class _LyricsPane extends StatelessWidget {
  const _LyricsPane({
    required this.track,
    required this.lines,
    required this.lyricKeys,
    required this.tint,
    required this.mode,
    required this.activeIndex,
    required this.scrollController,
    required this.onModeChanged,
    required this.onClose,
    required this.onSeek,
    required this.onMenu,
  });

  final Track track;
  final List<LyricLine> lines;
  final List<GlobalKey> lyricKeys;
  final Color tint;
  final int mode;
  final int activeIndex;
  final ScrollController scrollController;
  final ValueChanged<int> onModeChanged;
  final VoidCallback onClose;
  final ValueChanged<int> onSeek;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    final hasRomanization = lines.any((line) => line.romanization != null);
    return DecoratedBox(
      key: const Key('lyrics-pane'),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color.lerp(tint, Colors.black, 0.38)!,
            Color.lerp(tint, Colors.black, 0.68)!,
            Colors.black,
          ],
        ),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(height: AppLayout.safeTop(context)),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppLayout.screenMargin,
              4,
              AppLayout.screenMargin,
              8,
            ),
            child: Row(
              children: <Widget>[
                GlassButton(
                  icon: CupertinoIcons.chevron_down,
                  onTap: onClose,
                  semanticLabel: 'Close lyrics',
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        track.title.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          color: Colors.white.withValues(alpha: 0.66),
                        ),
                      ),
                      const Text(
                        'Lyrics',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                GlassButton(
                  icon: CupertinoIcons.ellipsis,
                  onTap: onMenu,
                  semanticLabel: 'Lyrics menu',
                ),
              ],
            ),
          ),
          if (lines.isNotEmpty && mode != 0 && !hasRomanization)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppLayout.screenMargin,
                0,
                AppLayout.screenMargin,
                8,
              ),
              child: Text(
                "Romanization isn't available for this track.",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.55),
                ),
              ),
            ),
          Expanded(
            child: lines.isEmpty
                ? const _NoLyrics()
                : ShaderMask(
                    shaderCallback: (Rect bounds) => const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.transparent,
                        Colors.white,
                        Colors.white,
                        Colors.transparent,
                      ],
                      stops: <double>[0, 0.12, 0.78, 1],
                    ).createShader(bounds),
                    blendMode: BlendMode.dstIn,
                    child: SingleChildScrollView(
                      key: const Key('lyrics-list'),
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        AppLayout.screenMargin,
                        20,
                        AppLayout.screenMargin,
                        MediaQuery.sizeOf(context).height * 0.40,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          for (var index = 0; index < lines.length; index++)
                            _lineWidget(index),
                        ],
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppLayout.screenMargin,
              10,
              AppLayout.screenMargin,
              AppLayout.safeBottom(context) + 6,
            ),
            child: Row(
              children: <Widget>[
                _LyricsSegmented(value: mode, onChanged: onModeChanged),
                const Spacer(),
                TagChip(
                  label: 'LRCLIB',
                  uppercase: false,
                  color: Colors.white.withValues(alpha: 0.60),
                  borderColor: Colors.white.withValues(alpha: 0.22),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _lineWidget(int index) {
    final line = lines[index];
    final active = index == activeIndex;
    if (line.isSection) {
      return Padding(
        key: lyricKeys[index],
        padding: EdgeInsets.only(top: index == 0 ? 0 : 20, bottom: 8),
        child: Text(
          line.text.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.9,
            color: Colors.white.withValues(alpha: 0.50),
          ),
        ),
      );
    }
    final mainText = mode == 1 ? (line.romanization ?? line.text) : line.text;
    return GestureDetector(
      key: lyricKeys[index],
      onTap: () => onSeek(line.timeSeconds),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: AnimatedScale(
          scale: active ? 1.02 : 1,
          alignment: Alignment.centerLeft,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                  letterSpacing: -0.4,
                  color: active
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.36),
                ),
                child: Text(mainText),
              ),
              if (mode == 2 && line.romanization != null) ...<Widget>[
                const SizedBox(height: 4),
                Text(
                  line.romanization!,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                    color: Colors.white.withValues(alpha: active ? 0.80 : 0.55),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _NoLyrics extends StatelessWidget {
  const _NoLyrics();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              CupertinoIcons.text_quote,
              size: 30,
              color: Colors.white.withValues(alpha: 0.50),
            ),
            const SizedBox(height: 12),
            const Text(
              'Lyrics not available',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "This track doesn't have synced lyrics yet. Try Cloud Thought "
              'to see a sample.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.45,
                color: Colors.white.withValues(alpha: 0.55),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LyricsSegmented extends StatelessWidget {
  const _LyricsSegmented({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  static const List<String> _labels = <String>['Original', 'Romaji', 'Both'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (var i = 0; i < _labels.length; i++)
            GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: i == value
                      ? Colors.white.withValues(alpha: 0.92)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _labels[i],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: i == value
                        ? Colors.black
                        : Colors.white.withValues(alpha: 0.70),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _QueueSheet extends StatelessWidget {
  const _QueueSheet({required this.state});

  final MockState state;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final queue = state.queue;
    final currentIndex = queue.indexOf(state.currentTrack);
    final items = <Track>[
      for (var i = 0; i < 6; i++) queue[(currentIndex + i) % queue.length],
    ];
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Material(
        color: colors.bgSecondary,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 5,
              decoration: BoxDecoration(
                color: colors.labelTertiary,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
              child: Row(
                children: <Widget>[
                  Text(
                    'Up Next',
                    style: context.texts.titleMedium?.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => showMockSnack(
                      context,
                      'Mockup: queue is not actually cleared',
                    ),
                    child: Text(
                      'Clear all',
                      style: TextStyle(fontSize: 14, color: colors.accent),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final track = items[index];
                  final current = track.id == state.currentTrack.id;
                  return Pressable(
                    onTap: () {
                      state.selectTrack(track);
                      Navigator.of(context).pop();
                    },
                    semanticLabel: '${track.title} by ${track.artist}',
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 60),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      child: Row(
                        children: <Widget>[
                          Artwork(
                            index: track.artIndex,
                            size: 44,
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
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          height: 1.35,
                                          color: current
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
                                Text(
                                  '${track.artist} · ${track.genre ?? 'Song'}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.texts.bodySmall?.copyWith(
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (current)
                            Equalizer(paused: !state.isPlaying)
                          else
                            Icon(
                              CupertinoIcons.line_horizontal_3,
                              size: 16,
                              color: colors.labelTertiary,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
