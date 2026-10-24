import 'package:flutter/widgets.dart';

abstract final class AppLayout {
  static const double screenMargin = 20;
  static const double miniPlayerHeight = 56;
  static const double miniPlayerRadius = 14;
  static const double miniPlayerGap = 8;
  static const double tabBarHeight = 66;
  static const double tabBarRadius = 24;
  static const double tabBarBottomGap = 12;
  static const double contentGap = 16;

  static double safeTop(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return top > 0 ? top : 16;
  }

  static double safeBottom(BuildContext context) {
    return MediaQuery.paddingOf(context).bottom;
  }

  static double tabBarBottom(BuildContext context) {
    return safeBottom(context) + tabBarBottomGap;
  }

  static double miniPlayerBottom(BuildContext context) {
    return tabBarBottom(context) + tabBarHeight + miniPlayerGap;
  }

  static double scrollClearance(BuildContext context) {
    return safeBottom(context) +
        tabBarHeight +
        miniPlayerHeight +
        miniPlayerGap +
        tabBarBottomGap +
        contentGap;
  }

  static double pushedScreenBottom(BuildContext context) {
    return safeBottom(context) + 24;
  }
}
