import 'dart:typed_data';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  static const String usersTable = 'users';
  static const String tasksTable = 'tasks';

  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();

    return _database!;
  }

  static Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'my_database.db');

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  static void _createDB(Database db, int version) async {
    // Creating users table
    await db.execute(''' 
      CREATE TABLE $usersTable (
        UserId INTEGER PRIMARY KEY,
        Name TEXT,
        Email TEXT,
        DOB TEXT,
        PhoneNumber TEXT
      ) 
  ''');

    // Creating Tasks Table linked individually with each user
    await db.execute('''
      CREATE TABLE $tasksTable (
        TaskId INTEGER PRIMARY KEY,
        UserId INTEGER,
        TaskName TEXT,
        DueDate TEXT,
        ReminderTime TEXT,
        Color TEXT,
        Image BLOB,
        Audio BLOB,
        IsImportant INTEGER,
        Note TEXT,
        FOREIGN KEY (UserId) REFERENCES $usersTable(UserId)
      )
  ''');
  }

  // Insert user
  static Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert(usersTable, user.toMap());
  }

  // Get all users
  static Future<List<User>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(usersTable);
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  // Insert task
  static Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert(tasksTable, task.toMap());
  }

  // Get tasks by user ID
  static Future<List<Task>> getTasksByUserId(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(tasksTable, where: 'UserId = ?', whereArgs: [userId]);
    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }
}

class User {
  int? userId;
  String name;
  String email;
  String dob;
  String phoneNumber;

  User({
    this.userId,
    required this.name,
    required this.email,
    required this.dob,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'UserId': userId,
      'Name': name,
      'Email': email,
      'DOB': dob,
      'PhoneNumber': phoneNumber,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['UserId'],
      name: map['Name'],
      email: map['Email'],
      dob: map['DOB'],
      phoneNumber: map['PhoneNumber'],
    );
  }
}

class Task {
  int? taskId;
  int? userId;
  String taskName;
  String dueDate;
  String reminderTime;
  String color;
  Uint8List image;
  Uint8List audio;
  bool isImportant;
  String note;
  bool isCompleted;

  Task({
    this.taskId,
    this.userId,
    required this.taskName,
    required this.dueDate,
    required this.reminderTime,
    required this.color,
    required this.image,
    required this.audio,
    required this.isImportant,
    required this.note,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'TaskId': taskId,
      'UserId': userId,
      'TaskName': taskName,
      'DueDate': dueDate,
      'ReminderTime': reminderTime,
      'Color': color,
      'Image': image,
      'Audio': audio,
      'IsImportant':
          isImportant ? 1 : 0, // Converting boolean to integer for SQLite
      'Note': note,
      'IsCompleted': isCompleted ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      taskId: map['TaskId'],
      userId: map['UserId'],
      taskName: map['TaskName'],
      dueDate: map['DueDate'],
      reminderTime: map['ReminderTime'],
      color: map['Color'],
      image: map['Image'],
      audio: map['Audio'],
      isImportant: map['IsImportant'] == 1, // Converting integer to boolean
      note: map['Note'],
      isCompleted: map['IsCompleted'] == 1,
    );
  }
}
