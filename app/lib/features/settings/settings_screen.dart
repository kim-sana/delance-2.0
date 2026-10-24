import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/layout.dart';
import '../../core/navigation.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/headers.dart';
import '../../core/widgets/list_card.dart';
import '../../core/widgets/pressable.dart';
import '../../mock/mock_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _normalizeVolume = true;
  bool _wifiOnly = true;
  bool _history = true;

  @override
  Widget build(BuildContext context) {
    final state = MockScope.of(context);
    return Scaffold(
      body: ListView(
        key: const Key('screen-settings'),
        padding: EdgeInsets.only(
          top: AppLayout.safeTop(context),
          bottom: AppLayout.pushedScreenBottom(context),
        ),
        children: <Widget>[
          const LargeTitleHeader(
            title: 'Settings',
            leading: BackCircleButton(),
          ),
          _ThemeCard(mode: state.themeMode, onChanged: state.setThemeMode),
          const FieldLabel(title: 'Playback'),
          ListCard(
            children: <Widget>[
              ListRow(
                title: 'Volume normalization',
                subtitle: 'Even out track loudness',
                icon: CupertinoIcons.speaker_1,
                trailing: _SettingsSwitch(
                  value: _normalizeVolume,
                  onChanged: (value) =>
                      setState(() => _normalizeVolume = value),
                ),
              ),
              ListRow(
                title: 'Crossfade',
                subtitle: 'Transition between tracks',
                icon: CupertinoIcons.shuffle,
                trailing: Text(
                  'Off',
                  style: context.texts.labelLarge?.copyWith(
                    fontSize: 14,
                    color: context.colors.labelSecondary,
                  ),
                ),
              ),
              ListRow(
                title: 'Streaming quality',
                subtitle: 'Automatic · Opus 160 kbps',
                icon: CupertinoIcons.waveform,
                showChevron: true,
                onTap: () =>
                    showMockSnack(context, 'Mockup: quality options not built'),
              ),
            ],
          ),
          const FieldLabel(title: 'Downloads'),
          ListCard(
            children: <Widget>[
              ListRow(
                title: 'Wi-Fi only',
                subtitle: 'Save mobile data',
                icon: CupertinoIcons.wifi,
                trailing: _SettingsSwitch(
                  value: _wifiOnly,
                  onChanged: (value) => setState(() => _wifiOnly = value),
                ),
              ),
              ListRow(
                title: 'Download quality',
                subtitle: 'Opus 160 kbps',
                icon: CupertinoIcons.square_stack,
                showChevron: true,
                onTap: () => showMockSnack(
                  context,
                  'Mockup: download quality options not built',
                ),
              ),
              ListRow(
                title: 'Cache limit',
                subtitle: 'Maximum space for offline audio',
                icon: CupertinoIcons.archivebox,
                trailing: Text(
                  '2 GB',
                  style: context.texts.labelLarge?.copyWith(
                    fontSize: 14,
                    color: context.colors.labelSecondary,
                  ),
                ),
              ),
              _DangerRow(
                label: 'Clear cache',
                detail: '18.6 MB offline audio',
                onTap: _confirmClearCache,
              ),
            ],
          ),
          const FieldLabel(title: 'Data & lyrics'),
          ListCard(
            children: <Widget>[
              ListRow(
                title: 'Lyrics source',
                subtitle: 'LRCLIB · synced lyrics',
                icon: CupertinoIcons.text_quote,
                showChevron: true,
                onTap: () => showMockSnack(
                  context,
                  "Mockup: lyrics source can't be changed",
                ),
              ),
              ListRow(
                title: 'Metadata source',
                subtitle: 'TheAudioDB · Last.fm · Wikipedia',
                icon: CupertinoIcons.link,
                showChevron: true,
                onTap: () => showMockSnack(
                  context,
                  "Mockup: metadata source can't be changed",
                ),
              ),
              ListRow(
                title: 'Save listening history',
                subtitle: 'For Capsule and recommendations',
                icon: CupertinoIcons.clock,
                trailing: _SettingsSwitch(
                  value: _history,
                  onChanged: (value) => setState(() => _history = value),
                ),
              ),
            ],
          ),
          const FieldLabel(title: 'About'),
          ListCard(
            children: <Widget>[
              ListRow(
                title: 'Version',
                subtitle: '2.0.0 · UI mockup',
                icon: CupertinoIcons.info,
                trailing: Text(
                  'Build 1',
                  style: context.texts.labelLarge?.copyWith(
                    fontSize: 14,
                    color: context.colors.labelSecondary,
                  ),
                ),
              ),
              ListRow(
                title: 'About Delance',
                subtitle: 'Local and YouTube music player',
                icon: CupertinoIcons.music_note,
                showChevron: true,
                onTap: () => _showAbout(context),
              ),
              ListRow(
                title: 'Open source licenses',
                subtitle: 'Inter · Flutter · Cupertino Icons',
                icon: CupertinoIcons.doc_text,
                showChevron: true,
                onTap: () =>
                    showMockSnack(context, 'Mockup: licenses page not built'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmClearCache() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Clear cache?'),
          content: const Text(
            'All offline audio will be removed from this device. '
            'Tracks can still be played via streaming.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
    if (!mounted) return;
    if (confirmed == true) {
      showMockSnack(context, 'Mockup: cache is not actually cleared');
    }
  }

  void _showAbout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delance 2.0'),
          content: const Text(
            'UI mockup for a music player that combines local tracks '
            'and YouTube streaming. All data on this screen is sample data.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class _ThemeCard extends StatelessWidget {
  const _ThemeCard({required this.mode, required this.onChanged});

  final ThemeMode mode;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const options = <(ThemeMode, String, IconData)>[
      (ThemeMode.system, 'System', CupertinoIcons.circle_lefthalf_fill),
      (ThemeMode.light, 'Light', CupertinoIcons.sun_max),
      (ThemeMode.dark, 'Dark', CupertinoIcons.moon),
    ];
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppLayout.screenMargin,
        4,
        AppLayout.screenMargin,
        2,
      ),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Theme',
            style: context.texts.titleSmall?.copyWith(fontSize: 15),
          ),
          const SizedBox(height: 2),
          Text(
            'Follow the system or choose a fixed appearance',
            style: context.texts.bodySmall,
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              for (var i = 0; i < options.length; i++) ...<Widget>[
                if (i > 0) const SizedBox(width: 8),
                Expanded(
                  child: _ThemeOption(
                    label: options[i].$2,
                    icon: options[i].$3,
                    selected: mode == options[i].$1,
                    onTap: () => onChanged(options[i].$1),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Pressable(
      onTap: onTap,
      semanticLabel: 'Theme $label',
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: selected ? colors.accent : colors.bgPrimary,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 15,
              color: selected ? Colors.white : colors.labelSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : colors.labelPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  const _SettingsSwitch({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.82,
      alignment: Alignment.centerRight,
      child: Switch(
        value: value,
        onChanged: onChanged,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

class _DangerRow extends StatelessWidget {
  const _DangerRow({
    required this.label,
    required this.detail,
    required this.onTap,
  });

  final String label;
  final String detail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Pressable(
      onTap: onTap,
      semanticLabel: label,
      child: Container(
        constraints: const BoxConstraints(minHeight: 56),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: <Widget>[
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.accentTint,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(CupertinoIcons.trash, size: 16, color: colors.accent),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    label,
                    style: context.texts.bodyLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colors.accent,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(detail, style: context.texts.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
