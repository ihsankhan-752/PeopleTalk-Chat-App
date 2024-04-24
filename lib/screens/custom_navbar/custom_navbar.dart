import 'package:flutter/material.dart';
import 'package:people_talk/constants/app_assets.dart';
import 'package:people_talk/constants/lists.dart';
import 'package:people_talk/controllers/get_user_data.dart';
import 'package:people_talk/screens/custom_navbar/widgets/navbar_tabs.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../services/notification_services.dart';

class CustomNavBar extends StatefulWidget {
  const CustomNavBar({super.key});

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  NotificationServices notificationServices = NotificationServices();

  int _currentIndex = 0;

  @override
  void initState() {
    _loadUserInformation();
    notificationServices.getPermission();
    notificationServices.getDeviceToken();
    notificationServices.initNotification(context);
    super.initState();
  }

  _loadUserInformation() async {
    await Provider.of<GetUserData>(context, listen: false).getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NavBarTabs(
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
                image: AppAssets.messageIcon,
                title: "Messages",
                imageColor: _currentIndex == 0 ? AppColors.primaryWhite : AppColors.primaryGrey,
                textColor: _currentIndex == 0 ? AppColors.primaryWhite : AppColors.primaryGrey,
              ),
              NavBarTabs(
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
                image: AppAssets.communityIcon,
                title: "Groups",
                imageColor: _currentIndex == 1 ? AppColors.primaryWhite : AppColors.primaryGrey,
                textColor: _currentIndex == 1 ? AppColors.primaryWhite : AppColors.primaryGrey,
              ),
              NavBarTabs(
                onPressed: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                },
                image: AppAssets.notificationIcon,
                title: "Notifications",
                imageColor: _currentIndex == 2 ? AppColors.primaryWhite : AppColors.primaryGrey,
                textColor: _currentIndex == 2 ? AppColors.primaryWhite : AppColors.primaryGrey,
              ),
              NavBarTabs(
                onPressed: () {
                  setState(() {
                    _currentIndex = 3;
                  });
                },
                image: AppAssets.personIcon,
                title: "Profile",
                imageColor: _currentIndex == 3 ? AppColors.primaryWhite : AppColors.primaryGrey,
                textColor: _currentIndex == 3 ? AppColors.primaryWhite : AppColors.primaryGrey,
              ),
            ],
          ),
        ),
      ),
      body: screens[_currentIndex],
    );
  }
}
