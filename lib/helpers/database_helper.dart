import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<void> _createTables(Database db) async {
    await db.execute(
      '''CREATE TABLE exams(
        id INTEGER PRIMARY KEY,
        name TEXT,
        answerKey TEXT,
        createdAt TEXT,
        quarterName TEXT,
        subjectName TEXT,
        responses INTEGER
      )''',
    );

    await db.execute(
      '''CREATE TABLE responses(
        id INTEGER PRIMARY KEY,
        examId INTEGER,
        userId INTEGER,
        studentNumber TEXT UNIQUE,
        imagePath TEXT,
        detected INTEGER,
        score INTEGER,
        answer TEXT,
        createdAt TEXT,
        name TEXT,
        email TEXT,
        FOREIGN KEY (examId) REFERENCES exams (id) ON DELETE CASCADE
      )''',
    );

    await db.execute(
      '''CREATE TABLE classes(
        id INTEGER PRIMARY KEY,
        name TEXT,
        description TEXT
      )''',
    );

    await db.execute(
      '''CREATE TABLE sy(
        id INTEGER PRIMARY KEY,
        name TEXT,
        startDate TEXT,
        endDate TEXT
      )''',
    );

    await db.execute(
      '''CREATE TABLE sections(
        id INTEGER PRIMARY KEY,
        name TEXT
      )''',
    );

    await db.execute(
      '''CREATE TABLE students(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        student_number TEXT,
        name TEXT
      )''',
    );
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'database.db');
    return await openDatabase(
      path,
      version: 41,
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Drop existing tables and recreate them
        print("NEW VERSION");
        await db.execute('DROP TABLE IF EXISTS responses');
        await db.execute('DROP TABLE IF EXISTS exams');
        await db.execute('DROP TABLE IF EXISTS classes');
        await db.execute('DROP TABLE IF EXISTS sy');
        await db.execute('DROP TABLE IF EXISTS sections');
        await db.execute('DROP TABLE IF EXISTS students');
        await _createTables(db);
      },
    );
  }
}
