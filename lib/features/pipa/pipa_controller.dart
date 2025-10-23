import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../components/table/datasource_helpers.dart';
import '../../cores/response.dart';
import '../../models/pipa_model.dart';
import '../../services/rest_api_client_service.dart';

class PipaController extends GetxController {
  var list = <PipaModel>[].obs;
  var selectedList = <PipaModel>[].obs;
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
        'pipa',
        {},
        cancelToken: cancelToken,
      );

      if (apiResponse.status == true) {
        for (var i in apiResponse.data) {
          var jsonRes = PipaModel.fromJson(i);
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
                DataGridCell<int>(columnName: 'id', value: e.id),
                DataGridCell<String?>(columnName: 'kode', value: e.kode),
                DataGridCell<String?>(
                  columnName: 'ukuranPipa',
                  value: e.ukuranPipa,
                ),
                DataGridCell<String?>(
                  columnName: 'jenisPipa',
                  value: e.jenisPipa,
                ),
                DataGridCell<int?>(columnName: 'thnBuat', value: e.thnBuat),
                DataGridCell<DateTime?>(
                  columnName: 'tanggalPemasangan',
                  value: e.tanggalPemasangan,
                ),
                DataGridCell<DateTime?>(
                  columnName: 'tanggalPerawatan',
                  value: e.tanggalPerawatan,
                ),
                DataGridCell<double?>(columnName: 'elevasi', value: e.elevasi),
                DataGridCell<String?>(
                  columnName: 'statusPipa',
                  value: e.statusPipa,
                ),
                DataGridCell<String?>(
                  columnName: 'kondisiPipa',
                  value: e.kondisiPipa,
                ),
                DataGridCell<double?>(columnName: 'panjang', value: e.panjang),
                DataGridCell<double?>(
                  columnName: 'ketebalan',
                  value: e.ketebalan,
                ),
                DataGridCell<String?>(columnName: 'color', value: e.color),
                DataGridCell<String?>(
                  columnName: 'keterangan',
                  value: e.keterangan,
                ),
              ],
            ),
          )
          .toList(),
      {
        "tanggalPemasangan": (val) =>
            val == null ? null : DateFormat("dd MMMM yyyy").format(val),
        "tanggalPerawatan": (val) =>
            val == null ? null : DateFormat("dd MMMM yyyy").format(val),
      },
      onPerformSorting: () => performSorting(),
    );
  }
}
