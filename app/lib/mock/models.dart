enum TrackSource { youtube, local }

enum DownloadStatus { running, done, failed }

enum CapsuleCategory { topSong, topArtist, genre, habit, discovery }

class Track {
  const Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.artIndex,
    required this.tint,
    required this.durationSeconds,
    required this.source,
    this.album,
    this.genre,
    this.bpm,
    this.codec,
    this.explicit = false,
  });

  final String id;
  final String title;
  final String artist;
  final String? album;
  final int artIndex;
  final int tint;
  final int durationSeconds;
  final TrackSource source;
  final String? genre;
  final int? bpm;
  final String? codec;
  final bool explicit;
}

class EditorialItem {
  const EditorialItem({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.caption,
    required this.artIndex,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final String caption;
  final int artIndex;
}

class LibraryTileData {
  const LibraryTileData({
    required this.label,
    required this.subtitle,
    required this.artIndex,
    required this.playlistId,
  });

  final String label;
  final String subtitle;
  final int artIndex;
  final String playlistId;
}

class PlaylistData {
  const PlaylistData({
    required this.id,
    required this.title,
    required this.description,
    required this.artIndex,
    required this.trackIds,
    this.isCapsule = false,
  });

  final String id;
  final String title;
  final String description;
  final int artIndex;
  final List<String> trackIds;
  final bool isCapsule;
}

class DownloadItem {
  const DownloadItem({
    required this.trackId,
    required this.progress,
    required this.status,
    required this.format,
    required this.bitrate,
    required this.sizeMb,
  });

  final String trackId;
  final double progress;
  final DownloadStatus status;
  final String format;
  final String bitrate;
  final double sizeMb;
}

class CapsuleEntry {
  const CapsuleEntry({
    required this.category,
    required this.title,
    required this.subtitle,
  });

  final CapsuleCategory category;
  final String title;
  final String subtitle;
}

class CapsuleData {
  const CapsuleData({
    required this.month,
    required this.monthYear,
    required this.minutes,
    required this.plays,
    required this.artists,
    required this.currentMonth,
    required this.currentSubtitle,
    required this.progress,
    required this.progressLeft,
    required this.progressRight,
    required this.entries,
    required this.playlistId,
    required this.artIndex,
  });

  final String month;
  final String monthYear;
  final int minutes;
  final int plays;
  final int artists;
  final String currentMonth;
  final String currentSubtitle;
  final double progress;
  final String progressLeft;
  final String progressRight;
  final List<CapsuleEntry> entries;
  final String playlistId;
  final int artIndex;
}

class ArtistProfile {
  const ArtistProfile({
    required this.name,
    required this.initials,
    required this.bannerArtIndex,
    required this.photoArtIndex,
    required this.tags,
    required this.monthlyListeners,
    required this.bio,
    required this.topTrackIds,
    required this.albumTitles,
    required this.albumArtIndices,
  });

  final String name;
  final String initials;
  final int bannerArtIndex;
  final int photoArtIndex;
  final List<String> tags;
  final int monthlyListeners;
  final String bio;
  final List<String> topTrackIds;
  final List<String> albumTitles;
  final List<int> albumArtIndices;
}

class LyricLine {
  const LyricLine({
    required this.timeSeconds,
    required this.text,
    this.isSection = false,
    this.romanization,
  });

  final int timeSeconds;
  final String text;
  final bool isSection;
  final String? romanization;
}

class ArtistSource {
  const ArtistSource({required this.label, required this.detail});

  final String label;
  final String detail;
}
