import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:space_lab_tasks/alert_dialog.dart';
import 'package:space_lab_tasks/auth_test.dart';
import 'package:space_lab_tasks/email_password_login_page.dart';
import 'package:flutter/material.dart';
import 'package:space_lab_tasks/theme_manager.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password reset email sent successfully.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return Theme(
      data: themeManager.isLightTheme ? ThemeData.light() : ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Forgot Password'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _emailController,
                    enableSuggestions: true,
                    keyboardType: TextInputType.emailAddress, // @symbol for email in keyboard
                    validator: (value) {
                      if (checkValidEmail(value!)) {
                        return null;
                      }
                      else {
                        return 'Enter a valid email address.';
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      icon: Icon(Icons.email),
                      border: InputBorder.none,
                    )
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_emailController.text == '' && checkValidEmail(_emailController.text)) {
                            showErrorDialog(context, 'Please enter a valid email!!', 'Invalid Email', 'Cancel', 'Ok');
                            Navigator.pop(context);
                        }
                        else {
                          sendPasswordResetEmail(_emailController.text);
                          await Future.delayed(Duration(seconds: 2));
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EmailPasswordLoginPage()));
                        }
                      },
                      child: Text('Send Mail'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
