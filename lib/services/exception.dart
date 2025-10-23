import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'api_response.dart';

ApiBaseResponse exception(DioException e) {
  if (e.response != null && e.response!.statusCode == 400) {
    Map<String, dynamic> json = e.response!.data;
    debugPrint("data => ${json["Ui_msg"]}");

    return ApiBaseResponse(status: false, message: json["Ui_msg"]);
  } else if (CancelToken.isCancel(e)) {
    return ApiBaseResponse(
      status: false,
      message: "Request Canceled : ${e.message}",
    );
  } else {
    debugPrint(e.message.toString());
    return ApiBaseResponse(status: false, message: e.message.toString());
  }
}
