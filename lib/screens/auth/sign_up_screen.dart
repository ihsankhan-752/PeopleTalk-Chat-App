import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:people_talk/constants/text_controller.dart';
import 'package:people_talk/screens/auth/login_screen.dart';
import 'package:people_talk/services/auth_services.dart';
import 'package:provider/provider.dart';

import '../../constants/app_text.dart';
import '../../constants/app_text_style.dart';
import '../../constants/loading_indicator.dart';
import '../../controllers/visibility_controller.dart';
import '../../widgets/buttons.dart';
import '../../widgets/custom_text_input.dart';
import '../../widgets/logo_widget.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    AppTextControllers appTextControllers = AppTextControllers();
    final authController = Provider.of<AuthServices>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              const LogoWidget(),
              const SizedBox(height: 25),
              Text(AppText.createAnAccount, style: AppTextStyle.h1),
              const SizedBox(height: 20),
              Text(
                "${AppText.username} *",
                style: AppTextStyle.h1.copyWith(fontSize: 12),
              ),
              const SizedBox(height: 5),
              CustomTextInput(
                hintText: AppText.username,
                controller: appTextControllers.usernameController,
              ),
              const SizedBox(height: 15),
              Text(
                "${AppText.email} *",
                style: AppTextStyle.h1.copyWith(fontSize: 12),
              ),
              const SizedBox(height: 5),
              CustomTextInput(
                hintText: AppText.email,
                controller: appTextControllers.emailController,
              ),
              const SizedBox(height: 15),
              Text(
                "${AppText.contact} *",
                style: AppTextStyle.h1.copyWith(fontSize: 12),
              ),
              const SizedBox(height: 5),
              CustomTextInput(
                inputType: TextInputType.number,
                hintText: AppText.contact,
                controller: appTextControllers.contactController,
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
              const SizedBox(height: 20),
              authController.isLoading
                  ? Center(
                      child: spinKit2,
                    )
                  : PrimaryButton(
                      title: AppText.create,
                      onPressed: () async {
                        await authController.userSignUp(
                          username: appTextControllers.usernameController.text,
                          email: appTextControllers.emailController.text,
                          password: appTextControllers.passwordController.text,
                          contact: int.tryParse(appTextControllers.contactController.text),
                        );
                      },
                    ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Get.to(() => const LoginScreen());
                },
                child: Center(
                  child: Text(AppText.alreadyHaveAcc, style: AppTextStyle.h1),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
