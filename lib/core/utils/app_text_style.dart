import 'package:flutter/material.dart';

import '../config/app_constants.dart';

class AppTextStyle {
  static TextStyle light(double size, [Color color = kBlackColor]) {
    return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.w300,
    );
  }

  static TextStyle regular(double size, [Color color = kBlackColor]) {
    return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle medium(double size, [Color color = kBlackColor]) {
    return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle semibold(double size, [Color color = kBlackColor]) {
    return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle bold(double size, [Color color = kBlackColor]) {
    return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle extraBold(double size, [Color color = kBlackColor]) {
    return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.w800,
    );
  }
}
