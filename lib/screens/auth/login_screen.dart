// ignore_for_file: use_build_context_synchronously

import 'package:chat_app/controllers/auth_controller.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/text_input_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final void Function()? onTap;
  LoginScreen({super.key, @required this.onTap});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void login(BuildContext context) async {
    final authController = AuthController();

    try {
      await authController.signInWithEmailPassword(
          _emailController.text, _passwordController.text);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.message_rounded,
              size: 60,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 25),
            Text(
              'Welcome Back',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 25),
            TextInputField(
              controller: _emailController,
              labelText: 'Email',
            ),
            const SizedBox(height: 10),
            TextInputField(
              controller: _passwordController,
              labelText: 'Password',
              isObscure: true,
            ),
            const SizedBox(height: 25),
            CustomButton(
              title: 'Login',
              onPressed: () => login(context),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Don\'t have an account? ',
                ),
                InkWell(
                  onTap: onTap,
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
