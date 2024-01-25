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

  Future<List<Plant>> getPlants() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('plants');
    return List.generate(maps.length, (index) {
      return Plant.fromMap(maps[index]);
    });
  }

  Future<void> insertTestPlants() async {
    List<Plant> testPlants = [
      Plant(
        name: 'Jasmine',
        type: 'Flower',
        description: 'Best Flower :)',
        imgURL:
            'https://hgtvhome.sndimg.com/content/dam/images/hgtv/fullset/2020/4/7/0/shutterstock_kengrx19-1006846339.jpg.rend.hgtvcom.1280.1280.suffix/1586284288104.jpeg',
        actualName: 'jasmine',
        datePlanted: DateTime(2023, 5, 15),
      ),
      Plant(
        name: 'Sunflower',
        type: 'Flowering Plant',
        description:
            'Sunflowers are tall, yellow flowers that bloom in the summer.',
        imgURL: 'https://www.bolster.eu/media/images/5450_dbweb.jpg',
        actualName: 'sunflower',
        datePlanted: DateTime(2023, 6, 1),
      ),
      Plant(
        name: 'Snake Plant',
        type: 'Indoor Plant',
        description:
            'Snake plants, or Sansevieria, are popular indoor plants known for their hardiness.',
        imgURL: 'https://www.bolster.eu/media/images/5450_dbweb.jpg',
        actualName: 'Sansevieria',
        datePlanted: DateTime(2023, 7, 10),
      ),
    ];

    for (var plant in testPlants) {
      await insertPlant(plant);
    }
  }
}
