import 'package:chat_app/widgets/text_input_field.dart';
import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  final TextEditingController controller;
  final Function() showKeyboard;
  final Function() setStatus;
  final FocusNode? focusNode;
  final IconData leading;
  final String text;
  final String status;
  const ProfileTile({
    super.key,
    required this.controller,
    required this.showKeyboard,
    this.focusNode,
    required this.leading,
    required this.text,
    required this.setStatus,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(
              right: 20,
              left: 0,
            ),
            child: Icon(leading),
          ),
          Expanded(
            child: ListTile(
              onTap: () {
                showKeyboard();
                var scaffoldMessenger = ScaffoldMessenger.of(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    showCloseIcon: true,
                    closeIconColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    duration: const Duration(seconds: 90),
                    backgroundColor: Theme.of(context).colorScheme.background,
                    content: Row(
                      children: [
                        Expanded(
                          child: TextInputField(
                            controller: controller,
                            labelText: status,
                            focusNode: focusNode,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            setStatus();
                            scaffoldMessenger.clearSnackBars();
                            controller.clear();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              trailing: const Icon(Icons.edit),
              title: Text(
                text,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                status,
                style: const TextStyle(fontSize: 12),
              ),
              tileColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
