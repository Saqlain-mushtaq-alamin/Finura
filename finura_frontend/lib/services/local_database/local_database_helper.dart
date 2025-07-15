import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FinuraLocalDbHelper {
  static final FinuraLocalDbHelper _instance = FinuraLocalDbHelper._internal();
  factory FinuraLocalDbHelper() => _instance;
  FinuraLocalDbHelper._internal();

  static Database? _database;

  static var navigatorKey = GlobalKey<NavigatorState>();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final dbFilePath = join(dbPath, 'finura_local_database.db');

    // Ensure the directory exists
    print('Using database at: $dbFilePath');

    return await openDatabase(
      dbFilePath,
      version: 2,
      onCreate: _onCreate,
      //onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
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
        user_photo TEXT,
        data_status TEXT
      )
    ''');

    // 🚨 New table for expense tracking
    await db.execute('''
    CREATE TABLE expense_entry (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      date TEXT NOT NULL,
      day INTEGER NOT NULL,
      time TEXT NOT NULL,
      mood INTEGER NOT NULL CHECK(mood BETWEEN 0 AND 5),
      description TEXT,
      expense_amount REAL NOT NULL,
      synced INTEGER NOT NULL DEFAULT 0,
      FOREIGN KEY(user_id) REFERENCES user(id) ON DELETE CASCADE
    )
  ''');
    print('Database created with expense_entry table.');
  }

 // Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
   // print('⬆️ Upgrading database from $oldVersion to $newVersion...');
   // await db.execute('DROP TABLE IF EXISTS expense_entry');
    //await _onCreate(db, newVersion);
  //}

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('user');
  }

  // Optional: helper to debug tables
  Future<void> debugPrintTables() async {
    final db = await database;
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table'",
    );
    print("📋 Tables in DB: $tables");
  }

  // Optional: Dev-only reset method (call this manually if needed)
  Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();
    final dbFilePath = join(dbPath, 'finura_local_database.db');
    await deleteDatabase(dbFilePath);
    _database = null; // Clear cached instance
    print("Database has been reset.");
  }
}
