import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:pharmer/crop_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database; //Actual database object
  String cropsTable = 'crop_table'; //crop table name
  String cropName = 'name'; //Column names
  String cropIconPath = 'iconPath';
  String cropSubText = 'subText';
  String airTemp = 'airTemp';
  String airHumidity = 'airHumidity';
  String soilMoisture = 'soilMoisture';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async => _database ??= await initDatabase();

  Future<Database> initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'crops.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future _createDb(Database db, int version) async {
    await db.execute('''
 CREATE TABLE $cropsTable ( 
  $cropName Text primary key, 
  $cropIconPath Text not null,
  $cropSubText Text not null,
  $airTemp float not null,
  $airHumidity float not null,
  $soilMoisture float not null
  )
''');
  }

  //Retrieve
  Future<List<CropModel>> crops() async {
    // Get a reference to the database.
    final Database db = await database;
    // Query the table for all The crops.
    final List<Map<String, dynamic>> maps = await db.query(cropsTable);

    // Convert the List<Map<String, dynamic> into a List<CropModel>.
    return List.generate(maps.length, (i) {
      return CropModel(
        name: maps[i][cropName],
        subText: maps[i][cropSubText],
        iconPath: maps[i][cropIconPath],
        airTemp: maps[i][airTemp],
        airHumidity: maps[i][airHumidity],
        soilMoisture: maps[i][soilMoisture],
      );
    });
  }

  //Insert
  Future<void> insertCropToDB(CropModel crop) async {
    final Database db = await instance.database;
    await db.insert(
      cropsTable,
      crop.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

//Delete
  Future<void> deleteCropFromDB(String name) async {
    final db = await instance.database;
    await db.delete(
      cropsTable,
      where: "name = ?",
      whereArgs: [name],
    );
  }
}
