import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:people_talk/controllers/get_user_data.dart';
import 'package:people_talk/controllers/status_controller.dart';
import 'package:people_talk/models/status_model.dart';
import 'package:people_talk/screens/status/status_details.dart';
import 'package:people_talk/themes/app_text_style.dart';
import 'package:provider/provider.dart';

class StatusView extends StatefulWidget {
  const StatusView({super.key});

  @override
  State<StatusView> createState() => _StatusViewState();
}

class _StatusViewState extends State<StatusView> {
  @override
  void initState() {
    Provider.of<StatusController>(context, listen: false).getAllUsersStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GetUserData>(context);
    final statusController = Provider.of<StatusController>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.15,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('status')
                .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text("You Did not Upload Status Yet", style: AppTextStyle.h1),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  StatusModel statusModel = StatusModel.fromDoc(snapshot.data!.docs[index]);
                  provider.getUserData(statusModel.userId!);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text("My Status", style: AppTextStyle.h1),
                        const SizedBox(height: 7),
                        InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            Get.to(
                              () => StatusDetails(
                                statusImage: statusModel.image!,
                                statusTitle: statusModel.title!,
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 35,
                            backgroundImage: NetworkImage(provider.userModel.image ?? ""),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        Divider(color: Colors.teal.withOpacity(0.5)),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text("Status", style: AppTextStyle.h1),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.5,
          child: ListView.builder(
            itemCount: statusController.statusList.length,
            itemBuilder: (context, index) {
              provider.getUserData(statusController.statusList[index].userId!);
              if (statusController.statusList.isEmpty) {
                return const Text("No Status Found");
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    Get.to(
                      () => StatusDetails(
                        statusTitle: statusController.statusList[index].title!,
                        statusImage: statusController.statusList[index].image!,
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(provider.userModel.image ?? ""),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(provider.userModel.username!, textAlign: TextAlign.center, style: AppTextStyle.h1),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
