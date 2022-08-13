import 'package:formz/formz.dart';

// Define input validation errors
enum InputError { empty, invalid }

class NameInput extends FormzInput<String, InputError> {
  const NameInput.pure() : super.pure('');

  const NameInput.dirty({String value = ''}) : super.dirty(value);

  @override
  InputError? validator(String value) {
    return value.isNotEmpty ? null : InputError.empty;
  }
}

class EmailInputValidation extends FormzInput<String, InputError> {
  final String pattern;

  const EmailInputValidation.pure({
    this.pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  }) : super.pure('');

  const EmailInputValidation.dirty({
    String value = '',
    this.pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  }) : super.dirty(value);

  @override
  InputError? validator(String value) {
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return InputError.empty;
    }

    if (!regExp.hasMatch(value)) {
      return InputError.invalid;
    }
    return null;
  }
}

class PhoneInputValidation extends FormzInput<String, InputError> {
  final String pattern;

  const PhoneInputValidation.pure({

    this.pattern = r'^[0-9]{10}$',
  }) : super.pure('');

  const PhoneInputValidation.dirty({
    String value = '',
    this.pattern = r'^[0-9]{10}$',
  }) : super.dirty(value);

  @override
  InputError? validator(String value) {
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return InputError.empty;
    } else if (!regExp.hasMatch(value)) {
      return InputError.invalid;
    }
    return null;
  }
}

class NumberInputValidation extends FormzInput<String, InputError> {
  final String pattern;

  const NumberInputValidation.pure({
    this.pattern = r'^[0-9]*$',
  }) : super.pure('');

  const NumberInputValidation.dirty({
    String value = '',
    this.pattern = r'^[0-9]*$',
  }) : super.dirty(value);

  @override
  InputError? validator(String value) {
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return InputError.empty;
    } else if (!regExp.hasMatch(value)) {
      return InputError.invalid;
    }
    return null;
  }
}
