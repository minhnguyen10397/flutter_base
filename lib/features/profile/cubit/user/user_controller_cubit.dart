import 'package:bloc/bloc.dart';
import '../../../../common/bloc_status.dart';
import '../../../../models/user/user_model.dart';
import '../../../../services/local/local_data_helper.dart';
import '../../repository/profile_repository.dart';

part 'user_controller_state.dart';

class UserControllerCubit extends Cubit<UserControllerState> {
  UserControllerCubit() : super(UserControllerState());

  final repository = ProfileRepository();

  getProfile() async {
    emit(state.copyWith(
      status: BlocStatus.success,
      userType: UserType.AUTHENTICATED,
    ));
    // int? userId = LocalDataHelper.instance.getUser();
    // if (userId != null) {
    //   emit(state.copyWith(status: BlocStatus.loading));
    //   final BaseModel<UserModel> result = await repository.getUserProfile({});
    //   if (result.status) {
    //     emit(state.copyWith(
    //       status: BlocStatus.success,
    //       userType: UserType.AUTHENTICATED,
    //       user: result.data,
    //     ));
    //   } else {
    //     emit(state.copyWith(status: BlocStatus.failure));
    //   }
    // }
  }

  logout() async {
    await LocalDataHelper.instance.clearData();
    emit(UserControllerState(userType: UserType.ANONYMOUS));
  }
}
