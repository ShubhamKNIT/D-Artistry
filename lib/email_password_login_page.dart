import 'package:space_lab_tasks/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:space_lab_tasks/first_page.dart';

class EmailPasswordLoginPage extends StatefulWidget {
  const EmailPasswordLoginPage({super.key});

  @override
  EmailPasswordLoginPageState createState() => EmailPasswordLoginPageState();
}

class EmailPasswordLoginPageState extends State<EmailPasswordLoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

Future<void> _handleEmailSignIn() async {
  try {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    // await _auth.setPersistence(Persistence.LOCAL); // Set local persistence
    await _auth.signInWithEmailAndPassword(email: email, password: password);

    // Navigate to the dashboard page after successful login.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const DashboardPage(),
      ),
    );
  } on FirebaseAuthException catch (e) {
    print('Failed with error code: ${e.code}');
    print(e.message);
    showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Error'),
        content: const Text('Invalid login credentials. Please try again with valid login credentials.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
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
              const Text('Welcome back! Sign in with your email and password.'),

              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),

              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
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
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => FirstPage()
                        )
                      );
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
  