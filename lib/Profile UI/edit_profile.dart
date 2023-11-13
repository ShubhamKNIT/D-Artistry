import 'package:flutter/material.dart';

// implement change profile information likle name, email, phone number, password, etc

class ChangeProfileInfo extends StatefulWidget {
  final String initialName;
  final String initialEmail;
  final String initialPhone;
  final String initialDOB;

  final Function(String name) onNameUpdated;
  final Function(String email) onEmailUpdated;
  final Function(String phone) onPhoneUpdated;
  final Function(String password) onPasswordUpdated;
  final Function(String dob) onDOBUpdated;

  const ChangeProfileInfo(
      {Key? key,
      required this.onNameUpdated,
      required this.onEmailUpdated,
      required this.onPasswordUpdated,
      required this.onPhoneUpdated,
      required this.initialName,
      required this.initialEmail,
      required this.initialPhone,
      required this.initialDOB,
      required this.onDOBUpdated})
      : super(key: key);

  @override
  State<ChangeProfileInfo> createState() => _ChangeProfileInfoState();
}

class _ChangeProfileInfoState extends State<ChangeProfileInfo> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController dobController;
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialName);
    emailController = TextEditingController(text: widget.initialEmail);
    phoneController = TextEditingController(text: widget.initialPhone);
    dobController = TextEditingController(text: widget.initialDOB);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dobController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void updateUserDetailsAndGoBack() {
    if (_formKey.currentState!.validate()) {
      widget.onNameUpdated(nameController.text);
      widget.onEmailUpdated(emailController.text);
      widget.onDOBUpdated(dobController.text);
      widget.onPhoneUpdated(phoneController.text);
      widget.onPasswordUpdated(passwordController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );

      Navigator.pop(context);
    }
  }

  void updateName(String name) {
    widget.onNameUpdated(name);
  }

  void updateEmail(String email) {
    widget.onEmailUpdated(email);
  }

  void updatePhone(String phone) {
    widget.onPhoneUpdated(phone);
  }

  void updatePassword(String password) {
    widget.onPasswordUpdated(password);
  }

  void updateDOB(String dob) {
    widget.onDOBUpdated(dob);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Profile Information'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 40, right: 40),
          // padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Add Profile Picture Update section

              // Other details update section
              Padding(
                padding: EdgeInsets.only(top: 40),
                child: SizedBox(
                  height: 50,
                  width: 320,
                  child: TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      updateName(value!);
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: SizedBox(
                  height: 50,
                  width: 320,
                  child: TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      updateEmail(value!);
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: SizedBox(
                  height: 50,
                  width: 320,
                  child: TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Phone Number',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      updatePhone(value!);
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: SizedBox(
                  height: 50,
                  width: 320,
                  child: TextFormField(
                    controller: dobController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Date of Birth',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your date of birth';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      updateDOB(value!);
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: SizedBox(
                  height: 50,
                  width: 320,
                  child: TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      updatePassword(value!);
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: SizedBox(
                  height: 50,
                  width: 320,
                  child: TextFormField(
                    controller: confirmPasswordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirm Password',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: SizedBox(
                  width: 320,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: updateUserDetailsAndGoBack,
                    child: const Text('Submit'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
