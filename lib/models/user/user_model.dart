class UserModel {
  UserModel({
    this.userId,
    this.firstName,
    this.lastName,
    this.avatar,
  });

  UserModel.fromJson(dynamic json) {
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    avatar = json['profile_pic_thumbnail'];
  }

  int? userId;
  String? firstName;
  String? lastName;
  String? avatar;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = userId;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['profile_pic_thumbnail'] = avatar;
    return map;
  }
}
