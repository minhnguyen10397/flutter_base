import 'package:dio/dio.dart';
import 'package:flutter_config/flutter_config.dart';

import '../../common/utils/log_util.dart';
import '../../common/utils/network_util.dart';
import '../base/base_endpoint.dart';
import '../base/base_response.dart';
import '../base/method_request.dart';
import '../local/local_data_helper.dart';

abstract class APIServiceProtocol {
  Future<BaseResponse> requestData(EndpointType endpoint);
}

class APIService extends APIServiceProtocol {
  final _tag = "APIService";

  APIService._();

  static final APIService instance = APIService._();

  Dio? dio;

  Dio init() {
    if (dio == null) {
      dio = Dio();
      dio!.options.connectTimeout = 25000;
      dio!.options.receiveTimeout = 25000;
      dio!.options.baseUrl = FlutterConfig.get('BASE_URL');
    }
    return dio!;
  }

  @override
  Future<BaseResponse> requestData(EndpointType endpoint) async {
    Dio dio = init();
    final isNetworkAvailable = await NetworkUtil.instance.checkConnection();
    if (!isNetworkAvailable) {
      return BaseResponse(status: 500, message: "Network is not available");
    }

    final header = <String, dynamic>{};
    final token = await LocalDataHelper.instance.getToken();
    if (token != null) {
      header["Authorization"] = "Bearer $token";
    }

    Response response;
    if (endpoint.httpMethod == HttpMethod.get) {
      try {
        response = await dio.request(
          endpoint.path!,
          queryParameters: endpoint.parameters,
          options: Options(
            headers: header,
            contentType: Headers.jsonContentType,
            method: endpoint.httpMethod!.getValue(),
            validateStatus: (status) {
              if (status == null) {
                return false;
              }
              return status < 500;
            },
          ),
        );
      } catch (error) {
        AppLog.d(_tag, "----------------------start-response-------------------");
        AppLog.d(_tag, 'path: ${endpoint.path}');
        AppLog.d(_tag, 'param: ${(endpoint.parameters)}');
        AppLog.d(_tag, 'response: $error');
        AppLog.d(_tag, "----------------------end-response-------------------");
        return BaseResponse(
          status: 500,
          message: 'Connecting timed out!!',
        );
      }
    } else {
      try {
        response = await dio.request(
          endpoint.path!,
          data: endpoint.parameters,
          options: Options(
            headers: header,
            contentType: Headers.jsonContentType,
            method: endpoint.httpMethod!.getValue(),
            sendTimeout: 30,
            validateStatus: (status) {
              if (status == null) {
                return false;
              }
              return status < 500;
            },
          ),
        );
      } catch (error) {
        AppLog.d(_tag, "----------------------start-response-------------------");
        AppLog.d(_tag, 'path: ${endpoint.path}');
        AppLog.d(_tag, 'param: ${(endpoint.parameters)}');
        AppLog.d(_tag, 'response: $error');
        AppLog.d(_tag, "----------------------end-response-------------------");
        return BaseResponse(
          status: 500,
          message: 'Connecting timed out!!',
        );
      }
    }
    final json = response.data;
    AppLog.d(_tag, "----------------------start-response-------------------");
    AppLog.d(_tag, 'path: ${endpoint.path}');
    AppLog.d(_tag, 'param: ${(endpoint.parameters)}');
    AppLog.d(_tag, 'response: $json');
    AppLog.d(_tag, "----------------------end-response-------------------");
    if (json != null && json is Map<String, dynamic>) {
      int statusCode = response.statusCode!;
      if (statusCode >= 200 && statusCode < 300) {
        return BaseResponse.fromJsonSuccess(json);
      } else {
        return BaseResponse.fromJsonFail(json);
      }
    }
    return BaseResponse(
      status: response.statusCode,
      message: "Can't connect to server",
    );
  }
}
