import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:people_talk/services/storage_services.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecordingController extends ChangeNotifier {
  final _recorder = FlutterSoundRecorder();

  bool _isRecordingReady = false;
  bool _isRecording = false;
  bool _isMicOn = false;
  String? _audioFilePath;
  String _audioUrl = '';

  get recorder => _recorder;
  bool get isRecording => _isRecording;
  String? get audioFilePath => _audioFilePath;
  String get audioUrl => _audioUrl;
  bool get isMicOn => _isMicOn;

  setMicValue(newValue) {
    _isMicOn = newValue;
    notifyListeners();
  }

  Future record() async {
    if (!_isRecordingReady) return;
    await _recorder.startRecorder(toFile: 'audio');
    _isRecording = true;
    notifyListeners();
  }

  Future stopAndSendAudioFile() async {
    if (!_isRecordingReady) return;
    final path = await _recorder.stopRecorder();
    _isRecording = false;
    _audioFilePath != path;
    _audioUrl = '';

    final audioFile = File(path!);
    _audioUrl = await StorageServices().uploadImageToDb(audioFile);

    notifyListeners();
  }

  Future stopOnly() async {
    if (!_isRecordingReady) return;
    await _recorder.stopRecorder();
    _isRecording = false;
    notifyListeners();
  }

  initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw "MicroPhone Status Not Granted";
    }
    await _recorder.openRecorder();
    _isRecordingReady = true;
    _recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  closeRecorder() async {
    await _recorder.closeRecorder();
    notifyListeners();
  }

  deleteRecording() async {
    _audioUrl = '';
    notifyListeners();
  }
}
