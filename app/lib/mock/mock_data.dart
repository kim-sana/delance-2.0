import 'models.dart';

abstract final class MockData {
  static const List<Track> tracks = <Track>[
    Track(
      id: 'dis-badman',
      title: 'Dis Badman',
      artist: 'Sammy Virji, Champion & IRAH',
      album: 'Today\'s Hits',
      artIndex: 4,
      tint: 0xFF2B3339,
      durationSeconds: 198,
      source: TrackSource.youtube,
      genre: 'UK Garage',
      bpm: 134,
      codec: 'Opus 160',
    ),
    Track(
      id: 'victory-lap',
      title: 'Victory Lap Four',
      artist: 'Fred again.., Skepta, PlaqueBoyMax',
      album: 'Today\'s Hits',
      artIndex: 5,
      tint: 0xFF3A1614,
      durationSeconds: 225,
      source: TrackSource.youtube,
      genre: 'Hip-Hop',
      bpm: 140,
      codec: 'Opus 161',
      explicit: true,
    ),
    Track(
      id: 'espiritu',
      title: 'ESPÍRITU',
      artist: 'Jotaerre',
      album: 'Today\'s Hits',
      artIndex: 6,
      tint: 0xFF0C2E28,
      durationSeconds: 187,
      source: TrackSource.local,
      genre: 'Reggaeton',
      bpm: 96,
      codec: 'Opus 160',
      explicit: true,
    ),
    Track(
      id: 'cloud-thought',
      title: 'Cloud Thought',
      artist: 'AI Singer',
      album: 'Cloud Thought',
      artIndex: 7,
      tint: 0xFF39414A,
      durationSeconds: 222,
      source: TrackSource.local,
      genre: 'Lo-Fi',
      bpm: 90,
      codec: 'Opus 160',
    ),
    Track(
      id: 'midnight-echo',
      title: 'Midnight Echo',
      artist: 'Aria Lune',
      album: 'Never Ever',
      artIndex: 8,
      tint: 0xFF2E163E,
      durationSeconds: 241,
      source: TrackSource.youtube,
      genre: 'Dream-pop',
      bpm: 105,
      codec: 'AAC 128',
    ),
    Track(
      id: 'neon-echo',
      title: 'Neon Echo',
      artist: 'Electronic',
      album: 'Late Night Drive',
      artIndex: 9,
      tint: 0xFF0F3244,
      durationSeconds: 214,
      source: TrackSource.local,
      genre: 'Electronic',
      bpm: 128,
      codec: '320k',
    ),
    Track(
      id: 'paper-heart',
      title: 'Paper Heart',
      artist: 'Pop',
      album: 'Paper Skies',
      artIndex: 10,
      tint: 0xFF3D1A05,
      durationSeconds: 176,
      source: TrackSource.local,
      genre: 'Pop',
      bpm: 105,
      codec: '320k',
    ),
    Track(
      id: 'schizo',
      title: 'Schizo (And The Little Girl)',
      artist: 'Schizo',
      album: 'Schizo',
      artIndex: 11,
      tint: 0xFF111820,
      durationSeconds: 205,
      source: TrackSource.youtube,
      genre: 'Alternative',
      bpm: 118,
      codec: 'AAC 128',
    ),
    Track(
      id: 'golden-hour',
      title: 'Golden Hour',
      artist: 'Aria Lune',
      album: 'Never Ever',
      artIndex: 2,
      tint: 0xFF2D1B69,
      durationSeconds: 232,
      source: TrackSource.youtube,
      genre: 'Dream-pop',
      bpm: 92,
      codec: 'Opus 160',
    ),
    Track(
      id: 'afterglow',
      title: 'Afterglow',
      artist: 'The Velvet Waves',
      album: 'Never Ever',
      artIndex: 3,
      tint: 0xFF3A1E12,
      durationSeconds: 218,
      source: TrackSource.youtube,
      genre: 'Indie',
      bpm: 110,
      codec: 'Opus 160',
    ),
    Track(
      id: 'paper-planes',
      title: 'Paper Planes',
      artist: 'Aria Lune',
      album: 'Paper Skies',
      artIndex: 1,
      tint: 0xFF2B2118,
      durationSeconds: 204,
      source: TrackSource.local,
      genre: 'Dream-pop',
      bpm: 96,
      codec: 'Opus 160',
    ),
    Track(
      id: 'slow-static',
      title: 'Slow Static',
      artist: 'AI Singer',
      album: 'Cloud Thought',
      artIndex: 14,
      tint: 0xFF12302F,
      durationSeconds: 196,
      source: TrackSource.local,
      genre: 'Lo-Fi',
      bpm: 84,
      codec: 'Opus 160',
    ),
    Track(
      id: 'streetlight-lullaby',
      title: 'Streetlight Lullaby',
      artist: 'AI Singer',
      album: 'Cloud Thought',
      artIndex: 15,
      tint: 0xFF2A1440,
      durationSeconds: 210,
      source: TrackSource.youtube,
      genre: 'Lo-Fi',
      bpm: 88,
      codec: 'Opus 160',
    ),
    Track(
      id: 'neon-shadows',
      title: 'Neon Shadows',
      artist: 'Aria Lune',
      album: 'Afterglow',
      artIndex: 9,
      tint: 0xFF0F3244,
      durationSeconds: 201,
      source: TrackSource.youtube,
      genre: 'Dream-pop',
      bpm: 102,
      codec: 'AAC 128',
    ),
  ];

