import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "firebase_options.dart";

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<StatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  
  // late is preferred over var
  // late keyword is used to denote a variable that will be assigned a value later
  // and it will not be null
  // final to make immutable

  // late final TextEditingController _firstname;
  // late final TextEditingController _lastname;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;



  // create a function to initialize the state of the text controllers
  @override
  void initState() {
    // _firstname = TextEditingController();
    // _lastname = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
    super.initState();
  }

  // dispose of the text controllers when the widget is removed from the tree
  @override
  void dispose() {
    // _firstname.dispose();
    // _lastname.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  // build the widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Center(
        child: Column(
          children: [
            // TextField(
            //   controller: _firstname,
            //   decoration: const InputDecoration(
            //     hintText: 'First Name',
            //   )
            // ),
            // TextField(
            //   controller: _lastname,
            //   decoration: const InputDecoration(
            //     hintText: 'Last Name',
            //   )
            // ),
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress, // @symbol for email in keyboard
              decoration: const InputDecoration(
                hintText: 'Email',
              )
            ),
            TextField(
              controller: _password,
              obscureText: true, // hide the password
              enableSuggestions: false, // disable suggestions
              autocorrect: false, // disable autocorrect
              decoration: const InputDecoration(
                hintText: 'Password',
              )
            ),
            TextField(
              controller: _confirmPassword,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'Confirm Password',
              )
            ),
            TextButton(
              onPressed: () async {
                await Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform,
                );

                // final firstname = _firstname.text;
                // final lastname = _lastname.text;
                final email = _email.text;
                final password = _password.text;
                final confirmPassword = _confirmPassword.text;
                if (password != confirmPassword) {
                  throw Exception("Passwords do not match");
                }
                final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email, 
                  password: password
                );

                // Add method to navigate to dashboard page

                if (kDebugMode) {
                  print(userCredential.user);
                }  
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}