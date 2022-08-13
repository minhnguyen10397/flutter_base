import 'package:flutter/material.dart';

import '../colors.dart';
import '../styles.dart';

Widget _defaultLoadingWidget = const SizedBox(
  width: 30,
  height: 30,
  child: CircularProgressIndicator(
    color: UIColors.black,
    strokeWidth: 3.5,
  ),
);

class _RenderButton extends StatelessWidget {
  _RenderButton({
    Key? key,
    this.title,
    this.widget,
    required this.onPressed,
    this.enabled = true,
    this.buttonColor,
    this.textColor = UIColors.black,
    this.padding = const EdgeInsets.all(15),
    this.isLoading = false,
    this.height,
    this.width,
    this.radius = 6,
  }) : super(key: key);
  final String? title;
  final Widget? widget;
  final bool enabled;
  final void Function() onPressed;
  final Color? buttonColor;
  final Color textColor;
  final EdgeInsetsGeometry padding;
  final bool isLoading;
  final double? height;
  final double? width;
  final double radius;

  late final Widget button = MaterialButton(
    onPressed: enabled
        ? () {
            if (!isLoading) {
              onPressed();
            }
          }
        : null,
    child: isLoading
        ? _defaultLoadingWidget
        : widget ??
            Text(
              title ?? "",
              textAlign: TextAlign.center,
              style: UITextStyle.bold.copyWith(
                color: textColor,
              ),
            ),
    padding: padding,
    color: buttonColor ?? UIColors.primary,
    disabledColor: UIColors.gray,
    splashColor: enabled ? null : Colors.transparent,
    highlightColor: enabled ? null : Colors.transparent,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
  );

  @override
  Widget build(BuildContext context) {
    if (height == null) {
      return SizedBox(
        child: button,
        width: width,
      );
    }
    return SizedBox(height: height, width: width, child: button);
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    this.title,
    this.widget,
    required this.onPressed,
    this.enabled = true,
    this.isLoading = false,
    this.buttonColor = UIColors.primary,
    this.textColor = UIColors.black,
    this.padding = const EdgeInsets.all(0),
    this.height = 50,
    this.width,
    this.radius = 8,
  }) : super(key: key);

  final String? title;
  final Widget? widget;
  final bool enabled;
  final void Function() onPressed;
  final Color? buttonColor;
  final Color textColor;
  final EdgeInsetsGeometry padding;
  final bool isLoading;
  final double height;
  final double? width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return _RenderButton(
      title: title,
      widget: widget,
      onPressed: onPressed,
      enabled: enabled,
      buttonColor: buttonColor,
      textColor: textColor,
      padding: padding,
      isLoading: isLoading,
      height: height,
      width: width,
      radius: radius,
    );
  }
}

class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton({
    Key? key,
    this.title = '',
    this.child,
    required this.onPressed,
    this.enabled = true,
    this.borderColor = UIColors.darkGray,
    this.textColor = UIColors.defaultText,
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
    this.backgroundColor = Colors.white,
    this.splashColor = Colors.white24,
    this.height = 50,
    this.borderRadius,
    this.isLoading = false,
  }) : super(key: key);

  final String title;
  final Widget? child;
  final bool enabled;
  final void Function() onPressed;
  final Color borderColor;
  final Color textColor;
  final Color backgroundColor;
  final Color splashColor;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry? borderRadius;
  final double height;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: enabled
          ? () {
              if (!isLoading) {
                onPressed.call();
              }
            }
          : null,
      style: OutlinedButton.styleFrom(
          primary: splashColor,
          backgroundColor: backgroundColor,
          padding: padding,
          side: BorderSide(
            width: 2,
            color: enabled ? borderColor : UIColors.gray,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(6),
          ),
          fixedSize: Size.fromHeight(height)),
      child: isLoading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    color: UIColors.primary,
                    strokeWidth: 3.5,
                  ),
                )
              ],
            )
          : child ??
              Text(
                title,
                style: UITextStyle.bold.copyWith(
                  color: UIColors.black,
                ),
              ),
    );
  }
}

class SplashButton extends StatelessWidget {
  final Widget child;
  final BorderRadius? borderRadius;
  final Color splashColor;
  final GestureTapCallback? onTap;
  final bool isDisabled;

  const SplashButton({
    Key? key,
    required this.child,
    this.borderRadius,
    this.splashColor = Colors.white24,
    this.isDisabled = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isDisabled) return child;

    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Material(
            borderRadius: borderRadius,
            clipBehavior: Clip.hardEdge,
            color: Colors.transparent,
            child: InkWell(
              splashColor: splashColor,
              onTap: onTap,
            ),
          ),
        )
      ],
    );
  }
}
