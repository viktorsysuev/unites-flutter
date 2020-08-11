
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unites_flutter/src/models/NotificationState.dart';


class NotificationModel {
  String notificationId;
  String eventId;
  NotificationState state;
  DateTime createdAt;
  String initiatorId;

  NotificationModel(
      {this.notificationId, this.eventId, this.createdAt, this.initiatorId, this.state});

  factory NotificationModel.fromJson(Map<dynamic, dynamic> json) =>
      _NotificationModelFromJson(json);


  Map<String, dynamic> toMap() => _NotificationModelToMap(this);


  factory NotificationModel.fromDB(Map<String, dynamic> table) {
    return NotificationModel(
        notificationId: table['notificationId'],
        initiatorId: table['initiatorId'],
        createdAt: DateTime.parse(table['createdAt']),
        eventId: table['eventId'],
        state: NotificationState.values.firstWhere((e) => e.toString() == table['state'], orElse: () => null));
  }

  Map<String, dynamic> toJson() => _NotificationModelToJson(this);
}

NotificationModel _NotificationModelFromJson(Map<dynamic, dynamic> json) {

  return NotificationModel(
    notificationId: json['notificationId'] as String,
    eventId: json['eventId'] as String,
    createdAt: (json['createdAt'] as Timestamp).toDate(),
    state: NotificationState.values.firstWhere((e) => e.toString() == json['state'], orElse: () => null),
    initiatorId: json['initiatorId'] as String,
  );
}

Map<String, dynamic> _NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'notificationId': instance.notificationId,
      'eventId': instance.eventId,
      'state': instance.state.toString(),
      'createdAt': instance.createdAt,
      'initiatorId': instance.initiatorId,
    };

Map<String, dynamic> _NotificationModelToMap(NotificationModel instance) => <String, dynamic>{
  'notificationId': instance.notificationId,
  'eventId': instance.eventId,
  'state': instance.state.toString(),
  'createdAt': instance.createdAt.toIso8601String(),
  'initiatorId': instance.initiatorId,
};