
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:space_lab_tasks/Database/database_provider.dart';

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
  File? imageFile;
  File? audioFile;

  void addTask() async {
    // // Convert image and audio files to bytes
    // Uint8List imageBytes = imageFile != null ? await imageFile!.readAsBytes() : Uint8List(0);
    // Uint8List audioBytes = audioFile != null ? await audioFile!.readAsBytes() : Uint8List(0);

    // Task newTask = Task(
    //   taskName: taskNameController.text,
    //   dueDate: dueDate.toIso8601String(),
    //   reminderTime: reminderTime.format(context),
    //   isImportant: isImportant,
    //   note: note,
    //   image: imageBytes,
    //   audio: audioBytes, 
    //   color: taskColor.toString(),
    //   isCompleted: false,
    // );

    // // Insert the task into the database
    // await DatabaseProvider.insertTask(newTask);

    // Close this screen and return to the previous TodoListPage
    Navigator.pop(context);
  }

  // Select image from gallery
  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  // Select audio from gallery
  Future<void> _pickAudio() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        audioFile = File(result.files.single.path!);
      });
    }
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

            ListTile(
              title: Text('Attach Image'),
              trailing: IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: _pickImage,
              ),
            ),
            
            ListTile(
              title: Text('Attach Audio'),
              trailing: IconButton(
                icon: const Icon(Icons.audiotrack),
                onPressed: _pickAudio,
              ),
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
