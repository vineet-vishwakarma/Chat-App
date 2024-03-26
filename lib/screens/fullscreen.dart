import 'package:flutter/material.dart';

class FullScreen extends StatelessWidget {
  final String profilepic;
  final String username;
  const FullScreen(
      {super.key, required this.profilepic, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Image.network(
          profilepic,
        ),
      ),
    );
  }
}
