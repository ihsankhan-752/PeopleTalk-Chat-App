import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:people_talk/controllers/audio_recording_controller.dart';
import 'package:people_talk/utils/text_controller.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/chat_controller.dart';
import '../../../../models/chat_model.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_text_style.dart';
import '../../widgets/audio_sending_widget.dart';
import '../../widgets/chat_card.dart';
import '../../widgets/chat_input_bottom.dart';
import '../../widgets/show_model_sheet_for_options.dart';

class SendAndDisplayTestView extends StatefulWidget {
  final String docId;
  final String userId;
  final String username;
  final String userImage;
  const SendAndDisplayTestView(
      {super.key, required this.docId, required this.userId, required this.username, required this.userImage});

  @override
  State<SendAndDisplayTestView> createState() => _SendAndDisplayTestViewState();
}

class _SendAndDisplayTestViewState extends State<SendAndDisplayTestView> {
  AppTextControllers appTextControllers = AppTextControllers();
  bool isMic = false;

  @override
  void initState() {
    Provider.of<AudioRecordingController>(context, listen: false).initRecorder();
    super.initState();
  }

  @override
  void dispose() {
    Provider.of<AudioRecordingController>(context, listen: false).recorder;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioController = Provider.of<AudioRecordingController>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.withOpacity(0.5),
        title: Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(widget.userImage),
            ),
            const SizedBox(width: 20),
            Text(widget.username, style: AppTextStyle.h1),
          ],
        ),
      ),
      backgroundColor: AppColors.primaryBlack,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/bg.jpg'),
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.srcATop),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chat')
                      .doc(widget.docId)
                      .collection('messages')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text("No Chat Found!", style: AppTextStyle.h1),
                      );
                    }
                    return ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.only(bottom: 10),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        ChatModel chatModel = ChatModel.fromDoc(snapshot.data!.docs[index]);
                        return ChatCard(chatModel: chatModel);
                      },
                    );
                  }),
            ),
            audioController.isMicOn
                ? AudioSendingWidget(userId: widget.userId, docId: widget.docId)
                : Consumer<ChatController>(
                    builder: (context, chatController, child) {
                      return ChatInputBottomSection(
                        onMicClicked: () async {
                          audioController.record();
                          audioController.setMicValue(true);
                        },
                        onAttachmentClicked: () {
                          showModelSheetForOptions(context);
                        },
                        chatController: appTextControllers.chatController,
                        onPressed: () {
                          chatController.sendTextInChat(
                            context: context,
                            msg: appTextControllers.chatController.text,
                            userId: widget.userId,
                            docId: widget.docId,
                          );
                          setState(() {
                            appTextControllers.chatController.clear();
                          });
                        },
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
