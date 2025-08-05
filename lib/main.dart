import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'starting_page.dart'; // Your first screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Lock orientation to portrait only (up and down)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // ✅ Initialize Firebase
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyber Shield',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: StartingPage(),
    );
  }
}
