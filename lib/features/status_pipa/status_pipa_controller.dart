import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../components/table/datasource_helpers.dart';
import '../../cores/response.dart';
import '../../models/status_pipa_model.dart';
import '../../models/pipa_model.dart';
import '../../services/rest_api_client_service.dart';

class StatusPipaController extends GetxController {
  var list = <StatusPipaModel>[].obs;
  var selectedList = <StatusPipaModel>[].obs;
  var isloadingGetData = false.obs;
  var selectedIndex = 0.obs;
  var dGridController = DataGridController();

  Future initial() async {
    selectedList.clear();
    list.clear();
    selectedIndex.value = 0;
    await get();
  }

  Future<ResponseResult> get() async {
    var result = ResponseResult();

    list.clear();

    try {
      isloadingGetData.value = true;
      var cancelToken = CancelToken();

      var apiResponse = await RestApiClient().getAsync(
        'status-pipa',
        {},
        cancelToken: cancelToken,
      );

      if (apiResponse.status == true) {
        for (var i in apiResponse.data) {
          var jsonRes = StatusPipaModel.fromJson(i);
          list.add(jsonRes);
        }

        if (list.isNotEmpty) {
          selectedRow(0);
        }
      }

      result = ResponseResult(
        status: apiResponse.status,
        message: apiResponse.message,
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloadingGetData.value = false;
    }

    return result;
  }

  Future selectedRow(int index) async {
    selectedIndex.value = index;
    selectedList.value = [];
    selectedList.add(list[index]);
  }

  DataGridSource dSource(BuildContext context, {performSorting}) {
    return BaseDataSource<PipaModel>(
      context,
      list
          .map<DataGridRow>(
            (e) => DataGridRow(
              cells: [
                DataGridCell<bool>(columnName: 'isLoading', value: e.isloading),
                DataGridCell<int>(
                  columnName: 'idStatusPipa',
                  value: e.idStatusPipa,
                ),
                DataGridCell<String?>(
                  columnName: 'statusPipa',
                  value: e.statusPipa,
                ),
              ],
            ),
          )
          .toList(),
      {},
      onPerformSorting: () => performSorting(),
    );
  }
}
