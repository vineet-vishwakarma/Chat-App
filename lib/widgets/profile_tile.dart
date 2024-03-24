import 'package:chat_app/widgets/text_input_field.dart';
import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  final TextEditingController usernameController;
  final Function() showKeyboard;
  final FocusNode? focusNode;
  final IconData leading;
  final String text;
  const ProfileTile(
      {super.key,
      required this.usernameController,
      required this.showKeyboard,
      this.focusNode,
      required this.leading,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: ListTile(
        onTap: () {
          showKeyboard();
          var scaffoldMessenger = ScaffoldMessenger.of(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              showCloseIcon: true,
              closeIconColor: Theme.of(context).colorScheme.inversePrimary,
              duration: const Duration(seconds: 90),
              backgroundColor: Theme.of(context).colorScheme.background,
              content: Row(
                children: [
                  Expanded(
                    child: TextInputField(
                      controller: usernameController,
                      labelText: 'Username',
                      focusNode: focusNode,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      scaffoldMessenger.clearSnackBars();
                      usernameController.clear();
                    },
                  ),
                ],
              ),
            ),
          );
        },
        leading: Icon(leading),
        trailing: const Icon(Icons.edit),
        title: Text(text),
        tileColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
