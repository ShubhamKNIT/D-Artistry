import 'package:flutter/material.dart';
import 'package:space_lab_tasks/BottomNavigation/add_task_page_button.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ListView.builder(
        itemCount: todoItems.length,
        itemBuilder: (context, index) {
          final todo = todoItems[index];
          return ListTile(
            title: Text(todo.title),
            // Add more details like checkboxes, due dates, etc.
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTaskPage(),
            ),
          );
        }, 
      ),
    );
  }
}


// Task Model
class Task {
  String title;
  DateTime dueDate;
  TimeOfDay reminderTime;
  String note;
  bool isImportant;
  Color taskColor;

  Task({
    required this.title,
    required this.dueDate,
    required this.reminderTime,
    this.note = '',
    this.isImportant = false,
    this.taskColor = Colors.blue, // Default color
  });
}

// List of Tasks
List<Task> todoItems = [];