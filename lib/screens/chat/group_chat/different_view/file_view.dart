import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/file_controller.dart';
import '../../../../controllers/group_chat_controller.dart';
import '../../../../controllers/loading_controller.dart';
import '../../../../models/group_creating_model.dart';

class SendingAndViewFileInGroup extends StatefulWidget {
  final GroupCreatingModel groupCreatingModel;
  const SendingAndViewFileInGroup({super.key, required this.groupCreatingModel});

  @override
  State<SendingAndViewFileInGroup> createState() => _SendingAndViewFileInGroupState();
}

class _SendingAndViewFileInGroupState extends State<SendingAndViewFileInGroup> {
  @override
  Widget build(BuildContext context) {
    final fileController = Provider.of<FileController>(context);
    var loadingController = Provider.of<LoadingController>(context);
    final chatController = Provider.of<GroupChatController>(context);

    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () {
              fileController.deleteUploadPdf();
            },
            child: const Icon(Icons.close),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            backgroundColor: Colors.blueGrey,
            child: loadingController.isLoading
                ? CircularProgressIndicator(
                    color: Colors.teal.withOpacity(0.5),
                  )
                : const Icon(Icons.send),
            onPressed: () async {
              if (!loadingController.isLoading) {
                loadingController.setLoading(true);
                try {
                  await chatController.sendingFilesInGroup(
                    context: context,
                    file: fileController.pdf!,
                    docId: widget.groupCreatingModel.groupId!,
                  );
                  fileController.deleteUploadPdf();

                  setState(() {
                    loadingController.setLoading(false);
                  });
                } catch (e) {
                  loadingController.setLoading(false);
                }
              }
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Card(
              color: Colors.deepPurple.shade50,
              child: Column(
                children: [
                  Text(fileController.pdfFileName),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
