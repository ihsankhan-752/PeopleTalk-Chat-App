import 'package:flutter/material.dart';

import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_text_style.dart';

class UserProfileCardWidget extends StatelessWidget {
  final String? titleFirstLetter, title, subTitle;
  final Widget? bottomWidget;
  final Widget? trailingWidget;
  final Function()? onPressed;
  const UserProfileCardWidget(
      {super.key, this.titleFirstLetter, this.title, this.subTitle, this.bottomWidget, this.onPressed, this.trailingWidget});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () {},
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 08),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primaryBlack,
                  child: Center(
                    child: Text(titleFirstLetter!, style: AppTextStyle.h1.copyWith(fontSize: 20)),
                  ),
                ),
                title: Text(
                  title!,
                  style: AppTextStyle.h1.copyWith(
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  subTitle!,
                  style: AppTextStyle.h1.copyWith(
                    color: AppColors.primaryGrey,
                    fontSize: 12,
                  ),
                ),
                trailing: trailingWidget ?? const SizedBox(),
              ),
            ),
            bottomWidget ?? const SizedBox(),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
