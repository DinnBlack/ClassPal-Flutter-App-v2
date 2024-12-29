import 'package:flutter/material.dart';
import '../config/app_constants.dart';

// ThemeData cho chế độ sáng
final ThemeData lightTheme = ThemeData(
  fontFamily: 'NotoSans',
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: kPrimaryColor,
    secondary: kPrimaryLightColor,
    surface: kBackgroundColor,
  ),
  scaffoldBackgroundColor: kBackgroundColor,
  appBarTheme: const AppBarTheme(
    backgroundColor: kPrimaryColor,
    foregroundColor: kWhiteColor,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: kBlackColor),
    bodyMedium: TextStyle(color: kGreyColor),
  ),
);

// ThemeData cho chế độ tối
final ThemeData darkTheme = ThemeData(
  fontFamily: 'NotoSans',
  colorScheme: const ColorScheme.dark().copyWith(
    primary: kPrimaryColor,
    secondary: kPrimaryLightColor,
    surface: kBlackColor,
  ),
  scaffoldBackgroundColor: kBlackColor,
  appBarTheme: const AppBarTheme(
    backgroundColor: kPrimaryColor,
    foregroundColor: kWhiteColor,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: kWhiteColor),
    bodyMedium: TextStyle(color: kGreyMediumColor),
  ),
);
