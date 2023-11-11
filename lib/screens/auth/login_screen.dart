import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:people_talk/screens/auth/forgot_password_screen.dart';
import 'package:people_talk/screens/auth/sign_up_screen.dart';
import 'package:people_talk/services/auth_services.dart';
import 'package:people_talk/themes/app_text_style.dart';
import 'package:people_talk/utils/app_text.dart';
import 'package:people_talk/utils/text_controller.dart';
import 'package:people_talk/widgets/buttons.dart';
import 'package:people_talk/widgets/custom_text_input.dart';
import 'package:people_talk/widgets/logo_widget.dart';
import 'package:provider/provider.dart';

import '../../controllers/visibility_controller.dart';
import '../../themes/app_colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppTextControllers appTextControllers = AppTextControllers();
    final authServices = Provider.of<AuthServices>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LogoWidget(),
            const SizedBox(height: 25),
            Text(AppText.welcomeBack, style: AppTextStyle.h1),
            const SizedBox(height: 20),
            Text(
              "${AppText.email} *",
              style: AppTextStyle.h1.copyWith(fontSize: 12),
            ),
            const SizedBox(height: 5),
            CustomTextInput(
              validator: (v) {},
              hintText: AppText.email,
              controller: appTextControllers.emailController,
            ),
            const SizedBox(height: 15),
            Text(
              "${AppText.password} *",
              style: AppTextStyle.h1.copyWith(fontSize: 12),
            ),
            const SizedBox(height: 5),
            Consumer<VisibilityController>(
              builder: (_, value, __) {
                return CustomTextInput(
                  validator: (v) {},
                  controller: appTextControllers.passwordController,
                  hintText: "Password",
                  isIconReq: true,
                  isVisible: value.isVisible,
                  widget: GestureDetector(
                    onTap: () {
                      value.hideAndUnHideVisibility();
                    },
                    child: Icon(value.isVisible ? Icons.visibility_off : Icons.visibility),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                Get.to(() => const ForgotPasswordScreen());
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(AppText.forgotPassword, style: AppTextStyle.h1.copyWith(fontSize: 14)),
              ),
            ),
            const SizedBox(height: 20),
            authServices.isLoading
                ? Center(
                    child: CircularProgressIndicator(color: AppColors.mainColor),
                  )
                : PrimaryButton(
                    title: AppText.login,
                    onPressed: () {
                      authServices.signIn(
                        appTextControllers.emailController.text,
                        appTextControllers.passwordController.text,
                      );
                    },
                  ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Get.to(() => const SignUpScreen());
              },
              child: Center(
                child: Text(AppText.dontHaveAcc, style: AppTextStyle.h1),
              ),
            )
          ],
        ),
      ),
    );
  }
}
