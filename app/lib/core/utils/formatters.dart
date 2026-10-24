String formatDuration(Duration duration) {
  final total = duration.inSeconds.clamp(0, 86400 * 7);
  final minutes = total ~/ 60;
  final seconds = (total % 60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

String formatSeconds(int seconds) {
  return formatDuration(Duration(seconds: seconds));
}

String formatVolume(double value) {
  return '${value.round()}%';
}

String formatThousands(int value) {
  final text = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    if (i > 0 && (text.length - i) % 3 == 0) buffer.write(',');
    buffer.write(text[i]);
  }
  return buffer.toString();
}

String formatMegabytes(double value) {
  return '${value.toStringAsFixed(1)} MB';
}

String formatMinutes(int seconds) {
  return '${(seconds / 60).round()} min';
}
