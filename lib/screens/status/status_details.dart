import 'package:flutter/material.dart';
import 'package:people_talk/themes/app_text_style.dart';

class StatusDetails extends StatelessWidget {
  final String statusImage, statusTitle;
  const StatusDetails({super.key, required this.statusImage, required this.statusTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Status Detail", style: AppTextStyle.h1),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(statusImage!),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(statusTitle, style: AppTextStyle.h1),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
