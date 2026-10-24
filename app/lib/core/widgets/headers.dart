import 'package:flutter/cupertino.dart';

import '../layout.dart';
import '../theme/app_colors.dart';
import 'buttons.dart';

class LargeTitleHeader extends StatelessWidget {
  const LargeTitleHeader({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    this.bottomPadding = 14,
  });

  final String title;
  final Widget? leading;
  final Widget? trailing;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    final texts = context.texts;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppLayout.screenMargin,
        6,
        AppLayout.screenMargin,
        bottomPadding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          if (leading != null) ...<Widget>[leading!, const SizedBox(width: 10)],
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: texts.displayMedium,
            ),
          ),
          if (trailing != null) ...<Widget>[
            const SizedBox(width: 12),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.onTap,
    this.showChevron = false,
    this.padding = const EdgeInsets.fromLTRB(
      AppLayout.screenMargin,
      22,
      AppLayout.screenMargin,
      10,
    ),
  });

  final String title;
  final VoidCallback? onTap;
  final bool showChevron;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(title, style: context.texts.headlineMedium),
        if (showChevron) ...<Widget>[
          const SizedBox(width: 4),
          Icon(
            CupertinoIcons.chevron_right,
            size: 18,
            color: colors.labelSecondary,
          ),
        ],
      ],
    );
    return Padding(
      padding: padding,
      child: onTap == null
          ? content
          : GestureDetector(onTap: onTap, child: content),
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel({
    super.key,
    required this.label,
    this.trailing,
    this.padding = const EdgeInsets.fromLTRB(
      AppLayout.screenMargin,
      20,
      AppLayout.screenMargin,
      8,
    ),
    this.onTap,
  });

  final String label;
  final String? trailing;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final row = Row(
      children: <Widget>[
        Expanded(
          child: Text(label.toUpperCase(), style: context.texts.labelSmall),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: context.texts.labelMedium?.copyWith(
              color: colors.labelTertiary,
            ),
          ),
        if (onTap != null)
          Icon(
            CupertinoIcons.chevron_right,
            size: 14,
            color: colors.labelTertiary,
          ),
      ],
    );
    return Padding(
      padding: padding,
      child: onTap == null ? row : GestureDetector(onTap: onTap, child: row),
    );
  }
}

class FieldLabel extends StatelessWidget {
  const FieldLabel({
    super.key,
    required this.title,
    this.detail,
    this.padding = const EdgeInsets.fromLTRB(
      AppLayout.screenMargin,
      20,
      AppLayout.screenMargin,
      8,
    ),
  });

  final String title;
  final String? detail;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Text(title.toUpperCase(), style: context.texts.labelSmall),
          ),
          if (detail != null)
            Text(
              detail!,
              style: context.texts.labelMedium?.copyWith(
                color: colors.labelTertiary,
              ),
            ),
        ],
      ),
    );
  }
}

class BackCircleButton extends StatelessWidget {
  const BackCircleButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CircleIconButton(
      icon: CupertinoIcons.chevron_left,
      iconSize: 20,
      size: 34,
      semanticLabel: 'Back',
      onTap: onTap ?? () => Navigator.of(context).maybePop(),
    );
  }
}
