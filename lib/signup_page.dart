import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:space_lab_tasks/alert_dialog.dart";
import "package:space_lab_tasks/auth_test.dart";
import "package:space_lab_tasks/email_password_login_page.dart";
import "package:space_lab_tasks/first_page.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:space_lab_tasks/verify_email.dart";
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
  bool _isPasswordVisible = false; // to change password visibility
  bool _isLoading = false; // to show loading indicator

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


  Future<void> _handleSignUp() async {
    try { 

      setState(() { // show loading indicator // it starts after clicking signup button
        _isLoading = true; 
      });

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // final firstname = _firstname.text;
      // final lastname = _lastname.text;
      if (_email.text == "" || _password.text == "" || _confirmPassword.text == "") {
      // check any of the required fields are empty
        showErrorDialog(context, "Please make sure to enter all the required fields." , "Try Again", 'OK', 'Cancel');
      } 
      else {
        // Attempt to create a user
        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text, 
        password: _password.text,
      );


      // using scaffoldmessanger to show successful signup message to user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign Up Successful'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );


      await Future.delayed(Duration(seconds: 2)); // delays navigation to login page by 5 seconds
      // holding page to display successful signup message to user

      // Navigate to verify email page
      if (userCredential.user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyEmail(),
          ),
        );
      } else {
        // show error dialog
        showErrorDialog(context, "Sign Up Failed. Please try again.", "Try Again", 'OK', 'Cancel');
      }

      if (kDebugMode) {
        print(userCredential.user);
      }
    }
    } 
    catch (err) {
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
    finally {
      setState(() {
        _isLoading = false; // hide loading indicator
      });
    }
  }

  // build the widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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

              // email container
              Text(
                'Welcome! to sign up page.',
                style: TextStyle(fontSize: 15),
              ),

              SizedBox(height: 25),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _email,
                  keyboardType: TextInputType.emailAddress, // @symbol for email in keyboard
                  validator: (value) {
                    if (checkValidEmail(value!)) {
                      return null;
                    }
                    else {
                      return 'Please enter a valid email address';
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    icon: Icon(Icons.email),
                    border: InputBorder.none,
                  )
                ),
              ),

              SizedBox(height: 10),

              // password container
              Container( 
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _password,
                  obscureText: !_isPasswordVisible, // hide the password (we can also use obscureText: true, but visibilty does not change)
                  enableSuggestions: false, // disable suggestions
                  autocorrect: false, // disable autocorrect
                  validator: (value) {
                    if (checkValidPassword(value!)) {
                      return null;
                    }
                    else {
                      return 'Your password must be longer than 8 characters and also \ncontains oneuppercase, one lowercase, one number and \none special character.';
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Password',
                    icon: Icon(Icons.lock),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  )
                ),
              ),

              SizedBox(height: 10),

              // confirm password container
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _confirmPassword,
                  obscureText: !_isPasswordVisible, // to hide the password
                  enableSuggestions: false,
                  autocorrect: false,
                  validator: (value) {
                    if (_password.text == _confirmPassword.text) {
                      return null;
                    } else {
                      return 'Your password do not match. Please retype the password.';
                    }
                  },
                  decoration: InputDecoration(
                    icon: Icon(Icons.lock),
                    hintText: 'Confirm Password',
                    border: InputBorder.none,
                    suffixIcon: IconButton( // change visibility of password
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _handleSignUp();
                    },
                    child: const Text('Sign Up'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
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
              SizedBox(height: 16),
              if (_isLoading)
                const CircularProgressIndicator(),
            ],
          ),
        ),
      )
    );
  }
}