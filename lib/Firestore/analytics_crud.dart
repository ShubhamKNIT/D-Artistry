import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreAnalyticsCRUD {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, int>> getTotalTasks(String userId) async {
    try {
      // Construct the path to the tasks collection for the user
      String userTasksPath = '/users/$userId/tasks';

      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection(userTasksPath) // Use the constructed path
          .get();

      int totalTasks = snapshot.docs.length;
      int completedTasks = snapshot.docs
          .where((doc) => doc['completed'] == true)
          .toList()
          .length;

      return {'totalTasks': totalTasks, 'completedTasks': completedTasks};
    } catch (e) {
      print('Error getting tasks: $e');
      return {'totalTasks': 0, 'completedTasks': 0};
    }
  }
}