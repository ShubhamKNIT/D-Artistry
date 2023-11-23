import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Function to delete user account and associated data
Future<void> deleteAccountAndData() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Get the current user
  User? user = auth.currentUser;

  if (user != null) {
    try {
      // Get the user's UID
      String userId = user.uid;

      // Reference to the collection for this user
      CollectionReference userCollection = firestore.collection('users').doc(userId).collection('user_data');

      // Delete all documents in the collection
      QuerySnapshot snapshot = await userCollection.get();
      for (DocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }

      // Delete the user account
      await user.delete();

      print('User account and associated data deleted successfully');
    } catch (e) {
      print('Failed to delete user account and data: $e');
    }
  } else {
    print('No user signed in.');
  }
}

// make a widget to call the function
// verify login using email and password
class DeleteAccountAndData extends StatelessWidget {
  const DeleteAccountAndData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container( 
      child: Center(
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () async {
                await deleteAccountAndData();
              },
              child: Text('Delete Account and Data'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back'),
            )
          ]
        ),
      )
    );
  }
}
