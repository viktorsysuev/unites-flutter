
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unites_flutter/src/models/NotificationState.dart';


class NotificationModel {
  String notificationId;
  String eventId;
  String eventName;
  NotificationState state;
  DateTime createdAt;
  String initiatorId;
  String initiatorName;
  bool seenByMe;

  NotificationModel(
      {this.notificationId, this.eventId, this.createdAt, this.initiatorId, this.state, this.eventName, this.initiatorName, this.seenByMe});

  factory NotificationModel.fromJson(Map<dynamic, dynamic> json) =>
      _NotificationModelFromJson(json);


  Map<String, dynamic> toMap() => _NotificationModelToMap(this);


  factory NotificationModel.fromDB(Map<String, dynamic> table) {
    return NotificationModel(
        notificationId: table['notificationId'],
        initiatorId: table['initiatorId'],
        initiatorName: table['initiatorName'],
        createdAt: DateTime.parse(table['createdAt']),
        eventId: table['eventId'],
        eventName: table['eventName'],
        seenByMe: table['seenByMen'] == 1 ? true : false,
        state: NotificationState.values.firstWhere((e) => e.toString() == 'NotificationState.' + table['state'], orElse: () => null));
  }

  Map<String, dynamic> toJson() => _NotificationModelToJson(this);
}

NotificationModel _NotificationModelFromJson(Map<dynamic, dynamic> json) {

  return NotificationModel(
    notificationId: json['notificationId'] as String,
    eventId: json['eventId'] as String,
    eventName: json['eventName'] as String,
    createdAt: (json['createdAt'] as Timestamp).toDate(),
    state: NotificationState.values.firstWhere((e) => e.toString() == 'NotificationState.' + json['state'], orElse: () => null),
    initiatorId: json['initiatorId'] as String,
    initiatorName: json['initiatorName'] as String,
    seenByMe: json['seenByMe'] as bool,
  );
}

Map<String, dynamic> _NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'notificationId': instance.notificationId,
      'eventId': instance.eventId,
      'eventName': instance.eventName,
      'state': instance.state.toString().split('.').last,
      'createdAt': instance.createdAt,
      'initiatorId': instance.initiatorId,
      'initiatorName': instance.initiatorName,
      'seenByMe': instance.seenByMe,
    };

Map<String, dynamic> _NotificationModelToMap(NotificationModel instance) => <String, dynamic>{
  'notificationId': instance.notificationId,
  'eventId': instance.eventId,
  'eventName': instance.eventName,
  'state': instance.state.toString().split('.').last,
  'createdAt': instance.createdAt.toIso8601String(),
  'initiatorId': instance.initiatorId,
  'seenByMe': instance.seenByMe == true ? 1 : 0,
  'initiatorName': instance.initiatorName,
};