import 'package:provider/provider.dart';
import 'package:space_lab_tasks/Profile%20UI/profile_ui.dart';
import 'package:space_lab_tasks/auth_test.dart';
import 'package:flutter/material.dart';
import 'package:space_lab_tasks/theme_manager.dart';

class ChangeProfileInfo extends StatefulWidget {
  final String initialName;
  final String initialEmail;
  final String initialDOB;

  final Function(String name) onNameUpdated;
  final Function(String email) onEmailUpdated;
  // final Function(String password) onPasswordUpdated;
  final Function(String dob) onDOBUpdated;
  final Function onSave;

  const ChangeProfileInfo({
    Key? key,
    required this.onNameUpdated,
    required this.onEmailUpdated,
    // required this.onPasswordUpdated,
    required this.initialName,
    required this.initialEmail,
    required this.initialDOB,
    required this.onDOBUpdated,
    required this.onSave,
  }) : super(key: key);

  @override
  State<ChangeProfileInfo> createState() => _ChangeProfileInfoState();
}

class _ChangeProfileInfoState extends State<ChangeProfileInfo> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController dobController;
  // final passwordController = TextEditingController();
  // final confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialName);
    emailController = TextEditingController(text: widget.initialEmail);
    dobController = TextEditingController(text: widget.initialDOB);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    dobController.dispose();
    // passwordController.dispose();
    // confirmPasswordController.dispose();
    super.dispose();
  }

  void updateUserDetailsAndGoBack() {
    if (_formKey.currentState!.validate()) {
      widget.onNameUpdated(nameController.text);
      widget.onEmailUpdated(emailController.text);
      widget.onDOBUpdated(dobController.text);
      // widget.onPasswordUpdated(passwordController.text);

      widget.onSave();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ProfileUI()));
    }
  }

  void updateName(String name) {
    widget.onNameUpdated(name);
  }

  void updateEmail(String email) {
    widget.onEmailUpdated(email);
  }

  // void updatePassword(String password) {
  //   widget.onPasswordUpdated(password);
  // }

  void updateDOB(String dob) {
    widget.onDOBUpdated(dob);
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
        dobController.text = picked.toString().substring(8, 10) +
            "/" +
            picked.toString().substring(5, 7) +
            "/" +
            picked.toString().substring(0, 4);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return Theme(
      data: themeManager.isLightTheme ? ThemeData.light() : ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Change Profile Information'),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Add Profile Picture Update section
      
                // Other details update section
                Flexible(
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                    validator: (value) {
                      if (!checkValidName(nameController.text)) {
                        return 'Please enter a valid name';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      updateName(value!);
                    },
                  ),
                ),
                
                SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

                Flexible(
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    validator: (value) {
                      if (!checkValidEmail(emailController.text)) {
                        return 'Please enter a valid email';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      updateEmail(value!);
                    },
                  ),
                ),
      
                SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

                Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                    child: GestureDetector(
                      onTap: () {
                        _openDatePicker();
                      },
                      child: AbsorbPointer(
                        absorbing: true,
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          readOnly: false,
                          controller: dobController,
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                // Padding(
                //   padding: EdgeInsets.only(top: 10),
                //   child: SizedBox(
                //     height: 50,
                //     width: 320,
                //     child: TextFormField(
                //       controller: passwordController,
                //       decoration: const InputDecoration(
                //         border: OutlineInputBorder(),
                //         labelText: 'Password',
                //       ),
                //       validator: (value) {
                //         if (value == null || value.isEmpty) {
                //           return 'Please enter your password';
                //         }
                //         if (value.length < 8) {
                //           return 'Password must be at least 8 characters long';
                //         }
                //         return null;
                //       },
                //       onSaved: (value) {
                //         updatePassword(value!);
                //       },
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(top: 10),
                //   child: SizedBox(
                //     height: 50,
                //     width: 320,
                //     child: TextFormField(
                //       controller: confirmPasswordController,
                //       decoration: const InputDecoration(
                //         border: OutlineInputBorder(),
                //         labelText: 'Confirm Password',
                //       ),
                //       validator: (value) {
                //         if (value == null || value.isEmpty) {
                //           return 'Please confirm your password';
                //         }
                //         if (value != passwordController.text) {
                //           return 'Passwords do not match';
                //         }
                //         return null;
                //       },
                //     ),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ElevatedButton(
                      onPressed: updateUserDetailsAndGoBack,
                      child: const Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
