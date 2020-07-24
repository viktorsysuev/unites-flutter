class UserModel {
  String userId;
  String firstName;
  String lastName;
  String interests;
  String useful;
  String company;
  String token;
  String aboutMe;

  UserModel(
      {this.userId,
      this.firstName,
      this.lastName,
      this.interests,
      this.useful,
      this.company,
      this.token,
      this.aboutMe});

  factory UserModel.fromJson(Map<dynamic, dynamic> json) =>
      _UserModellFromJson(json);

  Map<String, dynamic> toJson() => _UserModelToJson(this);
}

UserModel _UserModellFromJson(Map<dynamic, dynamic> json) {
  return UserModel(
    userId: json['userId'] as String,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    interests: json['interests'] as String,
    useful: json['useful'] as String,
    company: json['company'] as String,
    token: json['token'] as String,
    aboutMe: json['aboutMe'] as String,
  );
}

Map<String, dynamic> _UserModelToJson(UserModel instance) => <String, dynamic>{
      'userId': instance.userId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'interests': instance.interests,
      'useful': instance.useful,
      'company': instance.company,
      'token': instance.token,
      'aboutMe': instance.aboutMe,
    };
