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
    docId: json['docId'],
    eventId: json['eventId'],
    userId: json['userId'],
    avatar: json['avatar'],
    firstName: json['firstName'],
    lastName: json['lastName'],
    role: json['role'],
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
