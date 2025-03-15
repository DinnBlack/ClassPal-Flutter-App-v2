import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';

void configureApp() {
  setUrlStrategy(PathUrlStrategy());
}

void goBack() {
  if (kIsWeb) {
    html.window.history.back();
  }
}