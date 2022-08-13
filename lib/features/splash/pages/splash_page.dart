import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gold/di/get_it.dart';
import 'package:gold/features/app_view.dart';
import 'package:page_transition/page_transition.dart';

import '../../../common/colors.dart';
import '../../profile/cubit/user/user_controller_cubit.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 2000,
      splashIconSize: double.infinity,
      splash: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Image(
            image: AssetImage("assets/images/splash_icon.png"),
            width: 261,
            height: 143,
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
      nextScreen: MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: getItInstance.get<UserControllerCubit>(),
          )
        ],
        child: AppView(),
      ),
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
      animationDuration: const Duration(milliseconds: 0),
      backgroundColor: UIColors.black,
    );
  }
}
