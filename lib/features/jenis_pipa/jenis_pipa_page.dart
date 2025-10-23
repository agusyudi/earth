import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gis/components/text/text.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../components/loading/data_loading.dart';
import '../../components/page/page.dart';
import '../../components/table/datasource_helpers.dart';
import '../../components/table/empty_data.dart';
import '../../components/table/sfdatagrid.dart';
import '../../components/text/text_table_header.dart';
import 'jenis_pipa_controller.dart';

class JenisPipaPage extends StatefulWidget {
  const JenisPipaPage({super.key});

  @override
  State<JenisPipaPage> createState() => _JenisPipaPageState();
}

class _JenisPipaPageState extends State<JenisPipaPage> {
  final controller = Get.put(JenisPipaController());
  final GlobalKey mapKey = GlobalKey();
  final dataTable = GlobalKey<BaseDataTable3State>();

  @override
  void initState() {
    super.initState();
    controller.initial();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundcolor: Theme.of(context).cardColor,
      page: "jenis-pipa",
      rigthPanel: null,
      centerPanel: cernterContent,
    );
  }

  Padding get cernterContent {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              BaseText(
                label: "Jenis Pipa",
                size: 20,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          const Gap(10),
          table,
        ],
      ),
    );
  }

  Expanded get table {
    return Expanded(
      child: Obx(
        () => controller.isloadingGetData.value == true
            ? const BaseDataLoading()
            : controller.list.isEmpty
            ? const EmptyData()
            : BaseDataTable3(
                key: dataTable,
                rowHeight: 35,
                frozenColumnsCount: 1,
                dataGridController: controller.dGridController,
                dataGridSource: controller.dSource(
                  context,
                  performSorting: () => {
                    performSorting(
                      dataTable.currentState?.widget.dataGridSource,
                      controller.dGridController,
                      controller.selectedRow,
                    ),
                  },
                ),
                dataGridColumn: [
                  GridColumn(
                    visible: false,
                    width: 0,
                    columnName: 'isLoading',
                    label: const SizedBox(),
                  ),
                  GridColumn(
                    columnName: 'idJenisPipa',
                    width: 80,
                    label: Container(
                      padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                      alignment: Alignment.centerRight,
                      child: const BaseTextTableHeader(
                        label: "ID",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'jenisPipa',
                    label: Container(
                      padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                      alignment: Alignment.centerLeft,
                      child: const BaseTextTableHeader(
                        label: "Jenis Pipa",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                rowChange2:
                    (
                      RowColumnIndex currentRowColumnIndex,
                      RowColumnIndex previousRowColumnIndex,
                    ) async {
                      var index = currentRowColumnIndex.rowIndex;
                      await controller.selectedRow(index);
                    },
              ),
      ),
    );
  }
}
