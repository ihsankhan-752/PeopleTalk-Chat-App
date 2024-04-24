import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:people_talk/constants/text_controller.dart';
import 'package:people_talk/controllers/audio_recording_controller.dart';
import 'package:people_talk/controllers/loading_controller.dart';
import 'package:people_talk/services/chat_services.dart';
import 'package:provider/provider.dart';

import '../../../../../models/chat_model.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_style.dart';
import '../../widgets/group_and_one_to_one_common_widgets/audio_sending_widget.dart';
import '../../widgets/group_and_one_to_one_common_widgets/chat_input_bottom.dart';
import '../../widgets/group_and_one_to_one_common_widgets/show_model_sheet_for_options.dart';
import '../widgets/chat_card.dart';

class SendAndDisplayTextView extends StatefulWidget {
  final String docId;
  final String userId;
  final String username;
  final String userImage;
  const SendAndDisplayTextView(
      {super.key, required this.docId, required this.userId, required this.username, required this.userImage});

  @override
  State<SendAndDisplayTextView> createState() => _SendAndDisplayTextViewState();
}

class _SendAndDisplayTextViewState extends State<SendAndDisplayTextView> {
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
        centerTitle: true,
        title: Row(
          children: [
            widget.userImage == ""
                ? const SizedBox()
                : CircleAvatar(
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
                        return ChatCard(
                          chatModel: chatModel,
                          chatId: widget.docId,
                          msgId: snapshot.data!.docs[index].id,
                        );
                      },
                    );
                  }),
            ),
            audioController.isMicOn
                ? AudioSendingWidget(userId: widget.userId, docId: widget.docId)
                : Consumer<LoadingController>(
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
                          ChatServices().sendTextInChat(
                            context: context,
                            msg: appTextControllers.chatController.text,
                            userId: widget.userId,
                            docId: widget.docId,
                          );
                          setState(() {
                            FocusScope.of(context).unfocus();

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
