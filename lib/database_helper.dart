import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'model/modelFavorite.dart';

class DatabaseHelper {
  static final _dbName = "myDatabase.db";
  static final _dbVersion = 1;
  static final _tableName = "favoriteChannels";

  //static final columnId = '_id';
  static final columnChannelId = '_channelId';
  static final columnChannelName = '_channelName';
  static final columnChannelType = '_channelType';
  static final columnChannelCategory = '_channelCategory';
  static final columnChannelImage = '_channelImage';
  static final columnChannelUrl = '_channelUrl';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initiateDatabase();
    return _database;
  }

  _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  _onCreate(Database db, int version) {
    db.execute('''
      CREATE TABLE $_tableName (
      $columnChannelCategory TEXT NOT NULL,
      $columnChannelType TEXT NOT NULL,
      $columnChannelId TEXT PRIMARY KEY,
      $columnChannelName TEXT NOT NULL,
      $columnChannelImage TEXT NOT NULL,
      $columnChannelUrl TEXT NOT NULL)
       ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableName, row,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query(_tableName);
  }

  Future<List<Favorite>> retrieveFavorite() async {
    // Get a reference to the database.
    final Database db = await database;

    final List<Map> maps = await db.query(_tableName);

    return List.generate(maps.length, (i) {
      return Favorite(
        channelId: maps[i][columnChannelId],
        channelName: maps[i][columnChannelName],
        channelCategory: maps[i][columnChannelCategory],
        channelImage: maps[i][columnChannelImage],
        channelType: maps[i][columnChannelType],
        channelUrl: maps[i][columnChannelUrl],
      );
    });
  }
}
