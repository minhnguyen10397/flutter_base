import 'package:get_it/get_it.dart';
import 'package:gold/routes/guards.dart';
import 'package:gold/routes/routes.gr.dart';
import 'package:gold/services/local/local_data_helper.dart';

import '../features/profile/cubit/user/user_controller_cubit.dart';

final getItInstance = GetIt.I;

Future configureDependencies() async {
  getItInstance.registerSingleton<UserControllerCubit>(
    UserControllerCubit(),
  );
  int? userId = LocalDataHelper.instance.getUser();
  if (userId != null) {
    getItInstance.get<UserControllerCubit>().getProfile();
  }

  getItInstance.registerSingleton<AppRouter>(AppRouter(authGuard: AuthGuard()));
}
