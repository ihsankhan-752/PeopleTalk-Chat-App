import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:people_talk/screens/chat/group_chat/group_information.dart';
import 'package:people_talk/screens/chat/group_chat/widgets/audio_sending_widget_in_group.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/audio_recording_controller.dart';
import '../../../../controllers/group_chat_controller.dart';
import '../../../../models/group_chat_model.dart';
import '../../../../models/group_creating_model.dart';
import '../../../../themes/app_text_style.dart';
import '../../widgets/chat_input_bottom.dart';
import '../../widgets/show_model_sheet_for_options.dart';
import '../widgets/group_chat_card.dart';

class SendAndDisplayTextViewInGroup extends StatefulWidget {
  final GroupCreatingModel groupModel;

  const SendAndDisplayTextViewInGroup({super.key, required this.groupModel});

  @override
  State<SendAndDisplayTextViewInGroup> createState() => _SendAndDisplayTextViewInGroupState();
}

class _SendAndDisplayTextViewInGroupState extends State<SendAndDisplayTextViewInGroup> {
  TextEditingController msgController = TextEditingController();
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
        title: Text(widget.groupModel.groupName!, style: AppTextStyle.h1),
        actions: [
          InkWell(
            onTap: () {
              Get.to(() => GroupInformation(groupCreatingModel: widget.groupModel));
            },
            child: const Icon(Icons.info_outline),
          ),
          const SizedBox(width: 10),
        ],
      ),
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
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('groupChat')
                    .doc(widget.groupModel.groupId)
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
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      GroupChatModel groupChatModel = GroupChatModel.fromDoc(snapshot.data!.docs[index]);
                      return GroupChatCard(groupChatModel: groupChatModel);
                    },
                  );
                },
              ),
            ),
            audioController.isMicOn
                ? AudioSendingWidgetInGroup(groupCreatingModel: widget.groupModel)
                : Consumer<GroupChatController>(
                    builder: (_, groupChatController, __) {
                      return ChatInputBottomSection(
                        onPressed: () {
                          groupChatController.sendingTextMsgInGroup(
                            context: context,
                            docId: widget.groupModel.groupId!,
                            msg: msgController.text,
                          );
                          setState(() {
                            msgController.clear();
                          });
                        },
                        onAttachmentClicked: () {
                          showModelSheetForOptions(context);
                        },
                        chatController: msgController,
                        onMicClicked: () {
                          audioController.record();
                          audioController.setMicValue(true);
                        },
                      );
                    },
                  )
          ],
        ),
      ),
    );
  }
}
