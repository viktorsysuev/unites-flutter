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
    var res = await db.query(
        "users WHERE userId in (SELECT userId FROM participants WHERE eventId = '$eventId')");
    var participants = List<UserModel>();
    res.forEach((element) {
      participants.add(UserModel.fromJson(element));
    });
    return participants;
  }

  Future<int> idParticipant(String eventId, String userId) async {
    final db = await database;
    var res = await db.rawQuery(
        "SELECT COUNT(*) FROM participants WHERE userId = '$userId' AND  eventId = '$eventId'");
    return Sqflite.firstIntValue(res);
  }

  Future<ParticipantsModel> getParticipant(
      String eventId, String userId) async {
    final db = await database;
    var res = await db.rawQuery(
        "SELECT * FROM participants WHERE userId = '$userId' AND  eventId = '$eventId'");
    return ParticipantsModel.fromJson(res.first);
  }

  void deleteParticipant(String eventId, String userId) async {
    final db = await database;
    await db.rawQuery("DELETE FROM participants WHERE userId = '$userId' AND  eventId = '$eventId'");
  }

  Future<EventModel> getEvent(String eventId) async {
    final db = await database;
    var res =
        await db.query('events', where: 'eventId = ?', whereArgs: [eventId]);
    return EventModel.fromDB(res[0]);
  }

  Future<UserModel> getUser(String userId) async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM users WHERE userId = '$userId'");
    return UserModel.fromJson(res.first);
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