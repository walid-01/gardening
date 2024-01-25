import 'dart:io';
import 'package:gardening_life/models/plant.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class PlantDatabaseHelper {
  static const _databaseName = 'plants.db';
  static const _databaseVersion = 1;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE plants (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        description TEXT NOT NULL,
        imgURL TEXT NOT NULL,
        actualName TEXT NOT NULL,
        datePlanted TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertPlant(Plant plant) async {
    Database db = await database;
    return await db.insert('plants', plant.toMap());
  }

  Future<int> updatePlant(Plant plant) async {
    Database db = await database;
    return await db.update(
      'plants',
      plant.toMap(),
      where: 'id = ?',
      whereArgs: [plant.id],
    );
  }

  Future<List<Plant>> getPlants() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('plants');
    return List.generate(maps.length, (index) {
      return Plant.fromMap(maps[index]);
    });
  }

  Future<void> insertTestPlants() async {
    // Your existing code...
  }
}
