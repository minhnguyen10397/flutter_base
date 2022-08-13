import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../colors.dart';
import '../styles.dart';

class UITextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool readOnly;
  final bool enable;
  final bool autoFocus;
  final bool isObscurePassword;
  final String? hintText;
  final String? labelText;
  final TextStyle? textStyle;
  final TextStyle? hintTextStyle;
  final TextStyle? labelTextStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? background;
  final Color? cursorColor;
  final double radius;
  final EdgeInsets? contentPadding;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;

  const UITextField({
    Key? key,
    this.focusNode,
    this.controller,
    this.onTap,
    this.readOnly = false,
    this.enable = true,
    this.autoFocus = false,
    this.isObscurePassword = false,
    this.hintText,
    this.labelText,
    this.textStyle,
    this.hintTextStyle,
    this.labelTextStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.background,
    this.cursorColor,
    this.radius = 6,
    this.contentPadding,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: isObscurePassword,
      cursorColor: cursorColor ?? UIColors.white,
      style: textStyle ?? UITextStyle.regular.copyWith(
        fontSize: 15,
        color: UIColors.defaultText,
      ),
      obscuringCharacter: '*',
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofocus: autoFocus,
      enabled: enable,
      readOnly: readOnly,
      onChanged: onChanged,
      autofillHints: null,
      onSubmitted: (value) {
        if (textInputAction == TextInputAction.next) {
          if (suffixIcon != null) {
            FocusScope.of(context).nextFocus();
          }
        }
        onSubmitted?.call(value);
      },
      onTap: onTap,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        fillColor: background ?? UIColors.itemBackground,
        filled: true,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(vertical: 22, horizontal: 17),
        hintText: hintText,
        hintStyle: hintTextStyle ?? UITextStyle.light.copyWith(
          fontSize: 15,
          color: UIColors.defaultText,
        ),
        labelText: labelText,
        labelStyle: labelTextStyle ?? UITextStyle.regular.copyWith(
          fontSize: 15,
          color: UIColors.defaultText,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: background ?? UIColors.itemBackground,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: background ?? UIColors.itemBackground,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: background ?? UIColors.itemBackground,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
        ),
      ),
    );
  }
}
