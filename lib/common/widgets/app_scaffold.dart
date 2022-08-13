import 'package:flutter/material.dart';
import '../colors.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final EdgeInsets padding;
  final bool allowScroll;
  final bool bottom;

  const AppScaffold({
    Key? key,
    required this.body,
    this.padding = const EdgeInsets.symmetric(vertical: 32, horizontal: 17),
    this.allowScroll = true,
    this.bottom = false,
  }) : super(key: key);

  const AppScaffold.withoutScroll({
    Key? key,
    required this.body,
    this.padding = const EdgeInsets.symmetric(vertical: 32, horizontal: 17),
    this.allowScroll = false,
    this.bottom = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIColors.background,
      body: SafeArea(
        bottom: bottom,
        child: allowScroll
            ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: padding,
                child: body,
              )
            : Padding(
                padding: padding,
                child: body,
              ),
      ),
    );
  }
}
