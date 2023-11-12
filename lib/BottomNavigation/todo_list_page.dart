

import 'package:flutter/material.dart';
import 'package:space_lab_tasks/BottomNavigation/add_task_page_button.dart';
import 'package:space_lab_tasks/Database/database_provider.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  // List of Tasks
  List<Task> todoItems = [];

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  void fetchTasks() async {
    // Fetch tasks for the current user
    final tasks = await DatabaseProvider.getTasksByUserId(/*get user id*/ 1);
    setState(() {
      todoItems = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ListView.builder(
        itemCount: todoItems.length,
        itemBuilder: (context, index) {
          final todo = todoItems[index];
          return ListTile(
            title: Text(todo.taskName),
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

