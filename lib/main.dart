import 'package:cyber_sheild/firebase_options.dart';
import 'package:cyber_sheild/starting_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import your firebase_options if you're using FlutterFire CLI
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Uncomment below if using Firebase CLI setup
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyber Shield',
      home: StartingPage(),
    );
  }
}