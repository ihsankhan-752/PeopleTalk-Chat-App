import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:people_talk/controllers/get_user_data.dart';
import 'package:people_talk/screens/custom_navbar/profile/friends/tabs/received_requests_tab.dart';
import 'package:people_talk/screens/custom_navbar/profile/friends/tabs/send_requests_tab.dart';
import 'package:provider/provider.dart';

import '../../../../constants/app_colors.dart';
import '../../../../widgets/buttons.dart';

class FriendRequestScreen extends StatefulWidget {
  const FriendRequestScreen({super.key});

  @override
  State<FriendRequestScreen> createState() => _FriendRequestScreenState();
}

class _FriendRequestScreenState extends State<FriendRequestScreen> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<GetUserData>(context).userModel;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Friend Requests"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 45,
              width: Get.width,
              decoration: BoxDecoration(
                color: AppColors.primaryBlack,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SuggestionButton(
                      title: "Received",
                      bgColor: _currentIndex == 0 ? AppColors.primaryColor : AppColors.primaryBlack,
                      onPressed: () {
                        setState(() {
                          _currentIndex = 0;
                        });
                      },
                    ),
                    SuggestionButton(
                      title: "Sent",
                      bgColor: _currentIndex == 1 ? AppColors.primaryColor : AppColors.primaryBlack,
                      onPressed: () {
                        setState(() {
                          _currentIndex = 1;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (_currentIndex == 0) ...{
              const ReceivedRequestsTab(),
            },
            if (_currentIndex == 1) ...{
              const SendRequestsTab(),
            }
          ],
        ),
      ),
    );
  }
}
