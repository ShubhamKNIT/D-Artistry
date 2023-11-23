import 'package:space_lab_tasks/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:space_lab_tasks/first_page.dart';
import 'package:space_lab_tasks/auth_test.dart';
import 'package:space_lab_tasks/verify_email.dart';

class EmailPasswordLoginPage extends StatefulWidget {
  const EmailPasswordLoginPage({super.key});

  @override
  EmailPasswordLoginPageState createState() => EmailPasswordLoginPageState();
}

class EmailPasswordLoginPageState extends State<EmailPasswordLoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false; // to change password visibility
  bool _isLoading = false; // to show loading indicator
  bool _isEmailVerified = false; // to check if email is verified

  @override
  void initState() {
    super.initState();

    // Check if a user is already authenticated
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      _isEmailVerified = user.emailVerified;
    }

    _emailController.text = ''; // clear email field
    _passwordController.text = ''; // clear password field
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailSignIn() async {
    try {
      setState(
        () {
          _isLoading = true;
        },
      );

      final String email = _emailController.text;
      final String password = _passwordController.text;

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        await currentUser.reload();
        setState(() {
          _isEmailVerified = currentUser.emailVerified;
        });

        if (_isEmailVerified) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sign In Successful'),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );

          await Future.delayed(Duration(seconds: 2));

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const DashboardPage(),
            ),
          );
        } else {
          await _auth.currentUser!.sendEmailVerification();
          await _auth.signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyEmail(),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Error'),
          content: const Text(
              'Invalid login credentials. Please try again with valid login credentials.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
            ),
          ],
        ),
      );
    } finally {
      setState(
        () {
          _isLoading = false;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Welcome back! Sign in with your email and password.',
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 25),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  enableSuggestions: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _emailController,
                  validator: (value) {
                    if (checkValidEmail(value!)) {
                      return null;
                    } else {
                      return 'Please enter a valid email address';
                    }
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none, // to remove the underline
                    labelText: 'Email',
                    icon: Icon(Icons.email),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Password',
                    icon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(
                          () {
                            _isPasswordVisible = !_isPasswordVisible;
                          },
                        );
                      },
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _handleEmailSignIn();
                    },
                    child: const Text('Sign In'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => FirstPage()));
                    },
                    child: const Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              if (_isLoading) // if loading show circular progress indicator
                const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
