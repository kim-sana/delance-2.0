import 'package:flutter/material.dart';

class AppSlider extends StatelessWidget {
  const AppSlider({
    super.key,
    required this.value,
    required this.max,
    this.onChanged,
    required this.activeColor,
    required this.inactiveColor,
    required this.thumbColor,
    this.height = 32,
    this.showThumb = true,
  });

  final double value;
  final double max;
  final ValueChanged<double>? onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;
  final double height;
  final bool showThumb;

  @override
  Widget build(BuildContext context) {
    final fraction = max <= 0 ? 0.0 : (value / max).clamp(0.0, 1.0);
    return Semantics(
      slider: true,
      value: '${(fraction * 100).round()}%',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: onChanged == null
            ? null
            : (details) => _update(details.localPosition.dx, context),
        onHorizontalDragUpdate: onChanged == null
            ? null
            : (details) => _update(details.localPosition.dx, context),
        child: SizedBox(
          height: height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                return Stack(
                  alignment: Alignment.centerLeft,
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: inactiveColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: fraction,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: activeColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    if (showThumb)
                      Positioned(
                        left: (fraction * width) - 5,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: thumbColor,
                            shape: BoxShape.circle,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.35),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _update(double dx, BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final width = box.size.width - 10;
    if (width <= 0) return;
    final local = (dx - 5).clamp(0.0, width);
    onChanged?.call((local / width) * max);
  }
}
