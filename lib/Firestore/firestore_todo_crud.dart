// import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirestoreTodoCRUD {
  // get collection of tasks
  late final CollectionReference db; // database reference

  // get user id from Firebase Auth
  User? user = FirebaseAuth.instance.currentUser;
  late final String? userId;

  FirestoreTodoCRUD() {
    // using constructor to get user id // no parameter
    if (user != null) {
      userId = user!.uid;
      // users -> uid -> tasks -> task id -> task data (storage hierarchy)
      db = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('tasks');
    } else {
      // Handle the case where user is null
      throw Exception('User is null');
    }
  }

  // upload binary data to Firebase Storage
  // static Future<String> uploadAudioImageToFirebase(
  //     File file, bool imageTrue) async {
  //   try {
  //     final storageRef = FirebaseStorage.instance.ref();
  //     late final Reference fileName;
  //     if (imageTrue) {
  //       // store image file uri
  //       fileName = storageRef.child('images/${DateTime.now()}.png');
  //     } else {
  //       // store audio file uri
  //       fileName = storageRef.child('audio/${DateTime.now()}.mp3');
  //     }
  //     await fileName.putFile(file);
  //     final cloudImageURL = await fileName.getDownloadURL();
  //     return cloudImageURL;
  //   } on FirebaseException catch (e) {
  //     print('FirebaseException: $e');
  //     return '';
  //   } catch (e) {
  //     print('Error: $e');
  //     return '';
  //   }
  // }

  // add task
  Future<void> addTask(
    bool completed,
    String title,
    DateTime dueDate,
    TimeOfDay reminderTime,
    String note,
    bool isImportant,
    Color taskColor,
    // File? image,
    // File? audio
  ) async {
    // unsupported data type conversions to support Firestore
    String reminderTimeAsString =
        reminderTime.hour.toString() + ':' + reminderTime.minute.toString();
    // int taskColorAsInt = taskColor.value;
    // Uri imageUri = image!.uri;
    // Uri audioUri = audio!.uri;

    // upload audio and image to Firebase Storage
    // String imageUrl = '';
    // String audioUrl = '';

    // if (image != null) {
    //   imageUrl = await uploadAudioImageToFirebase(image, true);
    // }

    // if (audio != null) {
    //   audioUrl = await uploadAudioImageToFirebase(audio, false);
    // }

    // add task to Firestore
    await db.add(
      {
        // document style storage
        'title': title,
        'dueDate': dueDate,
        'reminderTime': reminderTimeAsString,
        'note': note,
        'isImportant': isImportant,
        'taskColor': taskColor.value,
        // 'image': imageUrl.isNotEmpty ? imageUrl : null,
        // 'audio': audioUrl.isNotEmpty ? audioUrl : null,
        'completed': completed,
        'timestamp': FieldValue
            .serverTimestamp(), // https://firebase.flutter.dev/docs/firestore/usage/#timestamps
      },
    ).whenComplete(
      () {
        print('Task added');
        print(DateTime.now());
      },
    ).catchError(
      (e) {
        throw Exception('Error adding task: $e');
      },
    );
  }

  // get tasks
  Stream<QuerySnapshot> getTasks() {
    if (userId != null) {
      CollectionReference getTodoItems = FirebaseFirestore.instance
          .collection('users')
          .doc(userId!)
          .collection('tasks');
      return getTodoItems.snapshots();
    } else {
      // Handle the case where userId is null
      throw Exception('User ID is null');
    }
  }

  // update task
  Future<void> updateTask(
    bool completed,
    String docId,
    String title,
    DateTime dueDate,
    TimeOfDay reminderTime,
    String note,
    bool isImportant,
    Color taskColor,
    // File? image,
    // File? audio
  ) async {
    DocumentReference docRef = db.doc(docId);

    // Format TimeOfDay to String
    String reminderTimeAsString = '${reminderTime.hour}:${reminderTime.minute}';

    // // upload audio and image to Firebase Storage if available
    // String imageUrl = '';
    // String audioUrl = '';

    // if (image != null) {
    //   imageUrl = await uploadAudioImageToFirebase(image, true);
    // }

    // if (audio != null) {
    //   audioUrl = await uploadAudioImageToFirebase(audio, false);
    // }

    await docRef.update(
      {
        'title': title,
        'dueDate': dueDate,
        'reminderTime': reminderTimeAsString,
        'note': note,
        'isImportant': isImportant,
        'taskColor': taskColor.value,
        // 'image': imageUrl.isNotEmpty ? imageUrl : null,
        // 'audio': audioUrl.isNotEmpty ? audioUrl : null,
        'completed': completed,
        'timestamp': FieldValue.serverTimestamp(),
      },
    ).whenComplete(
      () {
        print('Task updated: $docId');
        print(DateTime.now());
      },
    ).catchError(
      (e) {
        print(e);
      },
    );
  }

  // delete task
  Future<void> deleteTask(String docId) async {
    await db.doc(docId).delete().whenComplete(
      () {
        print('Task deleted: $docId');
        print(DateTime.now());
      },
    ).catchError(
      (e) {
        print(e);
      },
    );
  }
}
