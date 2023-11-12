import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

class DatabaseAlreadyOpenException implements Exception {}

class UnableToGetDocumentDirectory implements Exception {}

class DatabaseIsNotOpen implements Exception {}

class CouldNotDeleteUser implements Exception {}

class TaskService {
  Database? _db;

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: '$emailColumn = ?',
      whereArgs: [email.toLowerCase()],
    );
    if(deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else
      return db;
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createUsersTable);

      await db.execute(createTasksTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirectory();
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  DatabaseUser({
    required this.id,
    required this.email,
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'DatabaseUser(id: $id, email: $email)';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseTask {
  final int id;
  final int userId;
  final String taskName;
  final String dueDate;
  final String reminderTime;
  final String color;
  final Uint8List image;
  final Uint8List audio;
  final bool isImportant;
  final String note;

  DatabaseTask({
    required this.id,
    required this.userId,
    required this.taskName,
    required this.dueDate,
    required this.reminderTime,
    required this.color,
    required this.image,
    required this.audio,
    required this.isImportant,
    required this.note,
  });

  DatabaseTask.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        taskName = map[taskNameColumn] as String,
        dueDate = map[dueDateColumn] as String,
        reminderTime = map[reminderTimeColumn] as String,
        color = map[colorColumn] as String,
        image = map[imageColumn] as Uint8List,
        audio = map[audioColumn] as Uint8List,
        isImportant = map[isImportantColumn] == 1,
        note = map[noteColumn] as String;

  @override
  String toString() {
    return 'DatabaseTask(id: $id, userId: $userId, taskName: $taskName, dueDate: $dueDate, reminderTime: $reminderTime, color: $color, image: $image, audio: $audio, isImportant: $isImportant, note: $note)';
  }

  @override
  bool operator ==(covariant DatabaseTask other) {
    return id == other.id &&
        userId == other.userId &&
        taskName == other.taskName &&
        dueDate == other.dueDate &&
        reminderTime == other.reminderTime &&
        color == other.color &&
        listEquals(image, other.image) &&
        listEquals(audio, other.audio) &&
        isImportant == other.isImportant &&
        note == other.note;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        taskName.hashCode ^
        dueDate.hashCode ^
        reminderTime.hashCode ^
        color.hashCode ^
        image.hashCode ^
        audio.hashCode ^
        isImportant.hashCode ^
        note.hashCode;
  }
}

const dbName = 'space_lab_tasks.db';
const userTable = 'User';
const taskTable = 'Task';

const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'UserId';
const taskNameColumn = 'TaskName';
const dueDateColumn = 'DueDate';
const reminderTimeColumn = 'ReminderTime';
const colorColumn = 'Color';
const imageColumn = 'Image';
const audioColumn = 'Audio';
const isImportantColumn = 'IsImportant';
const noteColumn = 'Note';

const createUsersTable = '''
  CREATE TABLE IF NOT EXIST $userTable (
    $idColumn INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    $emailColumn TEXT NOT NULL UNIQUE
  )
''';

const createTasksTable = '''
  CREATE TABLE IF NOT EXIST $taskTable (
    $idColumn INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    $userIdColumn INTEGER NOT NULL,
    $taskNameColumn TEXT NOT NULL,
    $dueDateColumn TEXT NOT NULL,
    $reminderTimeColumn TEXT NOT NULL,
    $colorColumn TEXT NOT NULL,
    $imageColumn BLOB NOT NULL,
    $audioColumn BLOB NOT NULL,
    $isImportantColumn INTEGER NOT NULL,
    $noteColumn TEXT NOT NULL,
    FOREIGN KEY ($userIdColumn) REFERENCES $userTable($idColumn)
  )
''';
