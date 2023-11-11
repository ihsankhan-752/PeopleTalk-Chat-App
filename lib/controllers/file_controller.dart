import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FileController extends ChangeNotifier {
  File? _pdf;
  String _pdfFileName = '';

  File? get pdf => _pdf;

  String get pdfFileName => _pdfFileName;

  uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'xlsx', 'xls'],
    );
    if (result != null) {
      _pdf = File(result.files.single.path!);
      _pdfFileName = _pdf!.path.split('/').last;
      notifyListeners();
    }
  }

  deleteUploadPdf() {
    _pdf = null;
    _pdfFileName = '';
    notifyListeners();
  }
}
