class UserModel {
  String userId;
  String firstName;
  String lastName;
  String interests;
  String useful;
  String phone;
  String company;
  String token;
  String aboutMe;
  String avatar;

  UserModel(
      {this.userId,
      this.firstName,
      this.lastName,
      this.interests,
      this.useful,
      this.phone,
      this.company,
      this.token,
      this.aboutMe,
      this.avatar});

  factory UserModel.fromJson(Map<dynamic, dynamic> json) =>
      _UserModelFromJson(json);

  Map<String, dynamic> toJson() => _UserModelToJson(this);

  @override
  bool operator ==(Object other) {
    var user = other as UserModel;
    return user == null ? false : user.userId == userId;
  }
}

UserModel _UserModelFromJson(Map<dynamic, dynamic> json) {
  return UserModel(
    userId: json['userId'] as String,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    interests: json['interests'] as String,
    useful: json['useful'] as String,
    phone: json['phone'] as String,
    company: json['company'] as String,
    token: json['token'] as String,
    aboutMe: json['aboutMe'] as String,
    avatar: json['avatar'] as String,
  );
}

Map<String, dynamic> _UserModelToJson(UserModel instance) => <String, dynamic>{
      'userId': instance.userId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'interests': instance.interests,
      'useful': instance.useful,
      'phone': instance.phone,
      'company': instance.company,
      'token': instance.token,
      'aboutMe': instance.aboutMe,
      'avatar': instance.avatar,
    };
