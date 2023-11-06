import 'package:flutter/material.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  @override
  Widget build(BuildContext context) {
    //This will be replaced with actual task widgets
    final List<String> todoItems = [
      'Task 1',
      'Task 2',
      'Task 3',
    ];

    return Scaffold(
      body: ListView.builder(
        itemCount: todoItems.length,
        itemBuilder: (context, index) {
          final todo = todoItems[index];
          return ListTile(
            title: Text(todo),
            // Add more details like checkboxes, due dates, etc.
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
        onPressed: () {}, // Replace with AddTaskPage() route (TBD)
      ),
    );
  }
}
