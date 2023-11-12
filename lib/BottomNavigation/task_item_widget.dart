import 'package:flutter/material.dart';

import '../Database/database_provider.dart';

class TaskItemWidget extends StatelessWidget {
  final Task task;

  const TaskItemWidget({required this.task});

  @override
  Widget build(BuildContext context) {
    final bool isImportant = task.isImportant;
    final bool hasImage = task.image != null; // Check if the task has an image
    final bool hasAudio = task.audio != null; // Check if the task has audio

    return ListTile(
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: (bool? value) {
          // Handle updating the task completion status in the database
        },
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(task.taskName),
          Icon(
            isImportant ? Icons.star : Icons.star_border,
            color: isImportant ? Colors.amber : null,
          ),
        ],
      ),
      subtitle: Text("Due: ${task.dueDate}"),
      trailing: Container(
        decoration: BoxDecoration(
          color: task.color.isNotEmpty ? Color(int.parse(task.color)) : null,
          shape: BoxShape.circle,
        ),
        width: 20,
        height: 20,
      ),
      onTap: () {
        // Handle displaying detailed information about the task
        _showTaskDetails(context);
      },
    );
  }

  void _updateTaskCompletion(String key, bool isCompleted) {
    // Update the task completion status
  }

  void _showTaskDetails(BuildContext context) {
    // Handle displaying detailed information about the task on tap
    // Use a dialog or navigate to a new screen for displaying task details
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(task.taskName),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (task.note.isNotEmpty) Text("Note: ${task.note}"),
              Image.memory(task.image),
              Text("Audio: ${task.audio}"),
              // ... Add more task details to display
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Handle modifying the task
                _modifyTask(context);
              },
              child: Text('Modify'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle deleting the task
                Navigator.pop(context); // Close the dialog after deletion
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _modifyTask(BuildContext context) {
    // Implement task modification logic
  }

  void _deleteTask(String key) {
    // Delete the task
  }
}