  static const List<EditorialItem> editorial = <EditorialItem>[
    EditorialItem(
      eyebrow: 'UPDATED PLAYLIST',
      title: 'Today\'s Hits',
      subtitle: 'Fresh finds, updated daily',
      caption: 'Streaming straight from YouTube — no ads, no account needed.',
      artIndex: 1,
    ),
    EditorialItem(
      eyebrow: 'NEW ALBUM',
      title: 'Never Ever',
      subtitle: 'The Velvet Waves',
      caption: 'Tap download to keep it offline at 160 kbps Opus.',
      artIndex: 2,
    ),
    EditorialItem(
      eyebrow: 'NEW SINGLE',
      title: 'Midnight Echo',
      subtitle: 'Aria Lune',
      caption: 'Synced lyrics available in original and romanized.',
      artIndex: 3,
    ),
  ];

  static const List<String> latestSongIds = <String>[
    'dis-badman',
    'victory-lap',
    'espiritu',
    'cloud-thought',
    'midnight-echo',
    'neon-echo',
    'paper-heart',
    'schizo',
  ];

  static const List<LibraryTileData> libraryTiles = <LibraryTileData>[
    LibraryTileData(
      label: 'Songs',
      subtitle: '128 songs · 4 offline',
      artIndex: 4,
      playlistId: 'all-songs',
    ),
    LibraryTileData(
      label: 'Albums',
      subtitle: '23 albums',
      artIndex: 2,
      playlistId: 'never-ever',
    ),
    LibraryTileData(
      label: 'Artists',
      subtitle: '41 artists',
      artIndex: 3,
      playlistId: 'artist',
    ),
    LibraryTileData(
      label: 'Playlist',
      subtitle: '6 playlists',
      artIndex: 9,
      playlistId: 'late-night',
    ),
  ];

  static const List<PlaylistData> playlists = <PlaylistData>[
    PlaylistData(
      id: 'all-songs',
      title: 'All Songs',
      description: '128 songs on device and YouTube',
      artIndex: 4,
      trackIds: <String>[
        'dis-badman',
        'victory-lap',
        'espiritu',
        'cloud-thought',
        'midnight-echo',
        'neon-echo',
        'paper-heart',
        'schizo',
        'golden-hour',
        'afterglow',
        'paper-planes',
        'slow-static',
        'streetlight-lullaby',
        'neon-shadows',
      ],
    ),
    PlaylistData(
      id: 'never-ever',
      title: 'Never Ever',
      description: 'The Velvet Waves · 2026',
      artIndex: 2,
      trackIds: <String>[
        'afterglow',
        'golden-hour',
        'paper-planes',
        'paper-heart',
        'neon-echo',
      ],
    ),
    PlaylistData(
      id: 'late-night',
      title: 'Late Night Drive',
      description: 'Late-night curation for long drives',
      artIndex: 9,
      trackIds: <String>[
        'midnight-echo',
        'neon-echo',
        'schizo',
        'cloud-thought',
        'dis-badman',
        'victory-lap',
      ],
    ),
    PlaylistData(
      id: 'today-hits',
      title: 'Today\'s Hits',
      description: 'Fresh finds, updated daily',
      artIndex: 1,
      trackIds: <String>[
        'dis-badman',
        'victory-lap',
        'espiritu',
        'cloud-thought',
        'midnight-echo',
        'neon-echo',
        'paper-heart',
        'schizo',
      ],
    ),
    PlaylistData(
      id: 'capsule-september',
      title: 'September Capsule',
      description: '50 songs · 1,284 minutes',
      artIndex: 12,
      trackIds: <String>[
        'cloud-thought',
        'midnight-echo',
        'golden-hour',
        'paper-planes',
        'neon-echo',
        'slow-static',
        'afterglow',
        'neon-shadows',
        'schizo',
        'dis-badman',
        'victory-lap',
        'paper-heart',
      ],
      isCapsule: true,
    ),
  ];

  static const List<String> youtubeSearchIds = <String>[
    'cloud-thought',
    'midnight-echo',
    'schizo',
  ];

  static const List<String> localSearchIds = <String>[
    'paper-heart',
    'neon-echo',
  ];

  static const List<DownloadItem> downloads = <DownloadItem>[
    DownloadItem(
      trackId: 'midnight-echo',
      progress: 0.42,
      status: DownloadStatus.running,
      format: 'AAC',
      bitrate: '128 kbps',
      sizeMb: 5.7,
    ),
    DownloadItem(
      trackId: 'cloud-thought',
      progress: 1,
      status: DownloadStatus.done,
      format: 'Opus',
      bitrate: '161 kbps',
      sizeMb: 4.1,
    ),
    DownloadItem(
      trackId: 'paper-heart',
      progress: 1,
      status: DownloadStatus.done,
      format: 'MP3',
      bitrate: '320 kbps',
      sizeMb: 7.2,
    ),
    DownloadItem(
      trackId: 'neon-echo',
      progress: 1,
      status: DownloadStatus.done,
      format: 'AAC',
      bitrate: '128 kbps',
      sizeMb: 3.3,
    ),
    DownloadItem(
      trackId: 'victory-lap',
      progress: 1,
      status: DownloadStatus.done,
      format: 'Opus',
      bitrate: '161 kbps',
      sizeMb: 4.0,
    ),
  ];

