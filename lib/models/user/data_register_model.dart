class VerifyOtpDataModel {
  VerifyOtpDataModel({
    this.userId,
    this.token,
  });

  VerifyOtpDataModel.fromJson(dynamic json) {
    userId = json['user_id'];
    token = json['token'];
  }

  int? userId;
  String? token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = userId;
    map['token'] = token;
    return map;
  }
}
