class BaseModel<T> {
  bool status;
  String? message;
  String? errCode;
  T? data;

  BaseModel({this.status = false, this.message, this.data,this.errCode});
}
