import 'package:flutter/material.dart';
import 'package:people_talk/constants/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_text_style.dart';
import '../../../controllers/loading_controller.dart';
import '../../../controllers/visibility_controller.dart';
import '../../../services/auth_services.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/custom_text_input.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Change Password",
          style: AppTextStyle.h1,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: Image.asset('assets/images/change.png'),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                "Change your password for\nmore security!",
                textAlign: TextAlign.center,
                style: AppTextStyle.h1.copyWith(
                  fontSize: 18,
                  color: AppColors.primaryGrey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Consumer<VisibilityController>(
                    builder: (context, passwordVisibilityController, child) {
                      return CustomTextInput(
                        isIconReq: true,
                        isVisible: passwordVisibilityController.isOldPasswordVisible,
                        hintText: "Old Password",
                        controller: _oldPasswordController,
                        widget: GestureDetector(
                          onTap: () {
                            passwordVisibilityController.toggleOldPasswordVisibility();
                          },
                          child: Icon(
                            passwordVisibilityController.isOldPasswordVisible ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Consumer<VisibilityController>(
                    builder: (context, confirmPasswordVisibilityController, child) {
                      return CustomTextInput(
                        isIconReq: true,
                        isVisible: confirmPasswordVisibilityController.isPasswordVisible,
                        hintText: "New Password",
                        controller: _newPasswordController,
                        widget: GestureDetector(
                          onTap: () {
                            confirmPasswordVisibilityController.togglePasswordVisibility();
                          },
                          child: Icon(
                            confirmPasswordVisibilityController.isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Consumer<VisibilityController>(
                    builder: (context, confirmPasswordVisibilityController, child) {
                      return CustomTextInput(
                        isIconReq: true,
                        isVisible: confirmPasswordVisibilityController.isConfirmPasswordVisible,
                        hintText: "Confirm",
                        controller: _confirmPasswordController,
                        widget: GestureDetector(
                          onTap: () {
                            confirmPasswordVisibilityController.toggleConfirmPasswordVisibility();
                          },
                          child: Icon(
                            confirmPasswordVisibilityController.isConfirmPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 50),
                  Consumer<LoadingController>(builder: (context, loadingController, child) {
                    return loadingController.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : PrimaryButton(
                            onPressed: () async {
                              AuthServices.changeUserPasswordCreative(
                                context: context,
                                oldPassword: _oldPasswordController.text,
                                newPassword: _newPasswordController.text,
                                confirmPassword: _confirmPasswordController.text,
                              );
                              setState(() {
                                _oldPasswordController.clear();
                                _newPasswordController.clear();
                                _confirmPasswordController.clear();
                              });
                            },
                            title: "Change Password",
                          );
                  })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
