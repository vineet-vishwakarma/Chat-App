// ignore_for_file: use_build_context_synchronously

import 'package:chat_app/controllers/auth_controller.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/text_input_field.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  final void Function()? onTap;
  SignupScreen({super.key,@required this.onTap});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void signup(BuildContext context) async {
    final auth = AuthController();

    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        await auth.signUpWithEmailPassword(
            _emailController.text, _passwordController.text);
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Password don't match!"),
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
              'Welcome',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 25),
            TextInputField(
              controller: _emailController,
              labelText: 'Email',
              // icon: Icons.email,
            ),
            const SizedBox(height: 10),
            TextInputField(
              controller: _passwordController,
              labelText: 'Password',
              // icon: Icons.remove_red_eye,
              isObscure: true,
            ),
            const SizedBox(height: 10),
            TextInputField(
              controller: _confirmPasswordController,
              labelText: 'Confirm Password',
              isObscure: true,
            ),
            const SizedBox(height: 25),
            CustomButton(
              title: 'Sign Up',
              onPressed: () => signup(context),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account? ',
                  style: TextStyle(fontSize: 16),
                ),
                InkWell(
                  onTap: onTap,
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 16,
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
