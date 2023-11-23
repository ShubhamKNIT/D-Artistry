import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:space_lab_tasks/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:space_lab_tasks/theme_manager.dart';

class VerifyEmail extends StatefulWidget {
  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isEmailVerified = false;
  bool canResendEmail = true;
  late Timer? timer; // dummy timer to initialize.
  bool _isLoading = false; // to show loading indicator

  @override
  void initState() {
    super.initState();

    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // if user is not null, check if email is verified.
      isEmailVerified = currentUser.emailVerified;

      if (!isEmailVerified) {
        // if email is not verified send verification link.
        // if email is not verified send verification link.
        sendVerificationEmail();

        timer = Timer.periodic(
          Duration(seconds: 5),
          (_) => checkEmailVerified(),
        );
      }
    }
  }

  @override
  void dispose() {
    // cancel timer when dispose.
    timer?.cancel();
    super.dispose();
  }

  Future<void> sendVerificationEmail() async {
    try {
      setState(
        () {
          // show loading indicator.
          _isLoading = true;
        },
      );

      User? user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();

      // show snackbar to inform user.
      // email verification link is sent to user's email.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification email sent successfully.'),
        ),
      );

      // disable button for 5 seconds.
      setState(() => canResendEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } on Exception catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send verification email.'),
        ),
      );
    } finally {
      setState(
        () {
          // hide loading indicator.
          _isLoading = false;
        },
      );
    }
  }

  Future<void> checkEmailVerified() async {
    // call authStateChanges to update user data.
    final user = FirebaseAuth.instance.currentUser;
    await user!.reload();

    setState(() {
      isEmailVerified = user.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return isEmailVerified
        ? Theme(
            data: themeManager.isLightTheme
                ? ThemeData.light()
                : ThemeData.dark(),
            child: Scaffold(
              body: Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  // if email is verified, show this.
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Your Email is Verified!. You can now sign in.',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 10.0),
                      ElevatedButton(
                        child: Text('Continue'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => DashboardPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Theme(
            data: themeManager.isLightTheme
                ? ThemeData.light()
                : ThemeData.dark(),
            child: Scaffold(
              // if email is not verified, show this.
              appBar: AppBar(
                title: Text('Verify Email'),
              ),
              body: Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Please verify your email.',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.0),
                      ElevatedButton.icon(
                        // it requries label and icon other than onPressed.
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          // change button color to grey if canResendEmail is false.
                          backgroundColor:
                              canResendEmail ? Colors.blue : Colors.grey,
                        ),
                        icon: Icon(Icons.email),
                        onPressed: () {
                          canResendEmail ? sendVerificationEmail() : null;
                        },
                        label: Text('Resend Email'),
                      ),
                      SizedBox(height: 10.0),
                      ElevatedButton(
                        child: Text('Cancel'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      if (_isLoading) // show loading indicator
                        CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
