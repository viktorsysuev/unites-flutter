import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unites_flutter/src/models/ParticipantsModel.dart';

class EventWithMembers {
  String id;
  String name;
  String description;
  String company;
  String phoneNumber;
  String email;
  String address;
  GeoPoint coordinates;
  DateTime start;
  DateTime end;
  List<ParticipantsModel> participants;

  EventWithMembers(
  {this.id,
  this.name,
  this.description,
  this.company,
  this.phoneNumber,
  this.email,
  this.address,
  this.coordinates,
  this.start,
  this.end,
  this.participants});

//  factory EventWithMembers.fromJson(Map<dynamic, dynamic> json) =>
//      _EventModelFromJson(json);
//
//  Map<String, dynamic> toJson() => _EventModelToJson(this);
//
//  Map<String, dynamic> toMap() => _EventModelToMap(this);

  factory EventWithMembers.fromDB(Map<String, dynamic> table, List<Map<String, dynamic>> participants) {
    return EventWithMembers(
        id: table['eventId'],
        name: table['name'],
        description: table['description'],
        company: table['company'],
        phoneNumber: table['phoneNumber'],
        email: table['email'],
        address: table['address'],
        coordinates: table['coordinates'] != null
            ? GeoPoint(
                double.parse(table['coordinates'].toString().split(' ')[0]),
                double.parse(table['coordinates'].toString().split(' ')[1]))
            : null,
        start: DateTime.parse(table['start']),
        end: DateTime.parse(table['end']),
        participants: participants.map((e) => ParticipantsModel.fromJson(e)));
  }

  @override
  String toString() => "Event <$name>";
}

//EventWithMembers _EventModelFromJson(Map<dynamic, dynamic> json) {
//  return EventWithMembers(
//    id: json['id'] as String,
//    name: json['name'] as String,
//    description: json['description'] as String,
//    company: json['company'] as String,
//    phoneNumber: json['phoneNumber'] as String,
//    email: json['email'] as String,
//    address: json['address'] as String,
//    coordinates: json['coordinates'] as GeoPoint,
//    start: json['start'] == null ? null : (json['start'] as Timestamp).toDate(),
//    end: json['end'] == null ? null : (json['end'] as Timestamp).toDate(),
//  );
//}
//
//Map<String, dynamic> _EventModelToJson(EventWithMembers instance) =>
//    <String, dynamic>{
//      'id': instance.id,
//      'name': instance.name,
//      'description': instance.description,
//      'company': instance.company,
//      'phoneNumber': instance.phoneNumber,
//      'email': instance.email,
//      'address': instance.address,
//      'coordinates': instance.coordinates,
//      'start': instance.start,
//      'end': instance.end,
//    };
//
//Map<String, dynamic> _EventModelToMap(EventWithMembers instance) =>
//    <String, dynamic>{
//      'eventId': instance.id,
//      'name': instance.name,
//      'description': instance.description,
//      'company': instance.company,
//      'phoneNumber': instance.phoneNumber,
//      'email': instance.email,
//      'address': instance.address,
//      'coordinates': instance.coordinates != null
//          ? '${instance.coordinates.latitude} ${instance.coordinates.longitude}'
//          : null,
//      'start': instance.start.toIso8601String(),
//      'end': instance.end.toIso8601String(),
//    };
