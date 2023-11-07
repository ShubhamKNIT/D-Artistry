import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:space_lab_tasks/email_password_login_page.dart";
import "package:space_lab_tasks/first_page.dart";
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
        automaticallyImplyLeading: false,
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
            Row(
              textDirection: TextDirection.rtl,
              children: [
                TextButton(
                  onPressed: () async {

                  try { await Firebase.initializeApp(
                      options: DefaultFirebaseOptions.currentPlatform,
                    );

                    // final firstname = _firstname.text;
                    // final lastname = _lastname.text;
                    final email = _email.text;
                    final password = _password.text;
                    final confirmPassword = _confirmPassword.text;
                  if (email == "" || password == "" || confirmPassword == "") {
                    showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Empty fields'),
                        content: const Text('Please ensure to eneter all the details.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                  else if (password != confirmPassword) {
                    showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Password Error'),
                        content: const Text('Password do not match. Please retype the password.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                    } else {
                      // Attempt to create a user
                      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email, 
                      password: password
                    );

                    // Add code to navigate to the dashboard page on success
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EmailPasswordLoginPage(),
                      ),
                    );

                    if (kDebugMode) {
                      print(userCredential.user);
                    }
                  }
                } catch (err) {
                  showDialog<String>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('User already exists'),
                      content: const Text('Please go back to sign in page. Try sign in using login credentials associated with email. Go back to sign in page.'),
                      actions: <Widget>[
                        Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const EmailPasswordLoginPage(),
                                  ),
                                );
                              },
                              child: const Text('Sign In'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancel'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
          },
                child: const Text('Sign Up'),
          ),
          TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FirstPage(),
                    ),
                  );
                },
                child: const Text('Cancel'),
          ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}