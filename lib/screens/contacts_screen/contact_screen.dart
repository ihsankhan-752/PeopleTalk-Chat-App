// ignore_for_file: library_private_types_in_public_api

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:people_talk/services/auth_services.dart';
import 'package:people_talk/themes/app_text_style.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../themes/app_colors.dart';
import '../chat/one_to_one/chat_main_screen.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key});

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<ContactWithUid> matchingContacts = [];
  bool isLoading = true;

  Future<void> requestContactPermission() async {
    if (await Permission.contacts.isGranted) {
      fetchContacts();
    } else {
      await Permission.contacts.request();
    }
  }

  Future<void> fetchContacts() async {
    final Iterable<Contact> contacts = await ContactsService.getContacts();

    final phoneNumbersInDevice = contacts.map((contact) {
      final originalPhoneNumber = contact.phones!.first.value;
      final sanitizedPhoneNumber = '+${int.tryParse(originalPhoneNumber!.replaceAll(RegExp(r'\D'), ''))}';
      return {'original': originalPhoneNumber, 'sanitized': sanitizedPhoneNumber};
    }).toSet();

    try {
      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('users').get();

      List<ContactWithUid> matchingUsers = [];

      for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
        var userPhoneNumber = "+${userDoc['contact']}";

        if (phoneNumbersInDevice
            .any((contact) => contact['original'] == userPhoneNumber || contact['sanitized'] == userPhoneNumber)) {
          ContactWithUid matchingContact = ContactWithUid(
            displayName: userDoc['username'],
            phoneNumber: userPhoneNumber,
            uid: userDoc.id,
            userImage: userDoc['image'],
          );
          matchingUsers.add(matchingContact);
        }
      }

      setState(() {
        matchingContacts = matchingUsers;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  void initState() {
    requestContactPermission();
    fetchContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.primaryWhite),
        centerTitle: true,
        backgroundColor: Colors.teal.withOpacity(0.5),
        title: Text('Contacts', style: AppTextStyle.h1),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : matchingContacts.isEmpty
              ? Center(
                  child: Text('No User Found', style: AppTextStyle.h1),
                )
              : Center(
                  child: ListView.builder(
                    itemCount: matchingContacts.length,
                    itemBuilder: (context, index) {
                      final ContactWithUid matchingContact = matchingContacts[index];
                      return ListTile(
                        onTap: () async {
                          Get.to(
                            () => ChatMainScreen(
                              userImage: matchingContact.userImage!,
                              userId: matchingContact.uid!,
                              username: matchingContact.displayName!,
                            ),
                          );
                          await AuthServices().addUserToFriendList(matchingContact.uid!);
                        },
                        leading: Container(
                          height: 30,
                          width: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: const Color(0xff262626),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 7,
                                color: AppColors.primaryWhite.withOpacity(0.1),
                                offset: const Offset(-3, -3),
                              ),
                              BoxShadow(
                                blurRadius: 7,
                                color: AppColors.primaryBlack.withOpacity(0.7),
                                offset: const Offset(3, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            matchingContact.displayName![0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                            ),
                          ),
                        ),
                        title: Text(
                          matchingContact.displayName!,
                          style: AppTextStyle.h1.copyWith(
                            color: Colors.teal.withOpacity(0.5),
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          matchingContact.phoneNumber!,
                          style: AppTextStyle.h1.copyWith(
                            color: AppColors.primaryGrey,
                            fontSize: 14,
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

class ContactWithUid {
  final String? displayName;
  final String? phoneNumber;
  final String? uid;
  final String? userImage;
  ContactWithUid({
    this.displayName,
    this.phoneNumber,
    this.uid,
    this.userImage,
  });
}
