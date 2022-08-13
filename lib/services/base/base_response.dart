class BaseResponse {
  final int? status;
  final String? message;
  final String? errCode;
  final Map<String, dynamic>? data;

  BaseResponse({
    this.status,
    this.message,
    this.errCode,
    this.data,
  });

  factory BaseResponse.fromJsonSuccess(Map<String, dynamic> json) {
    return BaseResponse(
      status: json["status"],
      data: json["data"],
      errCode: json["error_code"],
      message: json["message"],
    );
  }

  factory BaseResponse.fromJsonSocket(json) {
    return BaseResponse(data: json);
  }

  factory BaseResponse.fromJsonFail(Map<String, dynamic> json) {
    return BaseResponse(
      status: 400,
      message: json["message"] as String,
      errCode: json["error_code"] as String,
    );
  }
}
