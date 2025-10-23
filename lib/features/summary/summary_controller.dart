import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';

import '../../cores/response.dart';
import '../../models/offtaker_summary_model.dart';
import '../../models/spam_summary_model.dart';
import '../../models/wilayah_model.dart';
import '../../services/rest_api_client_service.dart';

class SummaryController extends GetxController {
  var isLoadingInit = false.obs;

  Future initial() async {
    isLoadingInit.value = true;
    await getOffTaker();
    await getSpam();
    await getWilayah();

    isLoadingInit.value = false;
  }

  var listSpamSummary = <SpamSummaryModel>[].obs;
  var isLoadingSpamSummary = false.obs;

  Future<ResponseResult> getSpam() async {
    var result = ResponseResult();

    listSpamSummary.clear();

    try {
      isLoadingSpamSummary.value = true;
      var cancelToken = CancelToken();

      var apiResponse = await RestApiClient().getAsync(
        'spam/summary',
        {},
        cancelToken: cancelToken,
      );

      if (apiResponse.status == true) {
        for (var i in apiResponse.data) {
          var jsonRes = SpamSummaryModel.fromJson(i);
          listSpamSummary.add(jsonRes);
        }
      }

      result = ResponseResult(
        status: apiResponse.status,
        message: apiResponse.message,
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoadingSpamSummary.value = false;
    }

    return result;
  }

  final wilayah = <Polygon>[].obs;
  var wilayahDetails = <WilayahModel>[].obs;
  var isLoadingWilayah = false.obs;

  Future<ResponseResult> getWilayah() async {
    var result = ResponseResult();

    wilayah.clear();
    wilayahDetails.clear();

    try {
      isLoadingWilayah.value = true;
      var cancelToken = CancelToken();

      var apiResponse = await RestApiClient().getAsync(
        'wilayah',
        {},
        cancelToken: cancelToken,
      );

      if (apiResponse.status == true) {
        for (var i in apiResponse.data) {
          var jsonRes = WilayahModel.fromJson(i);
          wilayahDetails.add(jsonRes);

          for (var x in jsonRes.geometry) {
            wilayah.add(
              Polygon(
                points: x,
                color: Color(
                  int.parse(jsonRes.color.replaceFirst('#', '0xff')),
                ).withOpacity(0.6),
                borderColor: Colors.white,
                borderStrokeWidth: 2,
              ),
            );
          }
        }
      }

      result = ResponseResult(
        status: apiResponse.status,
        message: apiResponse.message,
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoadingWilayah.value = false;
    }

    return result;
  }

  var listOffTakerSummary = <OfftakerSummaryModel>[].obs;
  var isLoadingOffTakerSummary = false.obs;

  Future<ResponseResult> getOffTaker() async {
    var result = ResponseResult();

    listOffTakerSummary.clear();

    try {
      isLoadingOffTakerSummary.value = true;
      var cancelToken = CancelToken();

      var apiResponse = await RestApiClient().getAsync(
        'offtaker/summary',
        {},
        cancelToken: cancelToken,
      );

      if (apiResponse.status == true) {
        for (var i in apiResponse.data) {
          var jsonRes = OfftakerSummaryModel.fromJson(i);
          listOffTakerSummary.add(jsonRes);
        }
      }

      result = ResponseResult(
        status: apiResponse.status,
        message: apiResponse.message,
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoadingOffTakerSummary.value = false;
    }

    return result;
  }
}
