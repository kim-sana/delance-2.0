import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class Equalizer extends StatefulWidget {
  const Equalizer({super.key, this.paused = false, this.height = 13});

  final bool paused;
  final double height;

  @override
  State<Equalizer> createState() => _EqualizerState();
}

class _EqualizerState extends State<Equalizer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant Equalizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncAnimation();
  }

  void _syncAnimation() {
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (widget.paused || reduceMotion) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colors.accent;
    return SizedBox(
      width: 15,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value * math.pi * 2;
          final values = <double>[
            0.5 + 0.5 * math.sin(t),
            0.5 + 0.5 * math.sin(t + 1.4),
            0.5 + 0.5 * math.sin(t + 2.8),
          ];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: values
                .map((value) {
                  final height = widget.paused
                      ? 4.0
                      : 4 + (widget.height - 4) * value;
                  return Container(
                    width: 3,
                    height: height,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  );
                })
                .toList(growable: false),
          );
        },
      ),
    );
  }
}
