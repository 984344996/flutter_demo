import 'package:dio/dio.dart';

import 'ErrorEntity.dart';
import 'NetworkAPI.dart';

enum NetworkMethod {
  GET,
  POST,
  DELETE,
  PUT
}

const NetworkMethodValues = {
  NetworkMethod.GET: "get",
  NetworkMethod.POST: "post",
  NetworkMethod.DELETE: "delete",
  NetworkMethod.PUT: "put"
};

class DioManager {
  static final DioManager shared = DioManager._internal();
  factory DioManager() => shared;
  Dio dio;
  DioManager._internal() {
    if (dio == null) {
      BaseOptions options = BaseOptions(
        baseUrl: NetworkAPI.baseApi,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        receiveDataWhenStatusError: false,
        connectTimeout: 30000,
        receiveTimeout: 3000,
      );
      dio = Dio(options);
    }
  }

  // 请求，返回参数为 T
  // method：请求方法，NetworkMethod.POST等
  // path：请求地址
  // params：请求参数
  // success：请求成功回调
  // error：请求失败回调
  Future<dynamic> request(NetworkMethod method, String path, {Map<String, dynamic> params, Function(dynamic) success, Function(ErrorEntity) error}) async {
    try {
      Response response = await dio.request(path, queryParameters: params, options: Options(method: NetworkMethodValues[method]));
      if (response != null) {
          success(response.data);
        } else {
          error(ErrorEntity(code: -1, message: "服务器错误"));
        }
      return response.data;
      } on DioError catch(e) {
      error(createErrorEntity(e));
      return null;
    }
  }

  // 请求，返回参数为 List<T>
  // method：请求方法，NWMethod.POST等
  // path：请求地址
  // params：请求参数
  // success：请求成功回调
  // error：请求失败回调
  Future<dynamic>requestList(NetworkMethod method, String path, {Map<String, dynamic> params, Function(dynamic) success, Function(ErrorEntity) error}) async {
    try {
      Response response = await dio.request(path, queryParameters: params, options: Options(method: NetworkMethodValues[method]));
      if (response != null) {
        success(response.data);
      } else {
        error(ErrorEntity(code: -1, message: "服务器错误"));
      }
      return response.data;
    } on DioError catch(e) {
      error(createErrorEntity(e));
      return null;
    }
  }

  // 错误信息
  ErrorEntity createErrorEntity(DioError error) {
    switch (error.type) {
      case DioErrorType.CANCEL:{
        return ErrorEntity(code: -1, message: "请求取消");
      }
      break;
      case DioErrorType.CONNECT_TIMEOUT:{
        return ErrorEntity(code: -1, message: "连接超时");
      }
      break;
      case DioErrorType.SEND_TIMEOUT:{
        return ErrorEntity(code: -1, message: "请求超时");
      }
      break;
      case DioErrorType.RECEIVE_TIMEOUT:{
        return ErrorEntity(code: -1, message: "响应超时");
      }
      break;
      case DioErrorType.RESPONSE:{
        try {
          int errCode = error.response.statusCode;
          String errMsg = error.response.statusMessage;
          return ErrorEntity(code: errCode, message: errMsg);
//          switch (errCode) {
//            case 400: {
//              return ErrorEntity(code: errCode, message: "请求语法错误");
//            }
//            break;
//            case 403: {
//              return ErrorEntity(code: errCode, message: "服务器拒绝执行");
//            }
//            break;
//            case 404: {
//              return ErrorEntity(code: errCode, message: "无法连接服务器");
//            }
//            break;
//            case 405: {
//              return ErrorEntity(code: errCode, message: "请求方法被禁止");
//            }
//            break;
//            case 500: {
//              return ErrorEntity(code: errCode, message: "服务器内部错误");
//            }
//            break;
//            case 502: {
//              return ErrorEntity(code: errCode, message: "无效的请求");
//            }
//            break;
//            case 503: {
//              return ErrorEntity(code: errCode, message: "服务器挂了");
//            }
//            break;
//            case 505: {
//              return ErrorEntity(code: errCode, message: "不支持HTTP协议请求");
//            }
//            break;
//            default: {
//              return ErrorEntity(code: errCode, message: "未知错误");
//            }
//          }
        } on Exception catch(_) {
          return ErrorEntity(code: -1, message: "未知错误");
        }
      }
      break;
      default: {
        return ErrorEntity(code: -1, message: error.message);
      }
    }
  }
}

