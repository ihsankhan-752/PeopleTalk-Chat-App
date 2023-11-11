import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:people_talk/screens/contacts_screen/contact_screen.dart';
import 'package:people_talk/screens/home/widgets/status_view.dart';
import 'package:people_talk/screens/home/widgets/user_chat_list.dart';
import 'package:people_talk/screens/home/widgets/user_group_list.dart';
import 'package:people_talk/screens/settings_screen/settings_screen.dart';
import 'package:people_talk/screens/status/upload_status_screen.dart';
import 'package:people_talk/services/notification_services.dart';
import 'package:people_talk/themes/app_text_style.dart';
import 'package:people_talk/widgets/search_text_input.dart';

import '../../themes/app_colors.dart';
import '../../utils/app_text.dart';
import '../group_making/contact_for_group_making.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationServices notificationServices = NotificationServices();
  String selectedValue = 'Users';

  void _handleMenuItemClick(String item) {
    setState(() {
      selectedValue = item;
    });
  }

  @override
  void initState() {
    notificationServices.getPermission();
    notificationServices.getDeviceToken();
    notificationServices.initNotification(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.teal.withOpacity(0.5),
          title: Text(AppText.peopleTalk, style: AppTextStyle.h1),
          actions: [
            InkWell(
                onTap: () {
                  Get.to(() => const SettingsScreen());
                },
                child: Icon(Icons.settings, color: AppColors.primaryWhite)),
            const SizedBox(width: 20),
          ],
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.sizeOf(context).height * 0.12,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
                color: Colors.teal.withOpacity(0.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SearchTextInput(),
                      PopupMenuButton<String>(
                        icon: Icon(Icons.filter_alt, size: 25, color: AppColors.primaryWhite),
                        onSelected: _handleMenuItemClick,
                        itemBuilder: (BuildContext context) {
                          return ['Users', 'Groups', 'Status'].map(
                            (String item) {
                              return PopupMenuItem<String>(
                                value: item,
                                child: Text(item),
                              );
                            },
                          ).toList();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (selectedValue == "Users") const UserChatList(),
            if (selectedValue == "Groups") const UserGroupList(),
            if (selectedValue == "Status") const StatusView(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal.withOpacity(0.5),
          onPressed: () {
            if (selectedValue == 'Users') {
              Get.to(() => const ContactsScreen());
            }
            if (selectedValue == "Groups") {
              Get.to(() => const ContactsScreenForGroupMaking());
            }
            if (selectedValue == "Status") {
              Get.to(() => const StatusScreen());
            }
          },
          child: Icon(
            selectedValue == "Users"
                ? Icons.add
                : selectedValue == "Groups"
                    ? Icons.group
                    : Icons.upload,
            color: AppColors.primaryWhite,
          ),
        ),
      ),
    );
  }
}
