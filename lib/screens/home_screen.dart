import 'package:chat_app/controllers/auth_controller.dart';
import 'package:chat_app/controllers/chat_controller.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/widgets/custom_drawer.dart';
import 'package:chat_app/widgets/user_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController _authController = AuthController();
  final ChatController _chatController = ChatController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? imageUrl;
  Future<void> getImageUrl() async {
    var snapshot = await _firestore
        .collection('Users')
        .doc(_authController.getCurrentUser()!.uid)
        .get();
    var data = snapshot.data();
    if (data != null) {
      setState(() {
        imageUrl = data['profilepic'];
      });
    }
  }

  Future<void> _refresh() {
    getImageUrl();
    return Future.delayed(const Duration(seconds: 2));
  }

  @override
  void initState() {
    super.initState();
    getImageUrl();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refresh(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen())),
                child: CircleAvatar(
                  foregroundImage:
                      imageUrl != null ? NetworkImage(imageUrl!) : null,
                ),
              ),
            ),
          ],
        ),
        drawer: const CustomDrawer(),
        body: _buildUserList(),
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatController.getUserStream(),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return const Center(child: Text('Error'));
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
        email: userData['email'],
        text: userData['username'],
        profilepic: userData['profilepic'],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                receiverProfilePic: userData['profilepic'],
                receiverUsername: userData['username'],
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
