import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class VisibilityController extends ChangeNotifier {
  bool _isVisible = true;

  bool get isVisible => _isVisible;

  hideAndUnHideVisibility() {
    _isVisible = !_isVisible;
    notifyListeners();
  }
}
