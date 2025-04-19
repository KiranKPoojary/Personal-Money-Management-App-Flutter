import 'package:path/path.dart';
import '../models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import '../models/transaction.dart';

class TransactionDB {
  static final TransactionDB instance = TransactionDB._init();

  static Database? _database;

  TransactionDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('transactions.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const doubleType = 'REAL NOT NULL';

    await db.execute('''
      CREATE TABLE transactions (
        id $idType,
        title $textType,
        amount $doubleType,
        date $textType,
        type $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
     ''');

    await db.insert('users', {
      'username': 'KK',
      'password': '123',
    });


  }
  //User
  Future<void> insertUser(UserModel user) async {
    final db = await instance.database;
    await db.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<UserModel?> getUser(String username, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }

  Future<List<String>> getAllUsernames() async {
    final db = await instance.database;
    final result = await db.query('users', columns: ['username']);
    return result.map((row) => row['username'] as String).toList();
  }


  //Transaction
  Future<TransactionModel> create(TransactionModel txn) async {
    final db = await instance.database;
    final id = await db.insert('transactions', txn.toMap());
    return txn..id = id;
  }

  Future<List<TransactionModel>> readAllTransactions() async {
    final db = await instance.database;
    final result = await db.query('transactions', orderBy: 'date DESC');

    return result.map((map) => TransactionModel.fromMap(map)).toList();
  }



  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
