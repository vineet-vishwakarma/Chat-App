import 'package:chat_app/screens/fullscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  final String userId;
  UserScreen({super.key, required this.userId});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: StreamBuilder(
        stream: _firestore.collection('Users').doc(userId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreen(
                        profilepic: snapshot.data!['profilepic'],
                        username: snapshot.data!['username'],
                      ),
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(snapshot.data!['profilepic']),
                    radius: 60,
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 25.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          right: 20,
                          left: 0,
                        ),
                        child: const Icon(Icons.person),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text(
                            snapshot.data!['username'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: const Text(
                            'Username',
                            style: TextStyle(fontSize: 12),
                          ),
                          tileColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 25.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          right: 20,
                          left: 0,
                        ),
                        child: const Icon(Icons.info_outline),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text(
                            snapshot.data!['status'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: const Text(
                            'Status',
                            style: TextStyle(fontSize: 12),
                          ),
                          tileColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
