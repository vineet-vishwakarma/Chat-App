import 'dart:async';
import 'dart:io';

import 'package:chat_app/controllers/auth_controller.dart';
import 'package:chat_app/widgets/profile_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
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
  PlatformFile? _webImage;
  double _uploadPercentage = 0;
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

  Future<void> selectWebImage() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);

      if (result == null) return;

      setState(() {
        _webImage = result.files.first;
      });

      if (_webImage != null) {
        UploadTask uploadTask = _storage
            .ref()
            .child('ProfilePics')
            .child(_authController.getCurrentUser()!.uid)
            .putData(_webImage!.bytes!);
        StreamSubscription streamSubscription =
            uploadTask.snapshotEvents.listen((event) {
          double percentage = (event.bytesTransferred / event.totalBytes) * 100;
          setState(() {
            _uploadPercentage = percentage;
          });
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: _uploadPercentage == 100
                ? const Duration(seconds: 1)
                : const Duration(seconds: 2),
            backgroundColor: Colors.black,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _uploadPercentage == 100
                    ? Text(
                        'Uploaded!!',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      )
                    : Text(
                        'Uploading...',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LinearProgressIndicator(
                          value: _uploadPercentage,
                          minHeight: 10,
                          valueColor: const AlwaysStoppedAnimation(Colors.red),
                          color: Colors.grey,
                          backgroundColor: Colors.black,
                        ),
                      ),
                    ),
                    Text(
                      _uploadPercentage.toString(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        streamSubscription.cancel();

        await _firestore
            .collection('Users')
            .doc(_authController.getCurrentUser()!.uid)
            .update({'profilepic': downloadUrl});
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController statusController = TextEditingController();

    User? user = _authController.getCurrentUser();

    Future<void> selectImage() async {
      try {
        final XFile? image =
            await ImagePicker().pickImage(source: ImageSource.gallery);

        if (image == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.black,
              content: Text(
                'Image Not Selected!!!',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
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
            double percentage =
                (event.bytesTransferred / event.totalBytes) * 100;
            setState(() {
              _uploadPercentage = percentage;
            });
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: _uploadPercentage == 100
                  ? const Duration(seconds: 1)
                  : const Duration(seconds: 2),
              backgroundColor: Colors.black,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _uploadPercentage == 100
                      ? Text(
                          'Uploaded!!',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )
                      : Text(
                          'Uploading...',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LinearProgressIndicator(
                            value: _uploadPercentage,
                            minHeight: 10,
                            valueColor:
                                const AlwaysStoppedAnimation(Colors.red),
                            color: Colors.grey,
                            backgroundColor: Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        _uploadPercentage.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
          TaskSnapshot taskSnapshot = await uploadTask;
          String downloadUrl = await taskSnapshot.ref.getDownloadURL();

          streamSubscription.cancel();

          await _firestore
              .collection('Users')
              .doc(_authController.getCurrentUser()!.uid)
              .update({'profilepic': downloadUrl});
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
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
                  if (kIsWeb) {
                    selectWebImage();
                  } else {
                    selectImage();
                  }
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
