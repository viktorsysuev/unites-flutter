import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:unites_flutter/src/database/create_table.dart';
import 'package:unites_flutter/src/models/comment_model.dart';
import 'package:unites_flutter/src/models/comment_with_user.dart';
import 'package:unites_flutter/src/models/event_model.dart';
import 'package:unites_flutter/src/models/event_with_members.dart';
import 'package:unites_flutter/src/models/event_with_participants.dart';
import 'package:unites_flutter/src/models/notification_model.dart';
import 'package:unites_flutter/src/models/participants_model.dart';
import 'package:unites_flutter/src/models/user_model.dart';

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
    var dbDirectory = await getDatabasesPath();
    var path = join(dbDirectory, 'UnitesDatabase.db');
    return await openDatabase(path, version: 4, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await createTables.forEach((name, text) async => await db.execute(text));
    });
  }

  Future<List<EventModel>> getAllEvents() async {
    final db = await database;
    var res = await db.query('events');
    var events = <EventModel>[];
    res.forEach((element) {
      events.add(EventModel.fromDB(element));
    });
    return events;
  }

  void deleteEvent(String eventId) async {
    final db = await database;
    await db.rawQuery("DELETE FROM events WHERE eventId = '$eventId'");
  }

  Future<List<UserModel>> getEventParticipants(String eventId) async {
    final db = await database;
    var res = await db.query(
        "users WHERE userId in (SELECT userId FROM participants WHERE eventId = '$eventId')");
    var participants = <UserModel>[];
    res.forEach((element) {
      participants.add(UserModel.fromJson(element));
    });
    return participants;
  }

  Future<List<CommentWithUser>> getEventComments(String eventId) async {
    final db = await database;
    var res = await db.query("comments_with_users WHERE eventId = '$eventId' ORDER BY createdAt ASC");
    var comments = <CommentWithUser>[];
    res.forEach((element) {
      comments.add(CommentWithUser.fromDB(element));
    });
    return comments;
  }

  Future<List<NotificationModel>> getUserNotifications() async {
    final db = await database;
    var res = await db.query('notifications ORDER BY createdAt DESC');
    var notifications = <NotificationModel>[];
    res.forEach((element) {
      notifications.add(NotificationModel.fromDB(element));
    });
    return notifications;
  }

  Future<int> getUnreadCountNotifications() async {
    final db = await database;
    var res = await db.rawQuery('SELECT COUNT(*) FROM notifications WHERE seenByMe = 0');

    return res.first.values.first;
  }

  void setNotificationsAsRead() async {
    final db = await database;
    await db.rawQuery('UPDATE notifications SET seenByMe = 1');
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
    await db.rawQuery(
        "DELETE FROM participants WHERE userId = '$userId' AND  eventId = '$eventId'");
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

  Future<List<UserModel>> getContacts(String userId) async {
    final db = await database;
    var contacts = <UserModel>{};
    var res = await db.rawQuery(
        "SELECT * FROM users WHERE userId in (SELECT userId FROM participants WHERE eventId in (SELECT eventId FROM participants WHERE userId = '$userId') AND NOT userId = '$userId')");
    res.forEach((element) {
      contacts.add(UserModel.fromJson(element));
    });
    return contacts.toList();
  }

  // Нужно найти другое решение, список формируется долго
  Future<List<EventWithParticipants>> getMyEvents(String currentUserId) async {
    var result = <EventWithParticipants>[];
    final db = await database;
    var participants = await db.rawQuery('SELECT * FROM participants');
    var res = await db.rawQuery("SELECT * FROM events WHERE eventId in (SELECT eventId FROM participants WHERE userId = '$currentUserId')");
    await Future.forEach(res, (element) async {
      var newEventWithParticipants = EventWithParticipants();
      var event = EventModel.fromDB(element);
      newEventWithParticipants.eventModel = event;
      var users = <ParticipantsModel>{};

      participants.forEach((element) {
        var user = ParticipantsModel.fromJson(element);
        if(user.eventId == event.id){
          users.add(user);
        }
      });
      newEventWithParticipants.participants = users.toList();
      result.add(newEventWithParticipants);
    });
    return result;
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
