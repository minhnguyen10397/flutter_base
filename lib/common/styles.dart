import 'package:flutter/material.dart' as system;
import 'package:flutter/rendering.dart';
import 'colors.dart';

class UITextStyle {
  static system.TextStyle thin = _style.copyWith(
    color: UIColors.defaultText,
    fontSize: 15,
    fontWeight: FontWeight.w200,
  );

  static system.TextStyle light = _style.copyWith(
    color: UIColors.defaultText,
    fontSize: 15,
    fontWeight: FontWeight.w300,
  );

  static system.TextStyle regular = _style.copyWith(
    color: UIColors.defaultText,
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  static system.TextStyle medium = _style.copyWith(
    color: UIColors.defaultText,
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  static system.TextStyle semiBold = _style.copyWith(
    color: UIColors.defaultText,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static system.TextStyle bold = _style.copyWith(
    color: UIColors.defaultText,
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );

  static system.TextStyle extraBold = _style.copyWith(
    color: UIColors.defaultText,
    fontSize: 15,
    fontWeight: FontWeight.w800,
  );
}

const _style = system.TextStyle(fontFamily: 'Proxima');
