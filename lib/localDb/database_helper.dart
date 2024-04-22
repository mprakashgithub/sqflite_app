import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'crud.db');

    // Open/Create the database at a given path
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create table
    await db.execute(
        "CREATE TABLE Item(id INTEGER PRIMARY KEY, name TEXT, description TEXT, createdAt TEXT, image TEXT)"); //INTEGER NOT NULL DEFAULT (cast(strftime('%s','now') as int))
  }

  Future<int> addItem(Map<String, dynamic> item) async {
    var dbClient = await db;
    int res = await dbClient.insert("Item", item);
    return res;
  }

  Future<List<Map<String, dynamic>>> getItems() async {
    var dbClient = await db;

    List<Map<String, dynamic>> res = await dbClient.query("Item");
    return res;
  }

  Future<int> updateItem(Map<String, dynamic> item) async {
    var dbClient = await db;
    item['createdAt'] = DateTime.now().toString();
    item['image'] = "image path";
    int res = await dbClient
        .update("Item", item, where: "id = ?", whereArgs: [item['id']]);
    return res;
  }

  Future<int> deleteItem(int id) async {
    var dbClient = await db;
    int res = await dbClient.delete("Item", where: "id = ?", whereArgs: [id]);
    return res;
  }
}
