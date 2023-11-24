import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:space_lab_tasks/BottomNavigation/add_task_page_button.dart';
import 'package:space_lab_tasks/BottomNavigation/update_task_page.dart';
import 'package:space_lab_tasks/Firestore/firestore_todo_crud.dart';
import 'package:space_lab_tasks/theme_manager.dart';

class TodoListPage extends StatefulWidget {
  final ThemeManager themeManager;
  const TodoListPage({super.key, required this.themeManager});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  ThemeManager get themeManager => widget.themeManager;
  // get instance of FirestoreTodoCRUD class
  final FirestoreTodoCRUD firestoreTodoCRUD = FirestoreTodoCRUD();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream: firestoreTodoCRUD.db.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<DocumentSnapshot> tasks = snapshot.data!.docs;

              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  // get each individual doc
                  DocumentSnapshot task = tasks[index];

                  // get data from doc
                  bool isCompleted = task['completed'];
                  String title = task['title'];
                  // format date and time
                  DateTime dueDate = task['dueDate'].toDate();
                  TimeOfDay reminderTime = TimeOfDay(
                    hour: int.parse(task['reminderTime'].split(':')[0]),
                    minute: int.parse(task['reminderTime'].split(':')[1]),
                  );
                  String note = task['note'];
                  bool isImportant = task['isImportant'];
                  Color taskColor = Color(task['taskColor']);
                  // String? imageUri = task['image'];
                  // String? audioUri = task['audio'];

                  // task container
                  return Container(
                    margin: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: taskColor,
                      shape: BoxShape.rectangle,
                      border: Border.all(
                        color: Colors.grey.shade500,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 0.4,
                          color: Colors.grey.shade500,
                          offset: Offset(0.2, 0.4),
                          blurStyle: BlurStyle.normal,
                        ),
                      ],
                      // blend image with background color
                      backgroundBlendMode: taskColor == Colors.black
                          ? BlendMode.difference
                          : null,
                    ),
                    child: ExpansionTile(
                      shape: ShapeBorder.lerp(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        1,
                      ),
                      title: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        'Due: ${dueDate.day}/${dueDate.month}/${dueDate.year} at ${reminderTime.hour}:${reminderTime.minute}',
                        style: const TextStyle(
                            fontSize: 15.0, color: Colors.white),
                      ),
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  // isCompleted
                                  onPressed: () {
                                    setState(
                                      () {
                                        firestoreTodoCRUD.updateTask(
                                          !isCompleted,
                                          task.id,
                                          title,
                                          dueDate,
                                          reminderTime,
                                          note,
                                          isImportant,
                                          taskColor,
                                          // null,
                                          // null
                                        );
                                      },
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      isCompleted
                                          ? SnackBar(
                                              content: Text(
                                                  'Marked as not completed!'),
                                              duration:
                                                  Duration(milliseconds: 400),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            )
                                          : SnackBar(
                                              content:
                                                  Text('Marked as completed!'),
                                              duration:
                                                  Duration(milliseconds: 400),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ),
                                    );
                                  },
                                  icon: isCompleted
                                      ? const Icon(Icons.check_box)
                                      : const Icon(
                                          Icons.check_box_outline_blank),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(
                                      () {
                                        firestoreTodoCRUD.updateTask(
                                          isCompleted,
                                          task.id,
                                          title,
                                          dueDate,
                                          reminderTime,
                                          note,
                                          !isImportant,
                                          taskColor,
                                          // null,
                                          // null
                                        );
                                      },
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      isImportant
                                          ? SnackBar(
                                              content: Text(
                                                  'Marked as not important!'),
                                              duration:
                                                  Duration(milliseconds: 400),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            )
                                          : SnackBar(
                                              content:
                                                  Text('Marked as important!'),
                                              duration:
                                                  Duration(milliseconds: 400),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ),
                                    );
                                  },
                                  icon: isImportant
                                      ? const Icon(Icons.star)
                                      : const Icon(Icons.star_border),
                                ),
                                // to update task
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdateTaskPage(
                                            docID: task.id,
                                            task: Task(
                                              title: title,
                                              dueDate: dueDate,
                                              reminderTime: reminderTime,
                                              note: note,
                                              isImportant: isImportant,
                                              taskColor: taskColor,
                                              // image: imageUri != null ? File(imageUri) : null,
                                              // audio: audioUri != null ? File(audioUri) : null,
                                            )),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {
                                    firestoreTodoCRUD.deleteTask(task.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Task deleted successfully!'),
                                        duration: Duration(seconds: 2),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      note,
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                // Expanded(
                                //   child: Container(
                                //     padding: const EdgeInsets.all(10.0),
                                //     child: imageUri != null ? Image.network(imageUri) : null,
                                //   ),
                                // ),
                                // Expanded(
                                //   child: Container(
                                //     padding: const EdgeInsets.all(10.0),
                                //     child: audioUri != null ? Text('Audio: $audioUri') : null,
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTaskPage(themeManager: themeManager),
              ),
            );
          },
        ),
      ),
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        setState(
          () {
            // while refreshing, sort tasks by due date
            todoItems.sort((a, b) => a.dueDate.compareTo(b.dueDate));
          },
        );
      },
    );
  }
}

// Task Model
class Task {
  bool isCompleted;
  String title;
  DateTime dueDate;
  TimeOfDay reminderTime;
  String note;
  bool isImportant;
  Color taskColor;
  File? image;
  File? audio;
  String? docID;

  Task({
    this.isCompleted = false,
    required this.title,
    required this.dueDate,
    required this.reminderTime,
    this.note = '',
    this.isImportant = false,
    this.taskColor = Colors.blue, // Default color
    this.image,
    this.audio,
  });
}

// List of Tasks
List<Task> todoItems = [];
