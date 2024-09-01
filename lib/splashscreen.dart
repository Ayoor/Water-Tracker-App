import 'package:flutter/material.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  SizedBox.expand(
        child: Image.asset(
          "Assets/waterSplash.jpg",
          fit: BoxFit.cover,
        )
    );



  }
}
