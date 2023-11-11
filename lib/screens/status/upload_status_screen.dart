import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:people_talk/controllers/image_controller.dart';
import 'package:people_talk/controllers/loading_controller.dart';
import 'package:people_talk/controllers/status_controller.dart';
import 'package:people_talk/themes/app_text_style.dart';
import 'package:people_talk/widgets/buttons.dart';
import 'package:people_talk/widgets/custom_text_input.dart';
import 'package:provider/provider.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  TextEditingController titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final imageController = Provider.of<ImageController>(context);
    final loadingController = Provider.of<LoadingController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Status", style: AppTextStyle.h1),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imageController.selectedImage == null
                ? Center(
                    child: CircleAvatar(
                      radius: 55,
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            imageController.getUserImage(ImageSource.camera);
                          },
                          child: const Icon(Icons.photo),
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: CircleAvatar(
                      radius: 55,
                      backgroundImage: FileImage(imageController.selectedImage!),
                    ),
                  ),
            const SizedBox(height: 30),
            CustomTextInput(
              hintText: "Write Something",
              controller: titleController,
              validator: (v) {},
            ),
            const SizedBox(height: 30),
            loadingController.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : PrimaryButton(
                    onPressed: () async {
                      await StatusController().uploadStatus(
                        context: context,
                        image: imageController.selectedImage!,
                        title: titleController.text,
                      );
                      imageController.deleteUploadPhoto();
                    },
                    title: "Upload",
                  )
          ],
        ),
      ),
    );
  }
}
