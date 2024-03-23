import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const CustomButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: CupertinoButton(
        onPressed: onPressed,
        color: Theme.of(context).colorScheme.primary,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
