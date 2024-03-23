import 'package:chat_app/utils/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(24.0),
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            color: Theme.of(context).colorScheme.secondary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Dark Mode',
                  style: TextStyle(fontSize: 20),
                ),
                CupertinoSwitch(
                  value: Provider.of<ThemeProvider>(context, listen: false)
                      .isDarkMode,
                  onChanged: (value) =>
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
