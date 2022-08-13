part of 'register_cubit.dart';

class RegisterState {
  final BlocStatus status;
  final bool enableNextStep;
  final bool isObscurePassword;
  final int dayIndex;
  final int monthIndex;
  final int yearIndex;
  final String? errMsg;

  RegisterState({
    this.status = BlocStatus.initial,
    this.enableNextStep = false,
    this.isObscurePassword = true,
    this.dayIndex = -1,
    this.monthIndex = -1,
    this.yearIndex = -1,
    this.errMsg,
  });

  RegisterState copyWith({
    BlocStatus? status,
    bool? enableNextStep,
    bool? isObscurePassword,
    int? dayIndex,
    int? monthIndex,
    int? yearIndex,
    String? errMsg,
  }) {
    return RegisterState(
      status: status ?? BlocStatus.initial,
      enableNextStep: enableNextStep ?? this.enableNextStep,
      isObscurePassword: isObscurePassword ?? this.isObscurePassword,
      dayIndex: dayIndex ?? this.dayIndex,
      monthIndex: monthIndex ?? this.monthIndex,
      yearIndex: yearIndex ?? this.yearIndex,
      errMsg: errMsg,
    );
  }
}
