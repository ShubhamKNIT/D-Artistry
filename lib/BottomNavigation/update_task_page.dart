import 'package:space_lab_tasks/Firestore/firestore_todo_crud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:space_lab_tasks/BottomNavigation/todo_list_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class UpdateTaskPage extends StatefulWidget {
  final Task? task;
  final String docID;

  
  UpdateTaskPage({Key? key, required this.task, required this.docID});

  @override
  State<UpdateTaskPage> createState() => _UpdateTaskPageState();
}

class _UpdateTaskPageState extends State<UpdateTaskPage> {

  // get instance of FirestoreTodoCRUD class
  final FirestoreTodoCRUD firestoreTodoCRUD = FirestoreTodoCRUD();


  TextEditingController taskNameController = TextEditingController(); // https://api.flutter.dev/flutter/widgets/TextEditingController-class.html
  DateTime dueDate = DateTime.now(); // https://api.flutter.dev/flutter/dart-core/DateTime-class.html
  TimeOfDay reminderTime = TimeOfDay.now(); // https://api.flutter.dev/flutter/material/TimeOfDay-class.html
  bool isImportant = false;
  TextEditingController noteController = TextEditingController();
  Color taskColor = Colors.blue; // Default color and will be changed by user
  File? imageFile;
  File? audioFile;
  String? docID;

  // Initialize state with current task data
  @override
  void initState() {
    super.initState();
    taskNameController.text = widget.task?.title ?? '';
    dueDate = widget.task?.dueDate ?? DateTime.now();
    reminderTime = widget.task?.reminderTime ?? TimeOfDay.now();
    isImportant = widget.task?.isImportant ?? false;
    noteController.text = widget.task?.note ?? ''; // Set note to the current task's note or an empty string
    taskColor = widget.task?.taskColor ?? Colors.blue;
    imageFile = widget.task?.image;
    audioFile = widget.task?.audio;
  }

  // Select image from gallery
  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path); // store image file uri
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
        audioFile = File(result.files.single.path!); // store audio file uri
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Task Name
              SizedBox(height: 16.0),
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
                controller: noteController,
                decoration: InputDecoration(
                  labelText: 'Enter note',
                  border: OutlineInputBorder(),
                ),
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
      
      
              // attach image
              ListTile(
                title: Text('Attach Image'),
                trailing: IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: _pickImage,
                ),
              ),
              
              // attach audio
              ListTile(
                title: Text('Attach Audio'),
                trailing: IconButton(
                  icon: const Icon(Icons.audiotrack),
                  onPressed: _pickAudio,
                ),
              ),
      
              // Update Task Button
              ElevatedButton(
                onPressed: () {
                  firestoreTodoCRUD.updateTask(
                    widget.docID,
                    taskNameController.text,
                    dueDate,
                    reminderTime,
                    noteController.text,
                    isImportant,
                    taskColor,
                    imageFile,
                    audioFile,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Task updated successfully!'),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Navigator.pop(context); // Return to previous page (TodoListPage)
                },

                child: Text('Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
