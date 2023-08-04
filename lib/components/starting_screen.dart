import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class StartingScreen extends StatelessWidget {
  const StartingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: AnimatedTextKit(
        animatedTexts: [
          TypewriterAnimatedText(
            'thinGS',
            textAlign: TextAlign.center,
            textStyle: const TextStyle(
                fontSize: 50.0, fontFamily: 'RobotoMono', color: Colors.white),
            speed: const Duration(milliseconds: 200),
          ),
        ],
        isRepeatingAnimation: true,
      )),
    );
  }
}
