import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "PeopleTalk",
        style: TextStyle(
          color: Colors.green,
          fontSize: 47,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
