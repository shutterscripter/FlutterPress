import 'package:flutter/material.dart';
import 'package:news_app/utils/color_utils.dart';

class ThemeSupport {
  static final lightTheme = ThemeData(
    primaryColor: ColorUtils.purp,
    brightness: Brightness.light,
  );

  static final darkTheme = ThemeData(
    primaryColor: ColorUtils.purp,
    brightness: Brightness.dark,
  );
}
