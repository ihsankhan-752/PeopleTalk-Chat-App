import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:people_talk/controllers/loading_controller.dart';
import 'package:provider/provider.dart';

import '../../../themes/app_colors.dart';

class ChatInputBottomSection extends StatelessWidget {
  final Function()? onPressed;
  final Function()? onAttachmentClicked;
  final Function()? onMicClicked;
  final TextEditingController chatController;
  const ChatInputBottomSection(
      {super.key, this.onPressed, required this.chatController, this.onAttachmentClicked, this.onMicClicked});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width * 0.8,
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: AppColors.inputColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: chatController,
                    cursorColor: AppColors.primaryGrey,
                    style: TextStyle(
                      color: AppColors.primaryGrey,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(top: 1, left: 8),
                      border: InputBorder.none,
                      hintText: 'Message',
                      hintStyle: TextStyle(
                        color: AppColors.primaryGrey,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: onAttachmentClicked ?? () {},
                          child: Icon(
                            Icons.attachment,
                            color: AppColors.primaryGrey,
                          )),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: onMicClicked ?? () {},
                        child: Icon(
                          Icons.mic,
                          color: Colors.teal.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.inputColor,
            ),
            child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: onPressed ?? () {},
                child: Consumer<LoadingController>(
                  builder: (_, loadingController, __) {
                    return loadingController.isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.teal.shade500,
                            ),
                          )
                        : Icon(
                            FontAwesomeIcons.paperPlane,
                            color: Colors.teal.withOpacity(0.8),
                          );
                  },
                )),
          )
        ],
      ),
    );
  }
}
