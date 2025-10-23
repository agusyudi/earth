import 'package:flutter/material.dart';

import 'rest_api_client_service.dart';

class DropDownService {
  Future<List<DropDownHelperResponse>> getDropDownList(
    String endPoint,
    String value,
    String label,
    String? sublabel,
    Map<String, dynamic>? extensionParam,
  ) async {
    var result = <DropDownHelperResponse>[];
    try {
      Map<String, dynamic> parameter = {'showdetail': false};

      if (extensionParam != null) {
        parameter.addAll(extensionParam);
      }

      var apiResponse = await RestApiClient().getAsync(endPoint, parameter);

      result = [];

      if (apiResponse.status == true) {
        for (var i in apiResponse.data) {
          result.add(
            DropDownHelperResponse(
              value: i[value].toString(),
              label: i[label].toString(),
              sublabel: sublabel == null ? null : i[sublabel].toString(),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {}

    return result;
  }
}

class DropDownHelperResponse {
  String value;
  String label;
  String? sublabel;

  DropDownHelperResponse({
    required this.value,
    required this.label,
    this.sublabel,
  });
}
