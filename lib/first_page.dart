import 'package:provider/provider.dart';
import 'package:space_lab_tasks/dashboard_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:space_lab_tasks/email_password_login_page.dart';
import 'package:space_lab_tasks/signup_page.dart';
import 'package:space_lab_tasks/theme_manager.dart';
import 'package:google_fonts/google_fonts.dart';


class FirstPage extends StatelessWidget {
  FirstPage({super.key});

  // For Google Sign-In

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> _handleSignInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken,
      );
      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User? user = authResult.user;
      return user;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return Theme(
      data: themeManager.isLightTheme ? ThemeData.light() : ThemeData.dark(),
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Brief Introduction

                Container(
                  margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02),
                  padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/to-do-list.png',
                        height: 150,
                        width: 150,
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                      Text(
                        'Space Lab Tasks!',
                        style: GoogleFonts.gluten(
                          textStyle: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w400,
                          ),
                          color: Colors.blue[700],
                        ),
                      ),
                    ]
                  ),
                ),
      
                // Email/Password Sign-In Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EmailPasswordLoginPage(),
                          ),
                        );
                      },
                      child: const Text('Sign In'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
      
                    // Sign-Up Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            // build and change function for signup page
                            builder: (context) => const SignUpPage(),
                          ),
                        );
                      },
                      child: const Text('Sign Up'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
      
                const SizedBox(height: 32),
      
                // Google Sign-In Button
                ElevatedButton(
                  onPressed: () async {
                    // Signout and clear any cached credentials
                    await googleSignIn.signOut();
      
                    final User? user = await _handleSignInWithGoogle();
                    if (user != null) {
                      // Navigate to the next screen after successful login.
      
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DashboardPage(),
                        ),
                      );
                    }
                  },
                  child: const Text('Sign in with Google'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
