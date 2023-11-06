import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:space_lab_tasks/dashboard_page.dart';

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
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardPage(), // Replace with your dashboard page
        ),
      );
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
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
              
              ElevatedButton(
                onPressed: () {
                  _handleEmailSignIn();
                },
                child: const Text('Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
