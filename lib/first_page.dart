import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:space_lab_tasks/email_password_login_page.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  // For Google Sign-In

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn googleSignIn = GoogleSignIn();

  // Future<User?> _handleSignInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleSignInAccount =
  //         await googleSignIn.signIn();
  //     final GoogleSignInAuthentication? googleSignInAuthentication =
  //         await googleSignInAccount?.authentication;
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleSignInAuthentication?.accessToken,
  //       idToken: googleSignInAuthentication?.idToken,
  //     );
  //     final UserCredential authResult =
  //         await _auth.signInWithCredential(credential);
  //     final User? user = authResult.user;
  //     return user;
  //   } catch (error) {
  //     print(error.toString());
  //     return null;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Brief Introduction
              const Text(
                'Welcome to My To-Do App!\n'
                'Stay organized and productive with these features:',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                  '1. Store notes and tasks with titles and descriptions.'),
              const Text('2. Schedule reminders for your tasks and notes.'),
              const Text('3. Categorize and color-code your notes.'),
              const Text('4. Add images and drawings to your notes.'),
              const Text('5. Arrange tasks in various orders.'),
              const Text('6. Collaborate with private notes.'),
              const Text(
                  '7. Automatically detect and set reminders in your notes.'),
              const SizedBox(height: 16),
              // const Text(
              //   'Get started by signing in with your Google account:',
              //   style: TextStyle(fontSize: 16),
              // ),
              const Text(
                'Get started with your To-Do App:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),

              // Google Sign-In Button
              // ElevatedButton(
              //   onPressed: () async {
              //     final User? user = await _handleSignInWithGoogle();
              //     if (user != null) {
              //       // Navigate to the next screen after successful login.
              //     }
              //   },
              //   child: const Text('Sign in with Google'),
              // ),

              // Email/Password Sign-In Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EmailPasswordLoginPage(),
                    ),
                  );
                },
                child: const Text('Sign in with Email/Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
