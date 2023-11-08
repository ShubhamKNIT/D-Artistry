import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:space_lab_tasks/BottomNavigation/todo_list_page.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  TextEditingController taskNameController =
      TextEditingController(); // https://api.flutter.dev/flutter/widgets/TextEditingController-class.html
  DateTime dueDate = DateTime
      .now(); // https://api.flutter.dev/flutter/dart-core/DateTime-class.html
  TimeOfDay reminderTime = TimeOfDay
      .now(); // https://api.flutter.dev/flutter/material/TimeOfDay-class.html
  bool isImportant = false;
  String note = '';
  Color taskColor = Colors.blue; // Default color and will be changed by user

  // Adding task
  void addTask() {
    Task newTask = Task(
      title: taskNameController.text,
      dueDate: dueDate,
      reminderTime: reminderTime,
      isImportant: isImportant,
      note: note,
      taskColor: taskColor,
    );

    // Add new task to list of tasks
    todoItems.add(newTask);

    Navigator.pop(context); // Return to previous page (TodoListPage)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Task Name
            TextField(
              controller: taskNameController,
              decoration: InputDecoration(
                labelText: 'Enter task name',
                border: OutlineInputBorder(),
              ),
            ),

            // Due Date
            ListTile(
              title: Text('Due Date: ${dueDate.toLocal()}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: dueDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (selectedDate != null && selectedDate != dueDate) {
                  // If date is selected
                  setState(
                    () {
                      dueDate = selectedDate;
                    },
                  );
                }
              },
            ),

            // Reminder Time
            ListTile(
              title: Text('Reminder Time: ${reminderTime.format(context)}'),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final selectedTime = await showTimePicker(
                  context: context,
                  initialTime: reminderTime,
                );
                if (selectedTime != null && selectedTime != reminderTime) {
                  // If time is selected
                  setState(
                    () {
                      reminderTime = selectedTime;
                    },
                  );
                }
              },
            ),

            // Note
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter note',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  note = value;
                });
              },
            ),

            // Is Important
            ListTile(
              title: const Text('Mark as Important'),
              trailing: Checkbox(
                value: isImportant,
                onChanged: (value) {
                  setState(() {
                    isImportant = value!;
                  });
                },
              ),
            ),

            // Task Color
            ListTile(
              title: const Text('Select Task Color'),
              trailing: Icon(
                Icons.circle,
                color: taskColor,
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Select Task Color'),
                      content: SingleChildScrollView(
                        child: BlockPicker(
                          pickerColor: taskColor,
                          onColorChanged: (color) {
                            setState(
                              () {
                                taskColor = color;
                              },
                            );
                          },
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),

            // Add Task Button
            ElevatedButton(
              onPressed: () {
                addTask();
              },
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}