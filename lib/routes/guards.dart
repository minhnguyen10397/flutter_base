import 'package:auto_route/auto_route.dart';
import 'package:gold/services/local/local_data_helper.dart';

import 'routes.gr.dart';

class AuthGuard extends AutoRouteGuard {

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    int? userId = LocalDataHelper.instance.getUser();
    if (userId == null) {
      router.push(const LoginRoute());
    } else {
      resolver.next(true);
    }
  }
}
