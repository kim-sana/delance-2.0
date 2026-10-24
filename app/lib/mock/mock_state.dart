import 'package:flutter/material.dart';

import 'mock_data.dart';
import 'models.dart';

class MockState extends ChangeNotifier {
  MockState({ThemeMode? initialThemeMode})
    : _themeMode = initialThemeMode ?? ThemeMode.system;

  ThemeMode _themeMode;
  Track _currentTrack = MockData.tracks[3];
  bool _isPlaying = true;
  double _positionSeconds = 84;
  double _volume = 72;

  final Set<String> _savedTrackIds = <String>{'cloud-thought'};
  final Set<String> _downloadedTrackIds = <String>{
    'cloud-thought',
    'paper-heart',
    'neon-echo',
    'victory-lap',
  };

  ThemeMode get themeMode => _themeMode;
  Track get currentTrack => _currentTrack;
  bool get isPlaying => _isPlaying;
  double get positionSeconds => _positionSeconds;
  double get volume => _volume;
  int get durationSeconds => _currentTrack.durationSeconds;
  List<Track> get queue => MockData.tracks;

  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
  }

  void togglePlay() {
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void selectTrack(Track track, {bool autoplay = true}) {
    _currentTrack = track;
    _positionSeconds = 0;
    _isPlaying = autoplay;
    notifyListeners();
  }

  void selectTrackById(String id) {
    selectTrack(MockData.trackById(id));
  }

  void nextTrack() {
    final index = MockData.tracks.indexOf(_currentTrack);
    final next = MockData.tracks[(index + 1) % MockData.tracks.length];
    selectTrack(next);
  }

  void previousTrack() {
    if (_positionSeconds > 4) {
      _positionSeconds = 0;
      notifyListeners();
      return;
    }
    final index = MockData.tracks.indexOf(_currentTrack);
    final previous = MockData
        .tracks[(index - 1 + MockData.tracks.length) % MockData.tracks.length];
    selectTrack(previous);
  }

  void setPosition(double seconds) {
    _positionSeconds = seconds.clamp(0, durationSeconds.toDouble());
    notifyListeners();
  }

  void setVolume(double value) {
    _volume = value.clamp(0, 100);
    notifyListeners();
  }

  bool isSaved(String trackId) => _savedTrackIds.contains(trackId);

  void toggleSaved(String trackId) {
    if (!_savedTrackIds.remove(trackId)) {
      _savedTrackIds.add(trackId);
    }
    notifyListeners();
  }

  bool isDownloaded(String trackId) {
    return _downloadedTrackIds.contains(trackId);
  }
}

class MockScope extends InheritedNotifier<MockState> {
  const MockScope({super.key, required MockState state, required super.child})
    : super(notifier: state);

  static MockState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<MockScope>();
    assert(scope != null, 'MockScope tidak ditemukan di widget tree.');
    return scope!.notifier!;
  }
}
