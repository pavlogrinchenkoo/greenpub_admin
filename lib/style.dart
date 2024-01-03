import 'package:flutter/material.dart';

class ThemeColors {
  static const Color green = Color(0xff1D9905);
  static const Color white = Color(0xffffffff);
  static const Color black = Color(0xff000000);
  static const Color darkGrey = Color(0xff18191D);
  // static const Color beige = Color(0xffE8E3D7);
  static const Color beige = Color(0xffDDE1E4);
  static const Color grey = Color(0xff8C8C8E);
  static const Color red = Color(0xffC72238);

}

abstract class BC {


  static Color get green => ThemeColors.green;
  static Color get black => ThemeColors.black;
  static Color get white => ThemeColors.white;
  static Color get darkGrey => ThemeColors.darkGrey;
  static Color get beige => ThemeColors.beige;
  static Color get grey => ThemeColors.grey;
  static Color get red => ThemeColors.red;
}

abstract class BS {
  static TextStyle get light14 => TextStyle(
      color: BC.green,
      fontFamily: 'SFPro',
      fontSize: 14,
      height: 1.28,
      letterSpacing: 0.09,
      fontWeight: FontWeight.w300);

  static TextStyle get bold22 => TextStyle(
      color: BC.black,
      fontFamily: 'SFPro',
      fontSize: 22,
      height: 1.28,
      letterSpacing: 0.09,
      fontWeight: FontWeight.w800);

  static TextStyle get bold20 => TextStyle(
      color: BC.black,
      fontFamily: 'SFPro',
      fontSize: 20,
      height: 1.28,
      letterSpacing: 0.09,
      fontWeight: FontWeight.bold);

  static TextStyle get bold18 => TextStyle(
      color: BC.black,
      fontFamily: 'SFPro',
      fontSize: 18,
      height: 1.28,
      letterSpacing: 0.09,
      fontWeight: FontWeight.w800);

  static TextStyle get bold16 => TextStyle(
      color: BC.black,
      fontFamily: 'SFPro',
      fontSize: 16,
      height: 1.28,
      letterSpacing: 0.09,
      fontWeight: FontWeight.w800);

  static TextStyle get bold14 => TextStyle(
      color: BC.black,
      fontFamily: 'SFPro',
      fontSize: 14,
      height: 1.28,
      letterSpacing: 0.09,
      fontWeight: FontWeight.bold);

  static TextStyle get bold12 => TextStyle(
      color: BC.black,
      fontFamily: 'SFPro',
      fontSize: 12,
      height: 1.28,
      letterSpacing: 0.09,
      decoration: TextDecoration.lineThrough,
      fontWeight: FontWeight.w800);

  static TextStyle get sb14 => TextStyle(
      color: BC.black,
      fontFamily: 'SFPro',
      fontSize: 14,
      height: 1.28,
      letterSpacing: 0.09,
      fontWeight: FontWeight.w600);
}

abstract class BDuration {
  static Duration get d200 => const Duration(milliseconds: 200);
}

abstract class BRadius {
  static BorderRadius get r50 => const BorderRadius.all(Radius.circular(50));
  static BorderRadius get r16 => const BorderRadius.all(Radius.circular(16));
  static BorderRadius get r10 => const BorderRadius.all(Radius.circular(10));
  static BorderRadius get r4 => const BorderRadius.all(Radius.circular(4));
}

abstract class BShadow {
  static List<BoxShadow> get light => [
        BoxShadow(
            color: BC.beige.withOpacity(0.1),
            blurRadius: 60,
            offset: const Offset(0, 2))
      ];
}
