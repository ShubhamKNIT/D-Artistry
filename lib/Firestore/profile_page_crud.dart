import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProfileCRUD {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');


  Future<Map<String, dynamic>> getUserDetails(String userId) async {
    try {
      QuerySnapshot userDetailsDocs = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('user_details')
          .limit(1) // Limit to only retrieve one document
          .get();

      if (userDetailsDocs.docs.isNotEmpty) {
        Map<String, dynamic> data = userDetailsDocs.docs.first.data()
            as Map<String, dynamic>;
        return data;
      } else {
        return {}; // Return an empty map or handle the scenario accordingly
      }
    } catch (e) {
      print("Error fetching user details: $e");
      return {}; // Return an empty map or handle the error accordingly
    }
  }

  Future<void> setUserDetails(String userId, String docId, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('user_details')
          .doc(docId)
          .set(data);
    } catch (e, stackTrace) {
      print("Error setting user details: $e\n$stackTrace");
    }
  }

  Future<String?> getDocumentIdForUserDetails(String userId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('user_details')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If there are multiple documents, you might iterate through them
        // or return the first document ID (querySnapshot.docs[0].id)
        return querySnapshot.docs[0].id;
      }
    } catch (e) {
      print("Error fetching document ID: $e");
    }
    return null;
  }

}
