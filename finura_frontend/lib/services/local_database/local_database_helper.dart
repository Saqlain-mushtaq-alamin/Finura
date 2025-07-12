import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class FinuraLocalDbHelper {
  static final FinuraLocalDbHelper _instance = FinuraLocalDbHelper._internal();
  factory FinuraLocalDbHelper() => _instance;
  FinuraLocalDbHelper._internal();

  static Database? _database;

  static var navigatorKey = GlobalKey<NavigatorState>();
  static var sha256;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final oldDbPath = join(dbPath, 'finura_local_db.db');
    final newDbPath = join(dbPath, 'finura_local_database.db');

    // Delete old database if exists
    if (await File(oldDbPath).exists()) {
      await deleteDatabase(oldDbPath);
    }
    // Delete new database if exists (for recreation)
    if (await File(newDbPath).exists()) {
      await deleteDatabase(newDbPath);
    }

    print('Database file path: $newDbPath');

    return await openDatabase(newDbPath, version: 1, onCreate: _onCreate);
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
        user_photo TEXT,
        data_status TEXT
      )
    ''');
  }
    // Method to fetch all users
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('user');  // Fetch all users from 'user' table
  }
}
