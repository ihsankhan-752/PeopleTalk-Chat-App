import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NavBarTabs extends StatelessWidget {
  final String? image;
  final String? title;
  final Function()? onPressed;
  final Color? imageColor;
  final Color? textColor;
  const NavBarTabs({super.key, this.image, this.title, this.onPressed, this.imageColor, this.textColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 22,
            width: 22,
            child: Image.asset(image!, color: imageColor),
          ),
          const SizedBox(height: 5),
          Text(
            title!,
            style: GoogleFonts.acme(
              fontSize: 12,
              letterSpacing: 0.8,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
