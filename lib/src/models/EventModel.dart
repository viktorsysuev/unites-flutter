import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
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

  DocumentReference reference;

  EventModel(
      {this.id,
      this.name,
      this.description,
      this.company,
      this.phoneNumber,
      this.email,
      this.address,
      this.coordinates,
      this.start,
      this.end});

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
    company: json['company'] as String,
    phoneNumber: json['phoneNumber'] as String,
    email: json['email'] as String,
    address: json['address'] as String,
    coordinates: json['coordinates'] as GeoPoint,
    start: json['start'] == null ? null : (json['start'] as Timestamp).toDate(),
    end: json['end'] == null ? null : (json['end'] as Timestamp).toDate(),
  );
}

Map<String, dynamic> _EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'company': instance.company,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'address': instance.address,
      'coordinates': instance.coordinates,
      'start': instance.start,
      'end': instance.end,
    };
