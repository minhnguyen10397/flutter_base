import 'package:flutter/material.dart';

class UICollapsedText extends Text {
  UICollapsedText(
    String text, {
    Key? key,
    int maxLines = 1,
    TextOverflow overflow = TextOverflow.ellipsis,
    TextStyle? style,
  }) : super(
          text.replaceAll('', '\u{200B}'),
          key: key,
          overflow: overflow,
          maxLines: maxLines,
          softWrap: true,
          style: style,
        );
}
