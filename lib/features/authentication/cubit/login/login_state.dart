part of 'login_cubit.dart';

class LoginState {
  final BlocStatus status;
  final bool enableNextStep;
  final bool isObscurePassword;
  final String? errMsg;
  final String? errCode;

  LoginState({
    this.status = BlocStatus.initial,
    this.enableNextStep = false,
    this.isObscurePassword = true,
    this.errMsg,
    this.errCode,
  });

  LoginState copyWith({
    BlocStatus? status,
    bool? enableNextStep,
    bool? isObscurePassword,
    String? errMsg,
    String? errCode,
  }) {
    return LoginState(
      status: status ?? BlocStatus.initial,
      enableNextStep: enableNextStep ?? this.enableNextStep,
      isObscurePassword: isObscurePassword ?? this.isObscurePassword,
      errMsg: errMsg,
      errCode: errCode,
    );
  }
}
