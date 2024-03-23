import 'package:chat_app/utils/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  const ChatBubble(
      {super.key, required this.message, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 2.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isCurrentUser
            ? isDarkMode
                ? Colors.deepPurple
                : Colors.deepPurple.shade300
            : isDarkMode
                ? Colors.grey.shade800
                : Colors.grey.shade200,
      ),
      child: Text(
        message,
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
