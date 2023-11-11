import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:people_talk/screens/auth/login_screen.dart';
import 'package:people_talk/services/auth_services.dart';
import 'package:people_talk/themes/app_colors.dart';
import 'package:people_talk/utils/text_controller.dart';
import 'package:people_talk/widgets/show_custom_msg.dart';
import 'package:provider/provider.dart';

import '../../controllers/visibility_controller.dart';
import '../../themes/app_text_style.dart';
import '../../utils/app_text.dart';
import '../../widgets/buttons.dart';
import '../../widgets/custom_text_input.dart';
import '../../widgets/logo_widget.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    AppTextControllers appTextControllers = AppTextControllers();
    final authController = Provider.of<AuthServices>(context);

    // Regular expression for a valid contact number with a country code.
    RegExp contactRegExp = RegExp(r'^\+\d{1,15}$');

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
                validator: (v) {},
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
                validator: (v) {},
              ),
              const SizedBox(height: 15),
              Text(
                "${AppText.contact} *",
                style: AppTextStyle.h1.copyWith(fontSize: 12),
              ),
              const SizedBox(height: 5),
              CustomTextInput(
                hintText: AppText.contact,
                controller: appTextControllers.contactController,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a contact number.';
                  }
                  if (!contactRegExp.hasMatch(value)) {
                    return 'Please enter a valid contact number with a country code (e.g., +123456789).';
                  }
                  return null; // Validation passed
                },
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
              const SizedBox(height: 20),
              authController.isLoading
                  ? Center(
                      child: CircularProgressIndicator(color: AppColors.mainColor),
                    )
                  : PrimaryButton(
                      title: AppText.create,
                      onPressed: () async {
                        final contactInput = appTextControllers.contactController.text;
                        if (!contactRegExp.hasMatch(contactInput)) {
                          showCustomMsg(
                              'Invalid contact number. Please enter a valid contact number with a country code.');
                        } else {
                          await authController.userSignUp(
                            username: appTextControllers.usernameController.text,
                            email: appTextControllers.emailController.text,
                            password: appTextControllers.passwordController.text,
                            contact: int.tryParse(contactInput.substring(1)),
                          );
                        }
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
