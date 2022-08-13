import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gold/features/profile/cubit/user/user_controller_cubit.dart';

import '../common/size.dart';
import '../di/get_it.dart';
import '../routes/routes.gr.dart';

class AppView extends StatelessWidget {
  AppView({Key? key}) : super(key: key);

  final router = getItInstance<AppRouter>();

  @override
  Widget build(BuildContext context) {
    _cacheImage(context);
    return BlocListener<UserControllerCubit, UserControllerState>(
      listenWhen: (pre, cur) {
        return pre.userType == UserType.AUTHENTICATED &&
            cur.userType == UserType.ANONYMOUS;
      },
      listener: (context, state) {
        if (state.userType == UserType.ANONYMOUS) {
          router.replaceAll([const LoginRoute()]);
        }
      },
      child: GestureDetector(
        onTap: () => _dismissKeyboardOnLostFocus(context),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Montserrat'),
          routerDelegate: router.delegate(),
          routeInformationParser: router.defaultRouteParser(),
          builder: (context, child) {
            AppSize.instance.init(context);
            return child!;
          },
        ),
      ),
    );
  }

  void _dismissKeyboardOnLostFocus(BuildContext ctx) {
    final FocusScopeNode currentFocus = FocusScope.of(ctx);
    if (!currentFocus.hasPrimaryFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  _cacheImage(BuildContext context) {
    // precacheImage(const AssetImage(''), context);
  }
}
