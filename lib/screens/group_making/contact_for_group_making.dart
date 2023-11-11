import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:people_talk/screens/group_making/group_name_and_pic_selection.dart';
import 'package:people_talk/themes/app_text_style.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../themes/app_colors.dart';

class ContactsScreenForGroupMaking extends StatefulWidget {
  const ContactsScreenForGroupMaking({super.key});

  @override
  State<ContactsScreenForGroupMaking> createState() => _ContactsScreenForGroupMakingState();
}

class _ContactsScreenForGroupMakingState extends State<ContactsScreenForGroupMaking> {
  List<String> userIds = [FirebaseAuth.instance.currentUser!.uid];

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
      final numericPhoneNumber =
          contact.phones!.first.value!.replaceAll(RegExp(r'^0+'), '').replaceAll(RegExp(r'[^0-9]'), '');
      return int.tryParse(numericPhoneNumber);
    }).toList();

    try {
      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('users').get();

      List<ContactWithUid> matchingUsers = [];

      for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
        int userPhoneNumber = userDoc['contact'];

        if (phoneNumbersInDevice.contains(userPhoneNumber)) {
          ContactWithUid matchingContact = ContactWithUid(
            displayName: userDoc['username'],
            phoneNumber: userPhoneNumber.toString(),
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: userIds.isEmpty
          ? const SizedBox()
          : FloatingActionButton(
              backgroundColor: Colors.teal.withOpacity(0.5),
              onPressed: () {
                Get.to(() => GroupNameAndPicSelectionScreen(groupId: userIds));
              },
              child: Icon(Icons.arrow_forward, color: AppColors.primaryWhite),
            ),
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
          : ListView.builder(
              itemCount: matchingContacts.length,
              itemBuilder: (context, index) {
                final ContactWithUid matchingContact = matchingContacts[index];
                return ListTile(
                  /*     onTap: () {
                  Get.to(
                    () => ChatMainScreen(
                      userImage: matchingContact.userImage!,
                      userId: matchingContact.uid!,
                      username: matchingContact.displayName!,
                    ),
                  );
                },*/
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
                  trailing: ElevatedButton(
                    onPressed: () {
                      if (userIds.contains(matchingContact.uid)) {
                        setState(() {
                          userIds.remove(matchingContact.uid);
                        });
                      } else {
                        setState(() {
                          userIds.add(matchingContact.uid!);
                        });
                      }
                    },
                    child: userIds.contains(matchingContact.uid) ? const Text("Remove") : const Text("Add"),
                  ),
                  /* trailing: PrimaryButton(
                  onPressed: () {},
                  title: "Add",
                ),*/
                );
              },
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
