import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../art_palette.dart';

class Artwork extends StatelessWidget {
  const Artwork({
    super.key,
    required this.index,
    this.size,
    this.borderRadius = const BorderRadius.all(Radius.circular(6)),
    this.showGlyph = false,
    this.glyphOpacity = 0.16,
  });

  final int index;
  final double? size;
  final BorderRadius borderRadius;
  final bool showGlyph;
  final double glyphOpacity;

  @override
  Widget build(BuildContext context) {
    final content = ClipRRect(
      borderRadius: borderRadius,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(gradient: ArtPalette.gradient(index)),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-0.35, -0.45),
                radius: 1.25,
                colors: <Color>[
                  Colors.white.withValues(alpha: 0.16),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.10),
                ],
              ),
            ),
          ),
          if (showGlyph)
            Center(
              child: Icon(
                CupertinoIcons.music_note,
                color: Colors.white.withValues(alpha: glyphOpacity),
                size: (size ?? 120) * 0.30,
              ),
            ),
        ],
      ),
    );

    if (size == null) return content;
    return SizedBox.square(dimension: size, child: content);
  }
}
