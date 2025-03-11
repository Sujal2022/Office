import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'wheel_options.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE wheel_options (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            wheel_name TEXT,
            label TEXT,
            color INTEGER
          )
        ''');
      },
    );
  }

  Future<void> insertWheelOption(String wheelName, String label, Color color) async {
    final db = await database;
    await db.insert(
      'wheel_options',
      {
        'wheel_name': wheelName,
        'label': label,
        'color': color.value,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getWheelOptions(String wheelName) async {
    final db = await database;
    return await db.query('wheel_options', where: 'wheel_name = ?', whereArgs: [wheelName]);
  }

  Future<void> deleteWheelOptions(String wheelName) async {
    final db = await database;
    await db.delete('wheel_options', where: 'wheel_name = ?', whereArgs: [wheelName]);
  }
}
