import 'package:chat_app/widgets/profile_tile.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();

    focusNode = FocusNode();
    focusNode.addListener(() {});
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void showKeyboard() {
    focusNode.requestFocus();
  }

  void dismissKeyboard() {
    focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController statusController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        centerTitle: true,
        title: const Text('Profile'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              const CircleAvatar(
                radius: 60,
              ),
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                child: const Icon(Icons.add_a_photo),
              ),
            ],
          ),
          const SizedBox(height: 25),
          ProfileTile(
            usernameController: usernameController,
            showKeyboard: showKeyboard,
            focusNode: focusNode,
            leading: Icons.person,
            text: 'Username',
          ),
          ProfileTile(
            usernameController: statusController,
            showKeyboard: showKeyboard,
            focusNode: focusNode,
            leading: Icons.info_outline,
            text: 'Status',
          ),
        ],
      ),
    );
  }
}
