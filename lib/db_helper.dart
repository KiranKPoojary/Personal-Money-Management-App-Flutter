import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    _db ??= await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'finance.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        amount REAL,
        date TEXT,
        type TEXT  -- 'income' or 'expense'
      )
    ''');
  }

  // Insert transaction
  Future<int> insertTransaction(Map<String, dynamic> data) async {
    final dbClient = await db;
    return await dbClient.insert('transactions', data);
  }

  // Get all transactions
  Future<List<Map<String, dynamic>>> getTransactions() async {
    final dbClient = await db;
    return await dbClient.query('transactions', orderBy: 'date DESC');
  }

  // Delete transaction
  Future<int> deleteTransaction(int id) async {
    final dbClient = await db;
    return await dbClient.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }
}
