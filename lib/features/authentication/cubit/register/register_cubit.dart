import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:gold/common/constants.dart';
import 'package:gold/common/utils/datetime_util.dart';
import 'package:gold/common/utils/validation_util.dart';

import '../../../../common/bloc_status.dart';
import '../../../../models/base_model.dart';
import '../../../../models/user/data_register_model.dart';
import '../../repository/authentication_repository.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterState()) {
    final curYear = DateTime.now().year;
    years = List.generate(100, (index) => '${curYear - index - 18}');
  }

  final repository = AuthenticationRepository();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  late final List<String> years;

  toggleShowPassword() {
    emit(state.copyWith(
      isObscurePassword: !state.isObscurePassword,
    ));
  }

  chooseDayOfBirth(int index) {
    emit(state.copyWith(dayIndex: index));
    validateData();
  }

  chooseMonthOfBirth(int index) {
    emit(state.copyWith(monthIndex: index));
    validateData();
  }

  chooseYearOfBirth(int index) {
    emit(state.copyWith(yearIndex: index));
    validateData();
  }

  validateData() {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final email = emailController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    final enableNextStep = firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        email.isNotEmpty &&
        username.isNotEmpty &&
        password.isNotEmpty &&
        state.dayIndex != -1 &&
        state.monthIndex != -1 &&
        state.yearIndex != -1;

    emit(state.copyWith(
      enableNextStep: enableNextStep,
    ));
  }

  register() async {
    if (EmailInputValidation.dirty(value: emailController.text).invalid) {
      emit(state.copyWith(status: BlocStatus.failure, errMsg: 'Please enter valid Email.'));
      return;
    }
    if (passwordController.text.length < 6) {
      emit(state.copyWith(status: BlocStatus.failure, errMsg: 'Password must be at least 6 characters.'));
      return;
    }
    String date =
        '${AppConstants.dates[state.dayIndex]}-${AppConstants.months[state.monthIndex]}-${years[state.yearIndex]}';
    if (!DateTimeUtil.isDate(date)) {
      emit(state.copyWith(status: BlocStatus.failure, errMsg: 'Date of Birth invalid.'));
      return;
    }
    emit(state.copyWith(
      status: BlocStatus.loading,
    ));
    String modal = '';
    String manufacture = '';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      modal = androidInfo.model ?? '';
      manufacture = androidInfo.manufacturer ?? '';
    }
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      modal = iosInfo.utsname.machine ?? '';
      manufacture = 'Apple';
    }
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final dob = DateTimeUtil.convertDate(
      date,
      fromFormat: DateTimeFormat.dd_MMM_yyyy,
      toFormat: DateTimeFormat.yyyy_MM_dd,
    );
    final BaseModel<bool> result = await repository.register({
      "first_name": firstNameController.text,
      "last_name": lastNameController.text,
      "dob": dob,
      "email": emailController.text,
      "vokalz_id": usernameController.text,
      "password": passwordController.text,
      "device": Platform.isAndroid ? "Android" : "iOS",
      "modal": modal,
      "manufacture": manufacture,
      "os": packageInfo.version,
    });
    if (result.status) {
      emit(state.copyWith(
        status: BlocStatus.success,
      ));
    } else {
      emit(state.copyWith(status: BlocStatus.failure, errMsg: result.message));
    }
  }

  @override
  Future<void> close() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
