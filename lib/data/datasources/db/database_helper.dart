import 'dart:async';

import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../../common/encrypt.dart';
import '../../models/data_table.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    if (_database == null) {
      _database = await _initDb();
    }
    return _database;
  }

  static const String _tblUsers = 'users';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/dummyapi.db';

    print(databasePath);

    var db = await openDatabase(
      databasePath,
      version: 1,
      onCreate: _onCreate,
      password:  encrypt('Dummyapi'),
    );
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_tblUsers (
        no INTEGER PRIMARY KEY,
        id TEXT,
        title TEXT,
        firstName TEXT,
        lastName TEXT,
        picture TEXT
      );
    ''');
  }

  Future<int> insert(DataTable value) async {
    final db = await database;
    return await db!.insert(_tblUsers, value.toJson());
  }

  Future<int> edit(DataTable value) async {
    final db = await database;

    // row to update
    Map<String, dynamic> row = {
      "title" : value.title,
      "firstName"  : value.firstName,
      "lastName"  : value.lastName,
      "picture"  : value.picture,
    };

    return await db!.update(
      _tblUsers,
      row,
      where: 'id = ?',
      whereArgs: [value.id],
    );
  }

  Future<int> remove(DataTable value) async {
    final db = await database;
    return await db!.delete(
      _tblUsers,
      where: 'id = ?',
      whereArgs: [value.id],
    );
  }

  Future<Map<String, dynamic>?> getDataById(String id) async {
    final db = await database;
    final results = await db!.query(
      _tblUsers,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getListData() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(_tblUsers);

    return results;
  }
}
