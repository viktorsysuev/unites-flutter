class ParticipantsModel {
  String id;
  String eventId;
  String userId;
  String role;

  ParticipantsModel({this.id, this.eventId, this.userId, this.role});

  factory ParticipantsModel.fromJson(Map<dynamic, dynamic> json) =>
      _ParticipantsModelFromJson(json);

  Map<String, dynamic> toJson() => _ParticipantsModelToJson(this);

  @override
  String toString() => "Event <$id>";
}

ParticipantsModel _ParticipantsModelFromJson(Map<dynamic, dynamic> json) {
  return ParticipantsModel(
    id: json['id'] as String,
    eventId: json['eventId'] as String,
    userId: json['userId'] as String,
    role: json['role'] as String,
  );
}

Map<String, dynamic> _ParticipantsModelToJson(ParticipantsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'userId': instance.userId,
      'role': instance.role,
    };
