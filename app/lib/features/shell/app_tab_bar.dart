import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/layout.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/material_bar.dart';
import '../../core/widgets/pressable.dart';

class AppTabBar extends StatelessWidget {
  const AppTabBar({
    super.key,
    required this.index,
    required this.onTab,
    required this.onSearch,
  });

  final int index;
  final ValueChanged<int> onTab;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MaterialBar(
      borderRadius: BorderRadius.circular(AppLayout.tabBarRadius),
      shadow: isDark
          ? null
          : BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 24,
              offset: const Offset(0, 6),
            ),
      border: isDark ? Border.all(color: colors.separator) : null,
      child: SizedBox(
        height: AppLayout.tabBarHeight,
        child: Row(
          children: <Widget>[
            Expanded(
              child: _TabButton(
                key: const Key('tab-home'),
                label: 'Home',
                icon: index == 0
                    ? CupertinoIcons.house_fill
                    : CupertinoIcons.house,
                active: index == 0,
                onTap: () => onTab(0),
              ),
            ),
            Expanded(
              child: _TabButton(
                key: const Key('tab-search'),
                label: 'Search',
                icon: CupertinoIcons.search,
                active: index == 1,
                onTap: () => onTab(1),
              ),
            ),
            Expanded(
              child: _TabButton(
                key: const Key('tab-library'),
                label: 'Library',
                icon: CupertinoIcons.music_note_list,
                active: index == 2,
                onTap: () => onTab(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2, right: 6),
              child: _SearchFab(onTap: onSearch),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    super.key,
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Pressable(
      onTap: onTap,
      semanticLabel: label,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: active ? colors.accentTint : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                icon,
                size: 24,
                color: active ? colors.accent : colors.labelPrimary,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                  color: active ? colors.accent : colors.labelPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchFab extends StatelessWidget {
  const _SearchFab({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Pressable(
      key: const Key('tab-search-fab'),
      onTap: onTap,
      semanticLabel: 'Search',
      child: Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDark ? colors.bgElevated : colors.bgPrimary,
          shape: BoxShape.circle,
          border: isDark ? Border.all(color: colors.separator) : null,
          boxShadow: isDark
              ? null
              : <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.14),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Icon(
          CupertinoIcons.search,
          size: 22,
          color: colors.labelPrimary,
        ),
      ),
    );
  }
}
