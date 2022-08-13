import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gold/common/constants.dart';
import 'package:gold/common/styles.dart';
import 'package:gold/common/widgets/buttons.dart';
import 'package:gold/common/widgets/app_scaffold.dart';
import 'package:gold/routes/routes.gr.dart';

import '../../../../common/bloc_status.dart';
import '../../../../common/colors.dart';
import '../../../../common/dialogs/provider.dart';
import '../../../../common/widgets/textfields.dart';
import '../../cubit/login/login_cubit.dart';

class LoginPage extends StatelessWidget with AutoRouteWrapper {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    return AppScaffold(
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status == BlocStatus.success) {
            context.router.replace(const MainTabBarRoute());
          } else if (state.status == BlocStatus.failure) {
            DialogProvider.instance.showConfirmDialog(
              context,
              message: state.errMsg ?? '',
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Image.asset(
                'assets/images/logo_icon.png',
                width: 169,
              ),
              const SizedBox(
                height: 53,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Sign In',
                  style: UITextStyle.bold.copyWith(
                    fontSize: 22,
                  ),
                ),
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Text(
              //     'Lorem Ipsum is simply dummy text of the',
              //     style: UITextStyle.light,
              //   ),
              // ),
              const SizedBox(
                height: 27,
              ),
              UITextField(
                controller: cubit.usernameController,
                labelText: 'Username',
                textInputAction: TextInputAction.next,
                onChanged: (_) => cubit.validateData(),
              ),
              const SizedBox(
                height: 20,
              ),
              UITextField(
                controller: cubit.passwordController,
                labelText: 'Password',
                isObscurePassword: state.isObscurePassword,
                suffixIcon: SizedBox(
                  height: 16,
                  width: 16,
                  child: Center(
                    child: SplashButton(
                      splashColor: Colors.transparent,
                      child: FaIcon(
                        state.isObscurePassword
                            ? FontAwesomeIcons.eyeSlash
                            : FontAwesomeIcons.eye,
                        color: UIColors.white,
                        size: 20,
                      ),
                      onTap: () => cubit.toggleShowPassword(),
                    ),
                  ),
                ),
                onChanged: (_) => cubit.validateData(),
              ),
              const SizedBox(
                height: 14,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: SplashButton(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: Text(
                    'Forgot Password?',
                    style: UITextStyle.regular,
                  ),
                ),
              ),
              const SizedBox(
                height: 36,
              ),
              PrimaryButton(
                width: double.infinity,
                enabled: state.enableNextStep,
                isLoading: state.status == BlocStatus.loading,
                title: 'SIGN IN',
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  cubit.login();
                },
              ),
              const SizedBox(
                height: 14,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    'Don\'t have an account?',
                    style: UITextStyle.light,
                  ),
                  SplashButton(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      context.router.push(const RegisterRoute());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        'Sign Up',
                        style: UITextStyle.bold.copyWith(
                          decoration: TextDecoration.underline,
                          decorationThickness: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'Or sign in with',
                style: UITextStyle.light,
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SplashButton(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        'assets/images/google_icon.png',
                        width: 51,
                        height: 51,
                      ),
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                    SplashButton(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        'assets/images/facebook_icon.png',
                        width: 51,
                        height: 51,
                      ),
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                    SplashButton(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        'assets/images/apple_icon.png',
                        width: 51,
                        height: 51,
                      ),
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 62,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'By continuing, you are accepting our\n',
                  style: UITextStyle.light,
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Terms & Conditions',
                      style: UITextStyle.bold,
                      recognizer: TapGestureRecognizer()..onTap = () {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy.',
                      style: UITextStyle.bold,
                      recognizer: TapGestureRecognizer()..onTap = () {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
