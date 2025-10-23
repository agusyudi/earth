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
import 'pipa_controller.dart';

class PipaPage extends StatefulWidget {
  const PipaPage({super.key});

  @override
  State<PipaPage> createState() => _PipaPageState();
}

class _PipaPageState extends State<PipaPage> {
  final controller = Get.put(PipaController());
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
      page: "list-pipa",
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
                label: "Daftar Pipa",
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
                    columnName: 'id',
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
                    columnName: 'kode',
                    width: 150,
                    label: Container(
                      padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                      alignment: Alignment.centerLeft,
                      child: const BaseTextTableHeader(
                        label: "Kode",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'ukuranPipa',
                    width: 150,
                    label: Container(
                      padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                      alignment: Alignment.centerLeft,
                      child: const BaseTextTableHeader(
                        label: "Ukuran",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'jenisPipa',
                    width: 150,
                    label: Container(
                      padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                      alignment: Alignment.centerLeft,
                      child: const BaseTextTableHeader(
                        label: "Jenis",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'thnBuat',
                    width: 100,
                    label: Container(
                      padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                      alignment: Alignment.centerRight,
                      child: const BaseTextTableHeader(
                        label: "Tahun Buat",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'tanggalPemasangan',
                    width: 150,
                    label: Container(
                      padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                      alignment: Alignment.centerLeft,
                      child: const BaseTextTableHeader(
                        label: "Tanggal Pasang",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'tanggalPerawatan',
                    width: 150,
                    label: Container(
                      padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                      alignment: Alignment.centerLeft,
                      child: const BaseTextTableHeader(
                        label: "Tanggal Perawatan",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'elevasi',
                    width: 150,
                    label: Container(
                      padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                      alignment: Alignment.centerRight,
                      child: const BaseTextTableHeader(
                        label: "Evelasi",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'statusPipa',
                    width: 150,
                    label: Container(
                      padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                      alignment: Alignment.centerLeft,
                      child: const BaseTextTableHeader(
                        label: "Status Pipa",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'kondisiPipa',
                    width: 150,
                    label: Container(
                      padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                      alignment: Alignment.centerLeft,
                      child: const BaseTextTableHeader(
                        label: "Kondisi Pipa",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'panjang',
                    width: 150,
                    label: Container(
                      padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                      alignment: Alignment.centerRight,
                      child: const BaseTextTableHeader(
                        label: "Panjang",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'ketebalan',
                    width: 150,
                    label: Container(
                      padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                      alignment: Alignment.centerRight,
                      child: const BaseTextTableHeader(
                        label: "Ketebalan",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'color',
                    width: 100,
                    label: Container(
                      padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                      alignment: Alignment.centerLeft,
                      child: const BaseTextTableHeader(
                        label: "Warna",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'keterangan',
                    minimumWidth: 200,
                    label: Container(
                      padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                      alignment: Alignment.centerLeft,
                      child: const BaseTextTableHeader(
                        label: "Keterangan",
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
