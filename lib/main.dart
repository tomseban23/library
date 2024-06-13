// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:loginui/auth/main_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCH91k0G6Ie-DvR4m3ja0YDWIguss-4038",
      appId: "APP_ID",
      messagingSenderId: "MESSAGING_SENDER_ID",
      projectId: "fir-new-587ad",
    ),
  );

  runApp(const myApp());
}

class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
