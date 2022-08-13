import 'package:auto_route/auto_route.dart';
import '../features/authentication/pages/login/login_page.dart';
import '../features/authentication/pages/register/register_page.dart';
import '../features/home/pages/home_page.dart';
import '../features/main_tab_bar/pages/main_tabbar_page.dart';
import 'guards.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      page: MainTabBarPage,
      initial: true,
      guards: [AuthGuard],
      children: [
        AutoRoute(
          page: HomePage,
          initial: true,
        ),
      ]
    ),
    AutoRoute(
      page: LoginPage,
    ),
    AutoRoute(
      page: RegisterPage,
    ),
  ],
)
class $AppRouter {}
