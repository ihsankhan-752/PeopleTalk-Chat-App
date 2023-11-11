import 'package:audio_wave/audio_wave.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:people_talk/models/chat_model.dart';
import 'package:people_talk/screens/chat/widgets/photo_full_view.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

import '../../../themes/app_colors.dart';
import '../../../themes/app_text_style.dart';
import '../../../utils/const.dart';

class ChatCard extends StatefulWidget {
  final ChatModel chatModel;
  const ChatCard({super.key, required this.chatModel});

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  final audioPlayer = AudioPlayer();

  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    audioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        isPlaying = event == PlayerState.playing;
      });
    });
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: Row(
        mainAxisAlignment: widget.chatModel.senderId == FirebaseAuth.instance.currentUser!.uid
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 15,
            backgroundImage: NetworkImage(widget.chatModel.senderImage!),
          ),
          const SizedBox(width: 05),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 07, vertical: 05),
            decoration: BoxDecoration(
              color: widget.chatModel.senderId == FirebaseAuth.instance.currentUser!.uid
                  ? const Color(0xff1C2E46)
                  : const Color(0xff095C4B),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.chatModel.msg != "")
                  Text(
                    widget.chatModel.msg!,
                    style: AppTextStyle.h1.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                if (widget.chatModel.image != "")
                  InkWell(
                    onTap: () {
                      Get.to(() => PhotoFullView(image: widget.chatModel.image!));
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.network(widget.chatModel.image!, fit: BoxFit.cover),
                    ),
                  ),
                if (widget.chatModel.file != "")
                  InkWell(
                    onTap: () {
                      openFileURL(widget.chatModel.file!);
                    },
                    child: Image.network(
                      "https://www.iconpacks.net/icons/2/free-file-icon-1453-thumb.png",
                      height: 40,
                      width: 40,
                      color: AppColors.primaryWhite,
                    ),
                  ),
                if (widget.chatModel.audioFile != "")
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          if (isPlaying) {
                            await audioPlayer.pause();
                          } else {
                            await audioPlayer.play(UrlSource(widget.chatModel.audioFile!));
                          }
                        },
                        icon: isPlaying
                            ? Icon(Icons.pause, color: AppColors.primaryWhite)
                            : Icon(
                                Icons.play_arrow,
                                color: AppColors.primaryWhite,
                              ),
                      ),
                      isPlaying
                          ? AudioWave(
                              animation: true,
                              height: 25,
                              width: 60,
                              spacing: 4,
                              animationLoop: 100,
                              beatRate: const Duration(milliseconds: 120),
                              bars: audioBubbles,
                            )
                          : const AudioWaveForDisplayAudio(),
                      const SizedBox(width: 05),
                      if (isPlaying)
                        Text(
                          formatTime(duration - position),
                          style: TextStyle(
                            color: AppColors.primaryWhite,
                          ),
                        ),
                    ],
                  ),
                widget.chatModel.image == "" && widget.chatModel.file == ""
                    ? const SizedBox(height: 2)
                    : const SizedBox(height: 2),
                Text(
                  timeago.format(widget.chatModel.createdAt!),
                  style: AppTextStyle.h1.copyWith(
                    fontSize: 8,
                    color: AppColors.primaryGrey,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void openFileURL(String url) async {
    if (!await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }
}
