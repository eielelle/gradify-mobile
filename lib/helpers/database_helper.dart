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
        studentNumber TEXT,
        imagePath TEXT,
        detected INTEGER,
        score INTEGER,
        answer TEXT,
        createdAt TEXT,
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
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'database.db');
    return await openDatabase(
      path,
      version: 18,
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Drop existing tables and recreate them
        await db.execute('DROP TABLE IF EXISTS responses');
        await db.execute('DROP TABLE IF EXISTS exams');
        await db.execute('DROP TABLE IF EXISTS classes');
        await _createTables(db);
      },
    );
  }
}
