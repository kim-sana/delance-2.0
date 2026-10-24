import 'package:delance/app.dart';
import 'package:delance/mock/mock_target.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpApp(
  WidgetTester tester, {
  String screen = 'home',
  ThemeMode themeMode = ThemeMode.dark,
  Size size = const Size(430, 900),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    DelanceApp(
      target: MockTarget(screen: screen, themeMode: themeMode),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('home renders editorial and latest songs', (tester) async {
    await _pumpApp(tester);

    expect(find.byKey(const Key('screen-home')), findsOneWidget);
    expect(find.text('New'), findsOneWidget);
    expect(find.text('Latest Songs'), findsOneWidget);
    expect(find.text('Cloud Thought'), findsWidgets);
    expect(find.byKey(const Key('mini-player-body')), findsOneWidget);
  });

  testWidgets('tabs switch between home, search, and library', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.byKey(const Key('tab-search')));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byKey(const Key('screen-search')), findsOneWidget);

    await tester.tap(find.byKey(const Key('tab-library')));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byKey(const Key('screen-library')), findsOneWidget);

    await tester.tap(find.byKey(const Key('tab-home')));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byKey(const Key('screen-home')), findsOneWidget);
  });

  testWidgets('search fab opens search', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.byKey(const Key('tab-search-fab')));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byKey(const Key('screen-search')), findsOneWidget);
    expect(find.byKey(const Key('search-field')), findsOneWidget);
  });

  testWidgets('mini player opens now playing', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.byKey(const Key('mini-player-body')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.byKey(const Key('screen-nowplaying')), findsOneWidget);
    expect(find.text('NOW PLAYING'), findsOneWidget);
    expect(find.byKey(const Key('np-play')), findsOneWidget);
  });

  testWidgets('lyrics deep link opens lyrics pane', (tester) async {
    await _pumpApp(tester, screen: 'lyrics');
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.byKey(const Key('screen-nowplaying')), findsOneWidget);
    expect(find.byKey(const Key('lyrics-pane')), findsOneWidget);
    expect(find.text('Lyrics'), findsOneWidget);
  });

  testWidgets('lyrics auto-scroll centers the active line', (tester) async {
    await _pumpApp(tester, screen: 'lyrics');
    for (var frame = 0; frame < 30; frame++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    final viewport = tester.getRect(find.byKey(const Key('lyrics-list')));
    final active = tester.getRect(find.text('neon shadows wave goodbye.'));
    expect((active.center.dy - viewport.center.dy).abs(), lessThan(12));
  });

  testWidgets('queue deep link opens queue sheet', (tester) async {
    await _pumpApp(tester, screen: 'queue');
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Up Next'), findsOneWidget);
    expect(find.text('Clear all'), findsOneWidget);
  });

  testWidgets('settings deep link renders theme selector', (tester) async {
    await _pumpApp(tester, screen: 'settings');
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.byKey(const Key('screen-settings')), findsOneWidget);
    expect(find.text('Theme'), findsOneWidget);
    expect(find.text('Light'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);
  });

  testWidgets('all screens fit a 360x800 viewport', (tester) async {
    const screens = <String>[
      'home',
      'search',
      'nowplaying',
      'lyrics',
      'queue',
      'library',
      'downloads',
      'capsule',
      'artist',
      'playlist',
      'settings',
    ];

    for (final screen in screens) {
      await _pumpApp(tester, screen: screen, size: const Size(360, 800));
      await tester.pump(const Duration(milliseconds: 600));
      expect(tester.takeException(), isNull, reason: 'screen: $screen');
    }
  });
}
