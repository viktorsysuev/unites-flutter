import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:unites_flutter/src/database/CreateTable.dart';
import 'package:unites_flutter/src/models/EventModel.dart';
import 'package:unites_flutter/src/models/ParticipantsModel.dart';
import 'package:unites_flutter/src/models/UserModel.dart';

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
      await createTables.forEach((name, text) async => await db.execute(text));
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

  Future<List<UserModel>> getEventParticipants(String eventId) async {
    final db = await database;
    var res = await db.query("users WHERE userId in (SELECT userId FROM participants WHERE eventId = '$eventId')");
    var participants = List<UserModel>();
    res.forEach((element) {
      participants.add(UserModel.fromJson(element));
    });
    return participants;
  }

  Future<EventModel> getEvent(String eventId) async {
    final db = await database;
    var res =
        await db.query('events', where: 'eventId = ?', whereArgs: [eventId]);
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
