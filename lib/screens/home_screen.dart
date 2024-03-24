import 'package:chat_app/controllers/auth_controller.dart';
import 'package:chat_app/controllers/chat_controller.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/widgets/custom_drawer.dart';
import 'package:chat_app/widgets/user_tile.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final AuthController _authController = AuthController();
  final ChatController _chatController = ChatController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: CircleAvatar(
              child: IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                ),
                icon: const Icon(Icons.person),
              ),
            ),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatController.getUserStream(),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData['email'] != _authController.getCurrentUser()!.email) {
      return UserTile(
        text: userData['email'],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                receiverEmail: userData['email'],
                receiverId: userData['uid'],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
