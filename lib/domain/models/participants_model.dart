class ParticipantsModel {
  String docId;
  String eventId;
  String userId;
  String? avatar;
  String firstName;
  String lastName;
  String role;

  ParticipantsModel(
      {this.docId = '',
      this.eventId = '',
      this.userId = '',
      this.avatar,
      this.firstName = '',
      this.lastName = '',
      this.role = ''});

  factory ParticipantsModel.fromJson(Map<dynamic, dynamic> json) =>
      _ParticipantsModelFromJson(json);

  Map<String, dynamic> toJson() => _ParticipantsModelToJson(this);

  @override
  String toString() => "Participant <$docId>";
}

ParticipantsModel _ParticipantsModelFromJson(Map<dynamic, dynamic> json) {
  return ParticipantsModel(
    docId: json['docId'] as String,
    eventId: json['eventId'] as String,
    userId: json['userId'] as String,
    avatar: json['avatar'] as String,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    role: json['role'] as String,
  );
}

Map<String, dynamic> _ParticipantsModelToJson(ParticipantsModel instance) =>
    <String, dynamic>{
      'docId': instance.docId,
      'eventId': instance.eventId,
      'userId': instance.userId,
      'avatar': instance.avatar,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'role': instance.role,
    };
