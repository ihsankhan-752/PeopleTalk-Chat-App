import 'package:flutter/material.dart';
import 'package:people_talk/constants/app_text_style.dart';

class PhotoFullView extends StatelessWidget {
  final String image;
  const PhotoFullView({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Photo View", style: AppTextStyle.h1),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(image),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
