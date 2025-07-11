import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FinuraLocalDbHelper {
  static final FinuraLocalDbHelper _instance = FinuraLocalDbHelper._internal();
  factory FinuraLocalDbHelper() => _instance;
  FinuraLocalDbHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'finura_local_db.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pin_hash TEXT NOT NULL,
        first_name TEXT NOT NULL,
        last_name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        occupation TEXT,
        sex TEXT CHECK(sex IN ('male', 'female', 'other')) NOT NULL,
        created_at TEXT NOT NULL,
        usger_photo BLOB,
        data_status TEXT
      )
    ''');
  }

 

  // Add more CRUD methods as needed
}
