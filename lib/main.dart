import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_tracker/view/History.dart';
import 'package:water_tracker/ViewModel/DashboardProvider.dart';
import 'package:water_tracker/view/homepage.dart';

import 'ViewModel/DrinkHistoryProvider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DashboardProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DrinkHistoryProvider(),
        ),
      ],
      child: const MyApp(), // The child widget is provided to MultiProvider
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // home: AnimatedSplashScreen(nextScreen: const Dashboard(),
      //   duration: 2000, splashIconSize: 900,
      //   backgroundColor: Colors.white,
      //   splash: const Splashscreen(),),
      home: const Home(),
    );
  }
}
