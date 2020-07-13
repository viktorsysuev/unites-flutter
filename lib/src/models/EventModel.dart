import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String id;
  String name;
  String description;

  DocumentReference reference;

  EventModel({this.id, this.name, this.description});

  factory EventModel.fromJson(Map<dynamic, dynamic> json) =>
      _EventModelFromJson(json);

  Map<String, dynamic> toJson() => _EventModelToJson(this);

  @override
  String toString() => "Event <$name>";
}

EventModel _EventModelFromJson(Map<dynamic, dynamic> json) {
  return EventModel(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
  );
}

Map<String, dynamic> _EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };
