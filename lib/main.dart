import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core
import 'package:day15_shoes/pages/homepage.dart';

void main() async {
  // Initialize Firebase before running the app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDDxE7w12Vl51yG16T34hWSpf_KzmPLzK8",
      appId: "1:1045656056357:android:39f82d451f3e10a001c5cc",
      messagingSenderId: "1045656056357	",
      projectId: "nikeshoes-f07c9",
    ),
  );

  // Run the app
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: HomePage()));
}
