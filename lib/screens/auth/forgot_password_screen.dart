import 'package:flutter/material.dart';
import 'package:people_talk/services/auth_services.dart';
import 'package:people_talk/utils/text_controller.dart';
import 'package:provider/provider.dart';

import '../../themes/app_colors.dart';
import '../../themes/app_text_style.dart';
import '../../utils/app_text.dart';
import '../../widgets/buttons.dart';
import '../../widgets/custom_text_input.dart';
import '../../widgets/logo_widget.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

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
            Text(AppText.resetYourEmail, style: AppTextStyle.h1),
            const SizedBox(height: 20),
            Text(
              "${AppText.email} *",
              style: AppTextStyle.h1.copyWith(fontSize: 12),
            ),
            const SizedBox(height: 5),
            CustomTextInput(hintText: AppText.email, controller: appTextControllers.emailController),
            const SizedBox(height: 20),
            authServices.isLoading
                ? Center(
                    child: CircularProgressIndicator(color: AppColors.mainColor),
                  )
                : PrimaryButton(
                    onPressed: () {
                      authServices.resetPassword(appTextControllers.emailController.text);
                    },
                    title: AppText.reset,
                  ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
