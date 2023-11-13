import 'dart:async';

import 'package:flutter/material.dart';
import 'edit_profile.dart';

class ProfileUI extends StatefulWidget {
  const ProfileUI({Key? key}) : super(key: key);

  @override
  State<ProfileUI> createState() => _ProfileUIState();
}

class _ProfileUIState extends State<ProfileUI> {
  // temporary user details
  tempUser user = new tempUser();
  // Update the tempUser when the name is changed
  void updateUserName(String newName) {
    setState(() {
      user.setName(newName);
    });
  }

  void updateEmail(String newEmail) {
    setState(() {
      user.setEmail(newEmail);
    });
  }

  void updatePhone(String newPhone) {
    setState(() {
      user.setPhone(newPhone);
    });
  }

  void updateDOB(String newDOB) {
    setState(() {
      user.setDOB(newDOB);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: Scaffold(
        // Floating Action Button
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigateSecondPage(
              ChangeProfileInfo(
                initialName: user.name,
                initialEmail: user.email,
                initialPhone: user.phone,
                initialDOB: user.dob,
                onNameUpdated: updateUserName,
                onEmailUpdated: updateEmail,
                onPhoneUpdated: updatePhone,
                onDOBUpdated: updateDOB,
                onPasswordUpdated: (String password) {
                  // Handle password update
                },
              ),
            );
          },
          backgroundColor: Colors.orange,
          child: Icon(Icons.edit),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
        body: Column(
          children: [
            // Profile Picture and Name Section
            Container(
              height: MediaQuery.of(context).size.height / 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50, // Set your desired radius
                    // Replace the backgroundImage with your profile picture
                    backgroundImage:
                        NetworkImage('https://via.placeholder.com/150'),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),

            // Profile Details Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileDetail(
                    'Username',
                    user.name,
                  ),
                  _buildProfileDetail(
                    'Email',
                    user.email,
                  ),
                  _buildProfileDetail('Phone Number', user.phone),
                  _buildProfileDetail('Date of Birth', user.dob),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Delete account from the firestore
                        },
                        child: Text(
                          'Delete Account',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle sign-out functionality
                        },
                        child: Text('Sign Out'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onRefresh: () => Future.delayed(
        Duration(seconds: 1),
        () {},
      ),
    );
  }

  Widget _buildProfileDetail(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: 350,
            height: 40,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Handles navigation and prompts refresh.
  void navigateSecondPage(Widget editForm) {
    Route route = MaterialPageRoute(builder: (context) => editForm);
    Navigator.push(context, route);
  }
}

// temporary user details
class tempUser {
  String name = 'Set Name';
  String email = 'user@example';
  String phone = '1234567890';
  String dob = '01/01/2000';

  // setter
  void setName(String name) {
    this.name = name;
  }

  void setEmail(String email) {
    this.email = email;
  }

  void setPhone(String phone) {
    this.phone = phone;
  }

  void setDOB(String dob) {
    this.dob = dob;
  }
}
