abstract class BaseResponseInterface{
  int statusCode;
  String message;
}

class BaseEntity<T> implements BaseResponseInterface{
  @override
  String message;

  @override
  int statusCode;

  T data;

  BaseEntity.fromJson(Map<String, dynamic> json){
    this.message = json["message"];
    this.statusCode = json["statusCode"];
  }
}

class BaseListEntity<T> implements BaseResponseInterface{
  @override
  String message;

  @override
  int statusCode;

  List<T> data;
}