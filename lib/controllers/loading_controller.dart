import 'package:flutter/cupertino.dart';

class LoadingController extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Map<String, bool> _loadingMap = {};

  void setLoadingForSpecificUser(bool isLoading, {required String userId}) {
    _loadingMap[userId] = isLoading;
    notifyListeners();
  }

  bool isLoadingForUser(String userId) {
    return _loadingMap[userId] ?? false;
  }

  setLoading(newVal) {
    _isLoading = newVal;
    notifyListeners();
  }
}
