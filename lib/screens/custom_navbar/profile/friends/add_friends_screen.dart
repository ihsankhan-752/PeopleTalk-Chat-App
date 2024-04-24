import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:people_talk/controllers/get_all_users.dart';
import 'package:people_talk/screens/custom_navbar/profile/friends/widgets/no_search_widgets.dart';
import 'package:people_talk/screens/custom_navbar/profile/friends/widgets/search_result_widget.dart';
import 'package:people_talk/widgets/search_text_input.dart';
import 'package:provider/provider.dart';

import '../../../../constants/app_text_style.dart';

class AddFriendsScreen extends StatefulWidget {
  const AddFriendsScreen({super.key});

  @override
  State<AddFriendsScreen> createState() => _AddFriendsScreenState();
}

class _AddFriendsScreenState extends State<AddFriendsScreen> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _loadAllUsers();
  }

  _loadAllUsers() async {
    await Provider.of<GetAllUsers>(context, listen: false).getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<GetAllUsers>(context).userModel;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Friends", style: AppTextStyle.main.copyWith(fontSize: 18, letterSpacing: 1.5)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SearchTextInput(
                controller: _searchController,
                onChanged: (v) {
                  setState(() {});
                },
              ),
              if (_searchController.text.isEmpty) ...{
                const NoSearchWidget(),
              } else ...{
                SizedBox(
                  height: Get.height * 0.7,
                  child: ListView.builder(
                    itemCount: userController.length,
                    itemBuilder: (context, index) {
                      if (userController[index].username!.toLowerCase().contains(_searchController.text.toLowerCase())) {
                        return SearchResultWidget(userController: userController[index]);
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                )
              }
            ],
          ),
        ),
      ),
    );
  }
}
