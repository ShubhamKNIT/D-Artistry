import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:space_lab_tasks/dashboard_page.dart';
import 'package:space_lab_tasks/first_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Check if a user is already authenticated
  User? user = FirebaseAuth.instance.currentUser;

  runApp(MaterialApp(
    home: user != null ? const DashboardPage() : FirstPage(),
  ));
}