import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:people_talk/controllers/file_controller.dart';
import 'package:provider/provider.dart';

import '../../../controllers/image_controller.dart';

showModelSheetForOptions(BuildContext context) {
  final imageProvider = Provider.of<ImageController>(context, listen: false);
  final fileController = Provider.of<FileController>(context, listen: false);

  return showModalBottomSheet(
    context: context,
    builder: (_) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  imageProvider.getUserImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
                child: const Icon(Icons.image),
              ),
              const SizedBox(width: 30),
              InkWell(
                onTap: () {
                  imageProvider.getUserImage(ImageSource.camera);
                  Navigator.pop(context);
                },
                child: const Icon(Icons.camera_alt_outlined),
              ),
              const SizedBox(width: 30),
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    fileController.uploadFile();
                  },
                  child: const Icon(Icons.file_copy)),
              const SizedBox(width: 30),
            ],
          ),
          const SizedBox(height: 30),
        ],
      );
    },
  );
}
