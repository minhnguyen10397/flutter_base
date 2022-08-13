import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:gold/common/constants.dart';
import 'package:gold/di/get_it.dart';
import 'package:gold/features/profile/cubit/user/user_controller_cubit.dart';
import 'package:gold/models/base_model.dart';
import 'package:gold/models/user/user_model.dart';

import '../../../../common/bloc_status.dart';
import '../../repository/authentication_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState());

  final repository = AuthenticationRepository();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  toggleShowPassword() {
    emit(state.copyWith(
      isObscurePassword: !state.isObscurePassword,
    ));
  }

  validateData() {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();
    emit(state.copyWith(
      enableNextStep: username.isNotEmpty && password.isNotEmpty,
    ));
  }

  login() async {
    if (passwordController.text.length < 6) {
      emit(state.copyWith(
          status: BlocStatus.failure,
          errMsg: 'Password must be at least 6 characters.'));
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

    final BaseModel<UserModel> result = await repository.login({
      "vokalz_id": usernameController.text,
      "password": passwordController.text,
      "device": Platform.isAndroid ? "Android" : "iOS",
      "modal": modal,
      "manufacture": manufacture,
      "os": packageInfo.version,
    });
    if (result.status) {
      await getItInstance.get<UserControllerCubit>().getProfile();
      emit(state.copyWith(
        status: BlocStatus.success,
      ));
    } else if (result.errCode == AppConstants.EMAIL_NOT_VERIFIED) {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errMsg: result.message,
        errCode: result.errCode,
      ));
    }
    else {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errMsg: result.message,
        errCode: result.errCode,
      ));
    }
  }

  @override
  Future<void> close() {
    usernameController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
