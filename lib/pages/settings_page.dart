import 'package:things_todo_app/components/android_settings.dart';
import 'package:universal_io/io.dart';
import 'package:flutter/material.dart';

import '../components/text_fragment.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Settings",
          style: TextStyle(fontFamily: 'RobotoMono'),
        ),
      ),
      body: Platform.isAndroid
          ? const AndroidSettingsInfo()
          : const Center(
              child:
                  TextFragment(text: "See you later", isOverflowClip: false)),
    );
  }
}
