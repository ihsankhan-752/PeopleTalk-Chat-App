import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ImageController extends ChangeNotifier {
  File? _selectedImage;

  File? get selectedImage => _selectedImage;

  getUserImage(ImageSource source) async {
    XFile? pickedImage = await ImagePicker().pickImage(source: source);
    _selectedImage = File(pickedImage!.path);
    notifyListeners();
  }

  deleteUploadPhoto() {
    _selectedImage = null;
    notifyListeners();
  }
}
