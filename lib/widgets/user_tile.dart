import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const UserTile({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20.0),
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
                const Icon(Icons.person),
                const SizedBox(width: 20),
                Text(
                  text,
                  style: const TextStyle(fontSize: 15),
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
