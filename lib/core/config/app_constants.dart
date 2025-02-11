import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Text
const String APP_NAME = "ClassPal Application";
const String WELCOME_MESSAGE =
    "Chào mừng đến với ứng dụng ClassPal của chúng tôi!";

class AppKey {
 static const String googleServerClientId = '445439726037-ntsjeu0lsv9f0iutqgdcge1gjj6r8dvh.apps.googleusercontent.com';
}

const GOOGLE_CLIENT_ID_WEB = '<your-web-clientID>.apps.googleusercontent.com';

String GoogleClientID() {
 if (kIsWeb) {
  return GOOGLE_CLIENT_ID_WEB;
 }
 return '';
}

// App Colors
const Color kPrimaryColor = Color(0xFF21A9B7);
 Color kPrimaryLightColor = Color(0xFF90D4DB);
const Color kBackgroundColor = Color(0xFFFFFFFF);
const Color kGreyColor = Colors.grey;
const Color kGreyDarkColor = Color(0xFF5A5A5A);
const Color kGreyMediumColor = Color(0xFFD8D8D8);
 Color kGreyLightColor = Color(0xFFEFEFEF);
const Color kTransparentColor = Colors.transparent;
const Color kBlackColor = Colors.black;
const Color kWhiteColor = Colors.white;
const Color kBlueColor = Colors.blue;
const Color kGreenColor = Colors.green;
const Color kRedColor = Colors.red;
const Color kOrangeColor = Colors.orange;

// Sizes
const double kTextSizeXxs = 10.0;
const double kTextSizeXs = 12.0;
const double kTextSizeSm = 14.0;
const double kTextSizeMd = 16.0;
const double kTextSizeLg = 18.0;
const double kTextSizeXl = 20.0;
const double kTextSizeXxl = 22.0;

// Border Radius
const double kBorderRadiusSm = 5.0;
const double kBorderRadiusMd = 10.0;
const double kBorderRadiusLg = 20.0;
const double kBorderRadiusXl = 30.0;

// Padding
const double kPaddingSm = 5.0;
const double kPaddingMd = 10.0;
const double kPaddingLg = 20.0;
const double kPaddingXl = 30.0;

// Margin
const double kMarginSm = 5.0;
const double kMarginMd = 10.0;
const double kMarginLg = 20.0;
const double kMarginXl = 30.0;
const double kMarginXxl = 40.0;
