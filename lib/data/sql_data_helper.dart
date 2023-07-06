import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:water_alarm/domain/model/user_model.dart';

class DatabaseHelper {
  final _databaseName = "my_database.db";
  static const _databaseVersion = 1;

  final table = 'users';

  final columnId = 'id';
  final columnName = 'name';
  final columnWeight = 'weight';
  final columnHeight = 'height';
  final consumptionAmount = 'consumption_amount';
  final consumptionDate = 'consumption_date';
  final consumptionTarget = 'consumption_target';
  final consumptionsTable = 'consumptions';
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE IF NOT EXISTS $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName TEXT,
            $columnWeight REAL,
            $columnHeight REAL,
            $consumptionTarget REAL
          )
          ''');
    await db.execute('''
       CREATE TABLE IF NOT EXISTS consumptions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            $consumptionAmount REAL,
            $consumptionDate TEXT,
            FOREIGN KEY (id) REFERENCES $table($columnId)
          )
          ''');
  }

  Future<int> insertConsumption(
      double consumptionAmount, String consumptionDate) async {
    final db = await database;
    await _onCreate(db, 1);
    int id = await db.insert('consumptions', {
      columnId: 0,
      'consumptionAmount': consumptionAmount,
      'consumptionDate': consumptionDate,
    });
    return id;
  }

  Future<List<Map<String, dynamic>>> getTodayConsumption() async {
    final db = await database;
    var today = DateTime.now();
    var todayString = today.toString().substring(0, 10);
    final List<Map<String, dynamic>> maps = await db.query('consumptions',
        where: '$consumptionDate >= ?', whereArgs: [todayString]);
    return maps;
  }

  //get weekly consumption
  Future<List<Map<String, dynamic>>> getWeeklyConsumption() async {
    final db = await database;
    var today = DateTime.now();
    var lastWeek = today.subtract(const Duration(days: 7));
    var lastWeekString = lastWeek.toString().substring(0, 10);
    final List<Map<String, dynamic>> maps = await db.query('consumptions',
        where: '$consumptionDate >= ?', whereArgs: [lastWeekString]);
    return maps;
  }

  //get monthly consumption
  Future<List<Map<String, dynamic>>> getMonthlyConsumption() async {
    final db = await database;
    var today = DateTime.now();
    var lastMonth = today.subtract(const Duration(days: 30));
    var lastMonthString = lastMonth.toString().substring(0, 10);
    final List<Map<String, dynamic>> maps = await db.query('consumptions',
        where: '$consumptionDate >= ?', whereArgs: [lastMonthString]);
    return maps;
  }

  setTodayConsumption(int consumption) async {
    final db = await database;
    var today = DateTime.now();
    var todayString = today.toString().substring(0, 16);
    await db.insert(
      'consumptions',
      {consumptionDate: todayString, consumptionAmount: consumption},
    );
  }

  Future<int> getConsumptionCount() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('consumptions');
    return maps.length;
  }

  Future<bool> insertUser(UserModel user) async {
    try {
      final db = await database;
      await _onCreate(db, 1);
      await db.insert(
        table,
        user.toJson(),
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Future<void> deleteDatabaseFile() async {
  //   final dbPath = await getDatabasesPath();
  //   final path = join(dbPath, _databaseName);
  //   File databaseFile = File(dbPath);
  //   await databaseFile.delete();
  // }

  Future<void> deleteUser() async {
    try {
      final db = await database;
      await db.delete(table);
      await db.delete(consumptionsTable);
      await getUsers();
      // db.close();
    } catch (e) {
      print(e);
    }
  }

  Future<List<UserModel>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return UserModel(
          id: maps[i][columnId],
          name: maps[i][columnName],
          weight: maps[i][columnWeight],
          height: maps[i][columnHeight],
          consumptionTarget: maps[i][consumptionTarget]);
    });
  }
}
