part of 'user_controller_cubit.dart';

enum UserType {
  ANONYMOUS,
  AUTHENTICATED,
}

class UserControllerState {
  UserControllerState({
    this.status = BlocStatus.initial,
    this.userType = UserType.ANONYMOUS,
    this.user,
  });

  final BlocStatus status;
  final UserType userType;
  final UserModel? user;

  UserControllerState copyWith({
    BlocStatus? status,
    UserType? userType,
    UserModel? user,
  }) {
    return UserControllerState(
      status: status ?? this.status,
      userType: userType ?? this.userType,
      user: user ?? this.user,
    );
  }
}
