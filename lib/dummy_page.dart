import 'dart:io';

import 'package:audio_wave/audio_wave.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class DummyPage extends StatefulWidget {
  const DummyPage({super.key});

  @override
  State<DummyPage> createState() => _DummyPageState();
}

class _DummyPageState extends State<DummyPage> {
  final recorder = FlutterSoundRecorder();
  bool isRecorderReady = false;
  bool isRecording = false;
  String? audioFilePath;

  Future record() async {
    if (!isRecorderReady) return;

    await recorder.startRecorder(toFile: 'audio');
    setState(() {
      isRecording = true;
    });
  }

  Future stop() async {
    if (!isRecorderReady) return;
    final path = await recorder.stopRecorder();
    setState(() {
      isRecording = false;
      audioFilePath = path;
    });

    final audioFile = File(path!);
    Reference reference = FirebaseStorage.instance.ref().child(DateTime.now().millisecondsSinceEpoch.toString());
    await reference.putFile(audioFile);
    String audioUrl = await reference.getDownloadURL();
    print("Path Of Audio is :$audioUrl");
  }

  @override
  void initState() {
    initRecorder();
    super.initState();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw 'Microphone Permission not Granted';
    }
    await recorder.openRecorder();
    isRecorderReady = true;
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (recorder.isRecording)
              AudioWave(
                height: 32,
                width: 32,
                spacing: 2.5,
                animationLoop: 3,
                bars: [
                  AudioWaveBar(heightFactor: 0.7, color: Colors.lightBlueAccent),
                  AudioWaveBar(heightFactor: 0.8, color: Colors.blue),
                  AudioWaveBar(heightFactor: 1, color: Colors.black),
                  AudioWaveBar(heightFactor: 0.9),
                ],
              ),
            StreamBuilder(
              stream: recorder.onProgress,
              builder: (context, snapshot) {
                final duration = snapshot.hasData ? snapshot.data!.duration : Duration.zero;

                return Text(
                  "${duration.inSeconds} s",
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                );
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(),
              onPressed: () async {
                if (isRecording) {
                  await stop();
                } else {
                  await record();
                }
                setState(() {});
              },
              child: Icon(isRecording ? Icons.stop : Icons.mic),
            ),
          ],
        ),
      ),
    );
  }
}
