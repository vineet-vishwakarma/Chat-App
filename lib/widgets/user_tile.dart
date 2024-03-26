import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String profilepic;
  final String email;
  final String text;
  final void Function()? onTap;
  const UserTile(
      {super.key,
      required this.text,
      required this.onTap,
      required this.profilepic,
      required this.email});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                profilepic.isNotEmpty
                    ? CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(profilepic),
                      )
                    : const Icon(Icons.person),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      email,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => CupertinoAlertDialog(
                    actions: [
                      CupertinoActionSheet(
                        actions: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: const Row(
                              children: [
                                Icon(Icons.copy),
                                Text('Copy'),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: const Row(
                              children: [
                                Icon(Icons.delete),
                                Text('Delete'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              child: const Icon(Icons.more_vert_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
