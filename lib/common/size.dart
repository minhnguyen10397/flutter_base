import 'package:flutter/material.dart';

class AppSize {
  AppSize._();
  static final instance = AppSize._();

  double width = 0;
  double height = 0;

  void init(BuildContext context) {
    if (width == 0 && height == 0) {
      final size = MediaQuery.of(context).size;
      width = size.width;
      height = size.height;
    }
  }

  bool get isMobile => width < 600;
  bool get isTablet => !isMobile;
}
