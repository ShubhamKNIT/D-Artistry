import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailPasswordLoginPage extends StatefulWidget {
  const EmailPasswordLoginPage({super.key});

  @override
  _EmailPasswordLoginPageState createState() => _EmailPasswordLoginPageState();
}

class _EmailPasswordLoginPageState extends State<EmailPasswordLoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _handleEmailSignIn() async {
    try {
      final String email = _emailController.text;
      final String password = _passwordController.text;

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Navigate to the next screen after successful login.
    } catch (error) {
      print(error.toString());
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
              ElevatedButton(
                onPressed: () {
                  _handleEmailSignIn();
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
