import 'package:audio_wave/audio_wave.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:people_talk/constants/app_text_style.dart';
import 'package:people_talk/services/chat_services.dart';
import 'package:people_talk/widgets/show_custom_msg.dart';
import 'package:provider/provider.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/lists.dart';
import '../../../../controllers/audio_recording_controller.dart';

class AudioSendingWidget extends StatelessWidget {
  final String userId;
  final String docId;
  const AudioSendingWidget({super.key, required this.userId, required this.docId});

  @override
  Widget build(BuildContext context) {
    final audioController = Provider.of<AudioRecordingController>(context);
    return Row(
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
              StreamBuilder<RecordingDisposition>(
                stream: audioController.recorder.onProgress,
                builder: (context, snapshot) {
                  final duration = snapshot.hasData ? snapshot.data!.duration : Duration.zero;
                  String twoDigits(int n) {
                    return n.toString().padLeft(2, '0');
                  }

                  final twoDigitsMin = twoDigits(duration.inMinutes.remainder(60));
                  final twoDigitsSec = twoDigits(duration.inSeconds.remainder(60));

                  return Text(
                    "$twoDigitsMin:$twoDigitsSec",
                    style: AppTextStyle.h1,
                  );
                },
              ),
              const SizedBox(width: 20),
              if (audioController.isRecording)
                AudioWave(
                  animation: true,
                  height: 35,
                  width: 80,
                  spacing: 5,
                  animationLoop: 100,
                  beatRate: const Duration(milliseconds: 120),
                  bars: audioBubbles,
                ),
              const Spacer(),
              InkWell(
                onTap: () {
                  audioController.setMicValue(false);
                  audioController.stopOnly();
                },
                child: const Icon(Icons.delete_forever, color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
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
            onTap: () async {
              audioController.setMicValue(false);
              await audioController.stopAndSendAudioFile();
              if (audioController.audioUrl.isEmpty || audioController.audioUrl == "") {
                showCustomMsg("Voice Not Recorded");
              } else {
                await ChatServices().sendingAudioFileInChat(
                  context: context,
                  userId: userId,
                  docId: docId,
                  audioUrl: audioController.audioUrl,
                );
                audioController.deleteRecording();
              }
            },
            child: Icon(
              FontAwesomeIcons.paperPlane,
              color: Colors.teal.withOpacity(0.8),
            ),
          ),
        )
      ],
    );
  }
}
