import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:space_lab_tasks/alert_dialog.dart";
import "package:space_lab_tasks/auth_test.dart";
import "package:space_lab_tasks/email_password_login_page.dart";
import "package:space_lab_tasks/first_page.dart";
import "package:space_lab_tasks/verify_email.dart";
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

  late final TextEditingController _name;
  late final TextEditingController _dateOfBirthController;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;
  late bool _isPasswordVisible = false; // to change password visibility
  late bool _isLoading = false; // to show loading indicator

  // create a function to initialize the state of the text controllers
  @override
  void initState() {
    _name = TextEditingController();
    _dateOfBirthController = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
    _isPasswordVisible = false;
    _isLoading = false;
    super.initState();
  }

  // dispose of the text controllers when the widget is removed from the tree
  @override
  void dispose() {
    _name.dispose();
    _dateOfBirthController.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _isPasswordVisible = false;
    _isLoading = false;
    super.dispose();
  }

  // Separate method to open the Date Picker
  Future<void> _openDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        // reverse the date format to dd/mm/yyyy
        _dateOfBirthController.text = picked.toString().substring(8, 10) +
            "/" +
            picked.toString().substring(5, 7) +
            "/" +
            picked.toString().substring(0, 4);
      });
    }
  }

  Future<void> _handleSignUp() async {
    try {
      setState(
        () {
          // show loading indicator // it starts after clicking signup button
          _isLoading = true;
        },
      );

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      if (_name.text == "" ||
          _email.text == "" ||
          _password.text == "" ||
          _confirmPassword.text == "") {
        // check any of the required fields are empty
        showErrorDialog(
            context,
            "Please make sure to enter all the required fields.",
            "Try Again",
            'OK',
            'Cancel');
      } else {
        // Attempt to create a user
        final userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
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

        await Future.delayed(Duration(
            seconds: 2)); // delays navigation to login page by 5 seconds
        // holding page to display successful signup message to user

        // Navigate to verify email page
        if (userCredential.user != null) {
          // start of firestore data collection
          String uid = userCredential.user!.uid;

          // users/doc/user_details/doc
          DocumentReference userDetailsRef = FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('user_details')
              .doc();

          // Store user details in the 'user_details' document
          await userDetailsRef.set(
            {
              'name': _name.text,
              'dateOfBirth': _dateOfBirthController.text,
              'email': _email.text,
            },
          );
          // end of firestore data collection

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyEmail(),
            ),
          );
        } else {
          // show error dialog
          showErrorDialog(context, "Sign Up Failed. Please try again.",
              "Try Again", 'OK', 'Cancel');
        }

        if (kDebugMode) {
          print(userCredential.user);
        }
      }
    } catch (err) {
      showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('User already exists'),
          content: const Text(
              'Please go back to sign in page. Try sign in using login credentials associated with email. Go back to sign in page.'),
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
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } finally {
      setState(
        () {
          _isLoading = false; // hide loading indicator
        },
      );
    }
  }

  // build the widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Text(
                  'Welcome! to sign up page.',
                  style: TextStyle(fontSize: 15),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                // name container
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _name,
                    keyboardType:
                        TextInputType.name, // @symbol for email in keyboard
                    validator: (value) {
                      if (checkValidName(value!)) {
                        return null;
                      } else {
                        return 'Name must consist of only alphabets.';
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: 'Name',
                      icon: Icon(Icons.person),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // dob container
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: GestureDetector(
                    onTap: () {
                      _openDatePicker();
                    },
                    child: AbsorbPointer(
                      absorbing: true,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        readOnly: true,
                        controller: _dateOfBirthController,
                        validator: (value) {
                          if (checkValidDOB(value!)) {
                            return null;
                          } else {
                            return 'User must be 7 years or older.';
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Date of Birth',
                          icon: Icon(Icons.calendar_today),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // email container
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _email,
                    keyboardType: TextInputType
                        .emailAddress, // @symbol for email in keyboard
                    validator: (value) {
                      if (checkValidEmail(value!)) {
                        return null;
                      } else {
                        return 'Please enter a valid email address';
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      icon: Icon(Icons.email),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // password container
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _password,
                    obscureText:
                        !_isPasswordVisible, // hide the password (we can also use obscureText: true, but visibilty does not change)
                    enableSuggestions: false, // disable suggestions
                    autocorrect: false, // disable autocorrect
                    validator: (value) {
                      if (checkValidPassword(value!)) {
                        return null;
                      } else {
                        return '[a-z] [A-Z] [0-9] [!@#\$&*~] must be present in password.';
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Password',
                      icon: Icon(Icons.lock),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
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

                SizedBox(height: 10),

                // confirm password container
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
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
                      suffixIcon: IconButton(
                        // change visibility of password
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
                  ),
                ),

                SizedBox(height: 16),

                // Sign Up Cancel Buttons
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _handleSignUp();
                      },
                      child: const Text('Sign Up'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                if (_isLoading) const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