  static const CapsuleData capsule = CapsuleData(
    month: 'September',
    monthYear: 'September 2026',
    minutes: 1284,
    plays: 96,
    artists: 14,
    currentMonth: 'October in progress',
    currentSubtitle: 'Unlocks November 1 · 16 of 25 valid plays',
    progress: 0.64,
    progressLeft: '16 / 25 plays',
    progressRight: '5 / 5 days',
    playlistId: 'capsule-september',
    artIndex: 12,
    entries: <CapsuleEntry>[
      CapsuleEntry(
        category: CapsuleCategory.topSong,
        title: 'Top song',
        subtitle: 'Cloud Thought · 24 plays',
      ),
      CapsuleEntry(
        category: CapsuleCategory.topArtist,
        title: 'Top artist',
        subtitle: 'Aria Lune · 312 minutes',
      ),
      CapsuleEntry(
        category: CapsuleCategory.genre,
        title: 'Top genre',
        subtitle: 'Lo-Fi 38% · Dream-pop 24%',
      ),
      CapsuleEntry(
        category: CapsuleCategory.habit,
        title: 'Habit',
        subtitle: 'Wednesday, 9:00 PM · 9-day streak',
      ),
      CapsuleEntry(
        category: CapsuleCategory.discovery,
        title: 'New discoveries',
        subtitle: '7 songs replayed ≥5×',
      ),
    ],
  );

  static const ArtistProfile artist = ArtistProfile(
    name: 'Aria Lune',
    initials: 'AL',
    bannerArtIndex: 13,
    photoArtIndex: 14,
    tags: <String>['Dream-pop', 'Lo-Fi', 'Indonesia'],
    monthlyListeners: 924000,
    bio:
        'Aria Lune is a dream-pop project weaving lo-fi textures, soft '
        'vocals, and ambient arrangements. After releasing the debut EP '
        '"Paper Skies", she became known for intimate lyrics and warm '
        'production.\n\n'
        'In 2026 she released the album "Never Ever", recorded at home '
        'and remastered for streaming. A small five-city tour is '
        'scheduled for the end of the year.',
    topTrackIds: <String>[
      'midnight-echo',
      'golden-hour',
      'paper-planes',
      'paper-heart',
    ],
    albumTitles: <String>['Never Ever', 'Paper Skies', 'Afterglow'],
    albumArtIndices: <int>[2, 15, 16],
  );

  static const List<ArtistSource> artistSources = <ArtistSource>[
    ArtistSource(label: 'TheAudioDB', detail: 'photo & banner'),
    ArtistSource(label: 'Last.fm', detail: 'tags & genre'),
    ArtistSource(label: 'Wikipedia', detail: 'biography'),
  ];

  static const Map<String, List<LyricLine>> lyrics = <String, List<LyricLine>>{
    'cloud-thought': <LyricLine>[
      LyricLine(timeSeconds: 4, text: 'Streetlights blur in the morning rain,'),
      LyricLine(timeSeconds: 12, text: 'I fold my worries into paper planes.'),
      LyricLine(timeSeconds: 20, text: 'They climb the sky in a slow parade,'),
      LyricLine(timeSeconds: 28, text: 'every little storm starts to fade.'),
      LyricLine(timeSeconds: 36, text: 'Chorus', isSection: true),
      LyricLine(timeSeconds: 40, text: 'We are cloud thoughts, drifting slow,'),
      LyricLine(timeSeconds: 48, text: 'silver linings in the afterglow.'),
      LyricLine(timeSeconds: 56, text: 'Hold the moment, let it breathe —'),
      LyricLine(timeSeconds: 64, text: 'nine-zero hearts in harmony.'),
      LyricLine(timeSeconds: 72, text: 'Verse 2', isSection: true),
      LyricLine(timeSeconds: 76, text: 'Static hums like a lullaby,'),
      LyricLine(timeSeconds: 84, text: 'neon shadows wave goodbye.'),
      LyricLine(timeSeconds: 92, text: 'I press rewind on the golden hour,'),
      LyricLine(timeSeconds: 100, text: 'soft chords blooming like a flower.'),
    ],
  };

  static Track trackById(String id) {
    return tracks.firstWhere((track) => track.id == id);
  }

  static List<Track> tracksByIds(Iterable<String> ids) {
    return ids.map(trackById).toList(growable: false);
  }

  static PlaylistData playlistById(String id) {
    return playlists.firstWhere((playlist) => playlist.id == id);
  }

  static List<LyricLine> lyricsFor(String trackId) {
    return lyrics[trackId] ?? const <LyricLine>[];
  }
}
