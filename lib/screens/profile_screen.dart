import 'dart:async';
import 'dart:io';

import 'package:chat_app/controllers/auth_controller.dart';
import 'package:chat_app/widgets/profile_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late FocusNode focusNode;
  File? _image;
  final AuthController _authController = AuthController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
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

    User? user = _authController.getCurrentUser();

    Future<void> selectImage() async {
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            'Image Not Selected!!!',
            style: TextStyle(color: Colors.white),
          ),
        ));
        return;
      }

      setState(() {
        _image = File(image.path);
      });

      if (_image != null) {
        UploadTask uploadTask = _storage
            .ref()
            .child('ProfilePics')
            .child(_authController.getCurrentUser()!.uid)
            .putFile(_image!);
        StreamSubscription streamSubscription =
            uploadTask.snapshotEvents.listen((event) {
          double percentage = (event.bytesTransferred / event.totalBytes) * 100;
          showAboutDialog(
              context: context, applicationName: percentage.toString());
        });
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        streamSubscription.cancel();

        await _firestore
            .collection('Users')
            .doc(_authController.getCurrentUser()!.uid)
            .update({'profilepic': downloadUrl});
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        centerTitle: true,
        title: const Text('Profile'),
      ),
      body: StreamBuilder(
        stream: _firestore.collection('Users').doc(user!.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          String status = snapshot.data!['status'];
          String profilePic = snapshot.data!['profilepic'];

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(60),
                onTap: () {
                  selectImage();
                },
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: profilePic.isNotEmpty
                          ? NetworkImage(profilePic)
                          : const NetworkImage(
                              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"),
                    ),
                    CircleAvatar(
                      backgroundColor:
                          Theme.of(context).colorScheme.inversePrimary,
                      child: const Icon(Icons.add_a_photo),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              ProfileTile(
                controller: usernameController,
                showKeyboard: showKeyboard,
                focusNode: focusNode,
                leading: Icons.person,
                text: snapshot.data!['username'],
                setStatus: () async {
                  await _firestore
                      .collection('Users')
                      .doc(_authController.getCurrentUser()!.uid)
                      .update({'username': usernameController.text});
                },
                status: 'Username',
              ),
              ProfileTile(
                controller: statusController,
                showKeyboard: showKeyboard,
                focusNode: focusNode,
                leading: Icons.info_outline,
                setStatus: () async {
                  await _firestore
                      .collection('Users')
                      .doc(_authController.getCurrentUser()!.uid)
                      .update({'status': statusController.text});
                },
                text: status.isEmpty ? 'Status' : status,
                status: 'Status',
              ),
            ],
          );
        },
      ),
    );
  }
}
