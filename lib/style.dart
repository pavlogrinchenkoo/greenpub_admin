import 'package:flutter/material.dart';

class ThemeColors {
  static const Color green = Color(0xff1D9905);
  static const Color white = Color(0xffffffff);
  static const Color black = Color(0xff000000);

}

abstract class BC {


  static Color get green => ThemeColors.green;
  static Color get white => ThemeColors.white;
  static Color get black => ThemeColors.black;
}

abstract class BS {
  static TextStyle get light14 => TextStyle(
      color: BC.green,
      fontFamily: 'SFPro',
      fontSize: 14,
      height: 1.28,
      letterSpacing: 0.09,
      fontWeight: FontWeight.w300);
}

abstract class BDuration {
  static Duration get d200 => const Duration(milliseconds: 200);
}

abstract class BRadius {
  static BorderRadius get r50 => const BorderRadius.all(Radius.circular(50));
  static BorderRadius get r16 => const BorderRadius.all(Radius.circular(16));
}

abstract class BShadow {
  static List<BoxShadow> get light => [
        BoxShadow(
            color: BC.green.withOpacity(0.1),
            blurRadius: 60,
            offset: const Offset(0, 2))
      ];
}
