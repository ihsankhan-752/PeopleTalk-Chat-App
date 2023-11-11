import 'package:audio_wave/audio_wave.dart';
import 'package:flutter/material.dart';

//todo if problem we will remove key=
String messagingKey =
    "key=AAAAftOqwjI:APA91bFskHrV14bCP-MXReROnt_Ia_P5O3JUS951yIjJeSBXjj94jUGSLrAZYRSrXBv_25dFYukx10qNgZMK8SYempSx4izaF7Hv57mcLMRipYyMk-RFmmE4XfCM86INVsifkPIbhPhP";

List<AudioWaveBar> audioBubbles = [
  AudioWaveBar(heightFactor: 0.5, color: Colors.grey),
  AudioWaveBar(heightFactor: 0.8, color: Colors.grey),
  AudioWaveBar(heightFactor: 1, color: Colors.grey),
  AudioWaveBar(heightFactor: 0.7, color: Colors.grey),
  AudioWaveBar(heightFactor: 0.9, color: Colors.grey),
  AudioWaveBar(heightFactor: 0.8, color: Colors.grey),
  AudioWaveBar(heightFactor: 1, color: Colors.grey),
  AudioWaveBar(heightFactor: 0.5, color: Colors.grey),
];

class AudioWaveForDisplayAudio extends StatelessWidget {
  const AudioWaveForDisplayAudio({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 12,
          width: 01,
          color: Colors.grey,
          margin: const EdgeInsets.only(right: 1),
        ),
        Container(
          height: 12,
          width: 01,
          color: Colors.grey,
          margin: const EdgeInsets.only(right: 1),
        ),
        Container(
          height: 12,
          width: 01,
          color: Colors.grey,
          margin: const EdgeInsets.only(right: 3),
        ),
        Container(
          height: 15,
          width: 01,
          color: Colors.grey,
          margin: const EdgeInsets.only(right: 3),
        ),
        Container(
          height: 18,
          width: 01,
          color: Colors.grey,
          margin: const EdgeInsets.only(right: 2),
        ),
        Container(
          height: 7,
          width: 01,
          color: Colors.grey,
          margin: const EdgeInsets.only(right: 3),
        ),
        Container(
          height: 20,
          width: 01,
          color: Colors.grey,
          margin: const EdgeInsets.only(right: 3),
        ),
        Container(
          height: 15,
          width: 01,
          color: Colors.grey,
          margin: const EdgeInsets.only(right: 3),
        ),
        Container(
          height: 18,
          width: 01,
          color: Colors.grey,
          margin: const EdgeInsets.only(right: 2),
        ),
        Container(
          height: 7,
          width: 01,
          color: Colors.grey,
          margin: const EdgeInsets.only(right: 3),
        ),
        Container(
          height: 15,
          width: 01,
          color: Colors.grey,
          margin: const EdgeInsets.only(right: 3),
        ),
        Container(
          height: 18,
          width: 01,
          color: Colors.grey,
          margin: const EdgeInsets.only(right: 2),
        ),
        Container(
          height: 7,
          width: 01,
          color: Colors.grey,
          margin: const EdgeInsets.only(right: 3),
        ),
      ],
    );
  }
}
