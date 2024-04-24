import 'package:audio_wave/audio_wave.dart';
import 'package:flutter/material.dart';
import 'package:people_talk/screens/custom_navbar/groups/group_chat_front_screen.dart';
import 'package:people_talk/screens/custom_navbar/messages/messages_user_list_screen.dart';
import 'package:people_talk/screens/custom_navbar/notifications/notification_screen.dart';
import 'package:people_talk/screens/custom_navbar/profile/profile_screen.dart';

List<Widget> screens = [
  const MessagesUserChatListScreen(),
  const GroupChatFrontScreen(),
  const NotificationScreen(),
  const ProfileScreen(),
];

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
