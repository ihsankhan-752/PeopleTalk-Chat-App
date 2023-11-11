import 'package:flutter/material.dart';
import 'package:people_talk/services/auth_services.dart';
import 'package:people_talk/themes/app_colors.dart';
import 'package:people_talk/themes/app_text_style.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings", style: AppTextStyle.h1),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              AuthServices().logOut();
            },
            leading: Icon(Icons.logout, color: AppColors.primaryWhite),
            title: Text("LogOut", style: AppTextStyle.h1),
          ),
          const Divider(height: 0.1),
        ],
      ),
    );
  }
}
