import 'package:flutter/material.dart';

abstract final class ArtPalette {
  static const List<List<Color>> _gradients = <List<Color>>[
    <Color>[Color(0xFF8E6B4F), Color(0xFF3B2A1E), Color(0xFF1A1310)],
    <Color>[Color(0xFF6C5CE7), Color(0xFF2D1B69), Color(0xFF120B2E)],
    <Color>[Color(0xFFF0932B), Color(0xFF6C2F1A), Color(0xFF20100A)],
    <Color>[Color(0xFF4A6572), Color(0xFF232F34), Color(0xFF0D1214)],
    <Color>[Color(0xFFC0392B), Color(0xFF4A1410), Color(0xFF160706)],
    <Color>[Color(0xFF16A085), Color(0xFF0A3D33), Color(0xFF041A15)],
    <Color>[Color(0xFF7E8A97), Color(0xFF3A424A), Color(0xFF14181C)],
    <Color>[Color(0xFF8E44AD), Color(0xFF3B1B52), Color(0xFF170A21)],
    <Color>[Color(0xFF2980B9), Color(0xFF123D57), Color(0xFF081D28)],
    <Color>[Color(0xFFD35400), Color(0xFF5E2300), Color(0xFF220D00)],
    <Color>[Color(0xFF2C3E50), Color(0xFF16212B), Color(0xFF080C10)],
    <Color>[
      Color(0xFFF39C12),
      Color(0xFFB8430B),
      Color(0xFF3A1405),
      Color(0xFF150703),
    ],
    <Color>[Color(0xFFD96C3B), Color(0xFF4A1A0A), Color(0xFF140604)],
    <Color>[Color(0xFFB36A4C), Color(0xFF5B2B1C), Color(0xFF1D0C07)],
    <Color>[Color(0xFF3E7C7B), Color(0xFF12302F), Color(0xFF071313)],
    <Color>[Color(0xFF7B5AA6), Color(0xFF2A1440), Color(0xFF0F0718)],
  ];

  static List<Color> colors(int index) {
    return _gradients[index.abs() % _gradients.length];
  }

  static LinearGradient gradient(
    int index, {
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) {
    return LinearGradient(colors: colors(index), begin: begin, end: end);
  }
}
