import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:unites_flutter/src/models/EventModel.dart';

class DatabaseProvider {
  DatabaseProvider._();

  static final db = DatabaseProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();
    var path = join(documentsDirectory.path, 'UnitesDatabase.db');
    return await openDatabase(path, version: 4, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE events ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "eventId TEXT,"
          "name TEXT,"
          "description TEXT,"
          "company TEXT,"
          "phoneNumber TEXT,"
          "email TEXT,"
          "address TEXT,"
          "coordinates TEXT,"
          "start start,"
          "end TEXT,"
          "UNIQUE(eventId)"
          ")");
    });
  }

  Future<List<EventModel>> getAllEvents() async {
    final db = await database;
    var res = await db.query("events");
    var events = List<EventModel>();
    res.forEach((element) {
      events.add(EventModel.fromDB(element));
    });
    return events;
  }

  Future<EventModel> getEvent(String eventId) async {
    final db = await database;
    var res = await db.query('events', where: 'eventId = ?', whereArgs: [eventId]);
    return EventModel.fromDB(res[0]);
  }

  Future<int> insertData(String nameTable, Map<String, dynamic> data) async {
    var dbClient = await database;
    var id = await dbClient.insert(
      nameTable,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }
}
