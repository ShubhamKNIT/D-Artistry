import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:space_lab_tasks/Firestore/profile_page_crud.dart';
import 'edit_profile.dart';

class ProfileUI extends StatefulWidget {
  const ProfileUI({Key? key}) : super(key: key);

  @override
  State<ProfileUI> createState() => _ProfileUIState();
}

class _ProfileUIState extends State<ProfileUI> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreProfileCRUD _firestoreService = FirestoreProfileCRUD();

  User? _user;
  bool _isLoading = true;
  Map<String, dynamic> _userData = {
    'name': 'Set Name',
    'email': 'user@example',
    'dateOfBirth': '01/01/2000',
  };

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchUserData(); // Fetch data whenever dependencies change
  }

  Future<void> _fetchUserData() async {
    _user = _auth.currentUser;
    if (_user != null) {
      Map<String, dynamic> userData =
          await _firestoreService.getUserDetails(_user!.uid);

      if (mounted) {
        setState(() {
          if (userData.isNotEmpty) {
            _userData = userData;
          }
          _isLoading = false;
        });
      }

    }
  }

  // Function to update user details
  Future<void> updateUserDetails(String userId, Map<String, dynamic> userData) async {
    String? docId = await _firestoreService.getDocumentIdForUserDetails(userId);
    
    if (docId != null) {
      try {
        Map<String, dynamic> updatedUserData = {
          'name': userData['name'],
          'dateOfBirth': userData['dateOfBirth'],
          'email': userData['email'],
        };

        await _firestoreService.setUserDetails(userId, docId, updatedUserData);
        _fetchUserData(); // Refresh the displayed data after updating
        print('User details updated successfully!');
      } catch (e) {
        print('Error updating user details: $e');
      }
    } else {
      print('Document ID not found.');
    }
  }



  // Function to update user name
  void updateUserName(String newName) {
    setState(() {
      _userData['name'] = newName;
    });
    // updateUserDetails(_user!.uid, _userData);
  }

  // Function to update user email
  void updateEmail(String newEmail) {
    setState(() {
      _userData['email'] = newEmail;
    });
    // updateUserDetails(_user!.uid, _userData);
  }

  // Function to update user date of birth
  void updateDOB(String newDOB) {
    setState(() {
      _userData['dateOfBirth'] = newDOB;
    });
    // updateUserDetails(_user!.uid, _userData);
  }

  @override
  Widget build(BuildContext context) {
    String? email = _user!.email;
    return RefreshIndicator(
      child: Scaffold(
        // // Floating Action Button
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     navigateSecondPage(
        //       ChangeProfileInfo(
        //         initialName: _userData['name'],
        //         initialEmail: _userData['email'],
        //         initialDOB: _userData['dateOfBirth'],
        //         onNameUpdated: updateUserName,
        //         onEmailUpdated: updateEmail,
        //         onDOBUpdated: updateDOB, onSave: () async { 
        //           // Update Firestore data
        //             String userId = _user!.uid;
        //             String? docId = await _firestoreService.getDocumentIdForUserDetails(userId);
        //             Map<String, dynamic> userData = {
        //               'name': _userData['name'],
        //               'email': _userData['email'],
        //               'dateOfBirth': _userData['dateOfBirth'],
        //             };
        //             await _firestoreService.setUserDetails(userId, docId!, userData)
        //             .then((_) {
        //               print('User details updated successfully!');
        //               // Optionally, update the displayed data after saving

        //               _fetchUserData();
        //             })
        //             .catchError((error) {
        //               print('Error updating user details: $error');
        //             });
        //          },
        //         // onPasswordUpdated: (String password) {
        //           // Handle password update
        //         // },
        //       ),
        //     );
        //   },
        //   backgroundColor: Colors.orange,
        //   child: Icon(Icons.edit),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
        body: _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Column(
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
                    // lets make a function to build the profile details
                    // i do not want to use _userData 
                    // i want to directly fetch user email from firebase
                    _buildProfileDetail('Username', _userData['name']),
                    _buildProfileDetail('email', email!),
                    _buildProfileDetail('Date of Birth', _userData['dateOfBirth']),

                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Delete account from the firestore
                          },
                          child: Text('Delete Account'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            navigateSecondPage(
                              ChangeProfileInfo(
                                initialName: _userData['name'],
                                initialEmail: email,
                                initialDOB: _userData['dateOfBirth'],
                                onNameUpdated: updateUserName,
                                onEmailUpdated: updateEmail,
                                onDOBUpdated: updateDOB,
                                onSave: () async {
                                  await updateUserDetails(_user!.uid, {
                                    'name': _userData['name'],
                                    'email': _userData['email'],
                                    'dateOfBirth': _userData['dateOfBirth'],
                                  });
                                  // _fetchUserData(); // Refresh the displayed data after updating
                                  Navigator.pop(context); // Go back to the profile page
                                },
                              ),
                            );
                          },
                          child: Text('Edit Profile'),
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

  Widget _buildProfileDetail(String label, String? value) {
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
                    value ?? 'N/A', // If value is null, show 'N/A'
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
  String dob = '01/01/2000';

  // setter
  void setName(String name) {
    this.name = name;
  }

  void setEmail(String email) {
    this.email = email;
  }

  void setDOB(String dob) {
    this.dob = dob;
  }
}
