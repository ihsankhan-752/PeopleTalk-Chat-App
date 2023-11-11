import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/chat_controller.dart';
import '../../../../controllers/file_controller.dart';
import '../../../../controllers/loading_controller.dart';

class SendingAndViewFile extends StatefulWidget {
  final String userId;
  final String docId;
  const SendingAndViewFile({super.key, required this.userId, required this.docId});

  @override
  State<SendingAndViewFile> createState() => _SendingAndViewFileState();
}

class _SendingAndViewFileState extends State<SendingAndViewFile> {
  @override
  Widget build(BuildContext context) {
    final fileController = Provider.of<FileController>(context);
    var loadingController = Provider.of<LoadingController>(context);
    final chatController = Provider.of<ChatController>(context);

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
                  await chatController.sendingFilesInChat(
                    context: context,
                    file: fileController.pdf,
                    userId: widget.userId,
                    docId: widget.docId,
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
