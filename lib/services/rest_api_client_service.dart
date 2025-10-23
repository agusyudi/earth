import 'dart:convert';

import 'package:dio/dio.dart';
import 'api_response.dart';
import '../cores/constant.dart';
import 'exception.dart';

class RestApiClient {
  late final Dio dio;

  RestApiClient() {
    dio = Dio(BaseOptions(baseUrl: baseurl));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers['x-api-key'] = apiKey;
          // options.headers['x-id-user'] = await getDataSession("iduser");
          return handler.next(options);
        },
        onError: (error, handler) async {
          handler.next(error);
        },
      ),
    );
  }

  Future<ApiBaseResponse> getAsync(
    String endPoint,
    Map<String, dynamic>? parameter, {
    CancelToken? cancelToken,
  }) async {
    try {
      if (cancelToken != null) {
        cancelToken.cancel();
        cancelToken = CancelToken();
      }

      var response = await dio.get(
        endPoint,
        queryParameters: parameter,
        cancelToken: cancelToken,
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.toString());
        if (data['Status'] == true) {
          return ApiBaseResponse(
            status: true,
            data: data['Data'],
            totalpage: data['TotalPage'] ?? 1,
            totalrecord: data['TotalRecord'] ?? 0,
            currentpage: data['CurrentPage'] ?? 1,
            message: data['UiMessage'] ?? "",
            executionTime: data['ExecutionTime'] ?? 0,
          );
        } else {
          return ApiBaseResponse(status: false, message: data['UiMessage']);
        }
      }
    } on DioException catch (e) {
      return exception(e);
    }

    return ApiBaseResponse();
  }
}
