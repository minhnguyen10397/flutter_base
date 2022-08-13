import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gold/common/dialogs/provider.dart';
import 'package:gold/common/styles.dart';
import 'package:gold/common/widgets/buttons.dart';
import 'package:gold/features/authentication/cubit/register/register_cubit.dart';
import 'package:gold/common/widgets/app_scaffold.dart';
import 'package:gold/routes/routes.gr.dart';

import '../../../../common/bloc_status.dart';
import '../../../../common/colors.dart';
import '../../../../common/constants.dart';
import '../../../../common/widgets/drop_down.dart';
import '../../../../common/widgets/textfields.dart';

class RegisterPage extends StatelessWidget with AutoRouteWrapper {
  const RegisterPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();
    return AppScaffold(
      body: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state.status == BlocStatus.success) {
            DialogProvider.instance.showConfirmDialog(
              context,
              title: 'Chúc mừng',
              message: 'Bạn đã đăng ký thành công.',
              positiveCallback: () {
                context.router.pop();
              },
            );
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
                  'Sign Up',
                  style: UITextStyle.bold.copyWith(
                    fontSize: 22,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Please enter the below details to create your profile',
                  style: UITextStyle.light,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              UITextField(
                controller: cubit.firstNameController,
                labelText: 'First Name',
                enable: !state.status.isLoading,
                textInputAction: TextInputAction.next,
                onChanged: (_) => cubit.validateData(),
              ),
              const SizedBox(
                height: 17,
              ),
              UITextField(
                controller: cubit.lastNameController,
                labelText: 'Last Name',
                enable: !state.status.isLoading,
                textInputAction: TextInputAction.next,
                onChanged: (_) => cubit.validateData(),
              ),
              const SizedBox(
                height: 17,
              ),
              UITextField(
                controller: cubit.emailController,
                labelText: 'Email',
                enable: !state.status.isLoading,
                textInputAction: TextInputAction.next,
                onChanged: (_) => cubit.validateData(),
              ),
              const SizedBox(
                height: 17,
              ),
              UITextField(
                controller: cubit.usernameController,
                labelText: 'Username',
                enable: !state.status.isLoading,
                textInputAction: TextInputAction.next,
                onChanged: (_) => cubit.validateData(),
              ),
              const SizedBox(
                height: 17,
              ),
              UITextField(
                controller: cubit.passwordController,
                labelText: 'Password',
                enable: !state.status.isLoading,
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
                height: 18,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Date of Birth',
                  style: UITextStyle.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomDropdown<String>(
                      currentIndex: state.dayIndex,
                      child: Text(
                        'Day',
                        style: UITextStyle.regular,
                      ),
                      onChange: (String? value, int index) {
                        cubit.chooseDayOfBirth(index);
                      },
                      items: AppConstants.dates.asMap().entries.map((item) {
                        return DropdownItem<String>(
                          value: item.value,
                          child: Text(
                            item.value,
                            style: UITextStyle.regular,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: CustomDropdown<String>(
                      currentIndex: state.monthIndex,
                      child: Text(
                        'Month',
                        style: UITextStyle.regular,
                      ),
                      onChange: (String? value, int index) {
                        cubit.chooseMonthOfBirth(index);
                      },
                      items: AppConstants.months.asMap().entries.map((item) {
                        return DropdownItem<String>(
                          value: item.value,
                          child: Text(
                            item.value,
                            style: UITextStyle.regular,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: CustomDropdown<String>(
                      currentIndex: state.yearIndex,
                      child: Text(
                        'Year',
                        style: UITextStyle.regular,
                      ),
                      onChange: (String? value, int index) {
                        cubit.chooseYearOfBirth(index);
                      },
                      items: cubit.years.asMap().entries.map((item) {
                        return DropdownItem<String>(
                          value: item.value,
                          child: Text(
                            item.value,
                            style: UITextStyle.regular,
                          ),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 19,
              ),
              PrimaryButton(
                width: double.infinity,
                enabled: state.enableNextStep,
                isLoading: state.status == BlocStatus.loading,
                title: 'SIGN UP',
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  cubit.register();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
