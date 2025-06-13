import 'package:flutter/material.dart';

class ApparenceKitColors {
  final Color primary;
  final Color secondary;
  final Color background;

  ApparenceKitColors({
    required this.primary,
    required this.secondary,
    required this.background,
  });

  factory ApparenceKitColors.light() {
    return ApparenceKitColors(
      primary: const Color(0xffFFFFFF),
      secondary: const Color(0xff000000),
      background: const Color(0xffF5F5F5),
    );
  }

  factory ApparenceKitColors.dark() {
    return ApparenceKitColors(
      primary: const Color(0xff121212),
      secondary: const Color(0xffFFFFFF),
      background: const Color(0xff212121),
    );
  }
}

class ApparenceKitTextStyle {
  final TextStyle buttonText;
  final TextStyle mediumButtonText;
  final TextStyle mediumText;
  final TextStyle tabBarText;

  ApparenceKitTextStyle({
    required this.buttonText,
    required this.mediumButtonText,
    required this.mediumText,
    required this.tabBarText,
  });

  factory ApparenceKitTextStyle.fromColors(ApparenceKitColors colors) {
    return ApparenceKitTextStyle(
      buttonText: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        color: colors.secondary,
      ),
      mediumButtonText: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: colors.secondary,
      ),
      mediumText: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: colors.secondary,
      ),
      tabBarText: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: colors.secondary,
      ),
    );
  }
}

class ApparenceKitThemeData {
  final ThemeData materialTheme;
  final ApparenceKitColors colors;
  final ApparenceKitTextStyle textStyle;

  ApparenceKitThemeData({
    required this.materialTheme,
    required this.colors,
    required this.textStyle,
  });

  factory ApparenceKitThemeData.light() {
    final colors = ApparenceKitColors.light();
    final textStyle = ApparenceKitTextStyle.fromColors(colors);

    return ApparenceKitThemeData(
      materialTheme: ThemeData.light().copyWith(
        primaryColor: colors.primary,
        scaffoldBackgroundColor: colors.background,
        appBarTheme: AppBarTheme(
          color: colors.primary,
          elevation: 0,
          iconTheme: IconThemeData(color: colors.secondary),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: colors.primary,
          textTheme: ButtonTextTheme.primary,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: colors.primary,
          primary: colors.primary,
          secondary: colors.secondary,
        ),
        textTheme: ThemeData.light().textTheme.apply(),
      ),
      colors: colors,
      textStyle: textStyle,
    );
  }

  factory ApparenceKitThemeData.dark() {
    final colors = ApparenceKitColors.dark();
    final textStyle = ApparenceKitTextStyle.fromColors(colors);

    return ApparenceKitThemeData(
      materialTheme: ThemeData.dark().copyWith(
        primaryColor: colors.primary,
        scaffoldBackgroundColor: colors.background,
        appBarTheme: AppBarTheme(
          color: colors.primary,
          elevation: 0,
          iconTheme: IconThemeData(color: colors.secondary),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: colors.primary,
          textTheme: ButtonTextTheme.primary,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: colors.primary,
          primary: colors.primary,
          secondary: colors.secondary,
        ),
        textTheme: ThemeData.dark().textTheme.apply(),
      ),
      colors: colors,
      textStyle: textStyle,
    );
  }
}
