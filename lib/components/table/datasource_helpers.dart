import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../cores/decoration.dart';
import '../loading/proses_loading_text.dart';
import '../text/text.dart';
import '../text/text_double.dart';

class BaseDataSource<T> extends DataGridSource {
  final numberFormat = NumberFormat("##,##0.00", "id_ID");
  final BuildContext context;

  Map<String, dynamic> customWidget;
  Map<String, Alignment> customAligment;
  Map<String, EdgeInsets> customPadding;
  Map<String, String> customNumberSuffix;
  Map<String, String> customNumberPrefix;
  List<DataGridRow> data;
  VoidCallback? onPerformSorting;
  Color? groupRowColor;
  Color? groupRowTextColor;
  bool? hideGroupCount;
  bool? isPersonalia;
  Function(dynamic)? getRowColor;
  Function<Widget>(RowColumnIndex rowColumnIndex, String summaryValue)?
  customGroupRow;

  List<DataGridRow> _cachedRows = [];
  BaseDataSource(
    this.context,
    this.data,
    this.customWidget, {
    this.customAligment = const {},
    this.customPadding = const {},
    this.customNumberSuffix = const {},
    this.customNumberPrefix = const {},
    this.onPerformSorting,
    this.groupRowColor,
    this.groupRowTextColor,
    this.hideGroupCount,
    this.isPersonalia,
    this.getRowColor,
    this.customGroupRow,
  }) {
    _cachedRows = data;
  }

  @override
  List<DataGridRow> get rows => data;

  @override
  List<DataGridRow> get effectiveRows => data;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    var index = data.indexOf(row);
    final e = data[index];

    final isSummary = row.getCells().any(
      (cell) => cell.columnName == 'isSummary' && cell.value == true,
    );

    if (isSummary) {
      return DataGridRowAdapter(
        cells: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.grey.shade300),
            child: Text(
              groupedColumns.first.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          for (int i = 1; i < row.getCells().length; i++)
            Container(
              alignment:
                  (row.getCells()[i].value is int ||
                      row.getCells()[i].value is double)
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              padding: const EdgeInsets.all(8),
              child:
                  (row.getCells()[i].value is int ||
                      row.getCells()[i].value is double)
                  ? BaseTextDouble(
                      label: row.getCells()[i].value ?? 0,
                      size: 12,
                      fontWeight: FontWeight.bold,
                    )
                  : BaseText(
                      label: row.getCells()[i].value?.toString() ?? '',
                      size: 12,
                      fontWeight: FontWeight.bold,
                    ),
            ),
        ],
      );
    } else {
      return DataGridRowAdapter(
        color: e.getCells()[0].value == true
            ? Colors.yellow.withOpacity(0.3)
            : (getRowColor == null
                  ? (index % 2 == 0
                        ? Colors.transparent
                        : Colors.grey.withOpacity(
                            0.1,
                          ) // warna untuk index genap
                          )
                  : getRowColor!(e)),
        cells: row.getCells().map<Widget>((dataGridCell) {
          if (e.getCells()[0].value == true) {
            return ClipRect(
              child: OverflowBox(
                maxWidth: double.infinity,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: const Row(children: [BaseProsesLoadingText()]),
                ),
              ),
            );
          }
          if (customWidget.containsKey(dataGridCell.columnName)) {
            return Container(
              alignment: customAligment.containsKey(dataGridCell.columnName)
                  ? customAligment[dataGridCell.columnName]
                  : Alignment.centerLeft,
              padding: customPadding.containsKey(dataGridCell.columnName)
                  ? customPadding[dataGridCell.columnName]
                  : const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: customWidget[dataGridCell.columnName](dataGridCell.value),
            );
          }
          if (dataGridCell.value.runtimeType == int ||
              dataGridCell.value.runtimeType == double) {
            return Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: BaseTextDouble(
                label: dataGridCell.value,
                suffix: customNumberSuffix[dataGridCell.columnName] ?? "",
                simbol: customNumberPrefix[dataGridCell.columnName] ?? "",
              ),
            );
          }

          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: dataGridCell.value.toString().length <= 30
                ? BaseText(
                    useEllipsis: false,
                    label: dataGridCell.value.toString(),
                  )
                : Tooltip(
                    decoration: containerBoxDecorantion(context),
                    waitDuration: Duration(microseconds: 0),
                    message: dataGridCell.value.toString(),
                    padding: const EdgeInsets.all(20),
                    textStyle: GoogleFonts.inter(
                      fontSize: 13,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                    constraints: BoxConstraints(maxWidth: 600),
                    child: BaseText(
                      label: dataGridCell.value.toString(),
                      useEllipsis: true,
                    ),
                  ),
          );
        }).toList(),
      );
    }
  }

  @override
  Widget? buildGroupCaptionCellWidget(
    RowColumnIndex rowColumnIndex,
    String summaryValue,
  ) {
    final groupKeyMatch = RegExp(r'^(.*?)\s+-').firstMatch(summaryValue);
    final groupKey = groupKeyMatch?.group(1)?.trim();

    // Filter baris dengan group key yang sama dan bukan summary
    final filteredRows = _cachedRows.where((row) {
      final groupCell = row.getCells().firstWhere(
        (c) => c.columnName == groupedColumns.first.name,
      );
      final isSummaryCell = row.getCells().firstWhere(
        (c) => c.columnName == 'isSummary',
      );

      return groupCell.value == groupKey && isSummaryCell.value == false;
    }).toList();

    final count = filteredRows.length;

    // Buat caption yang sudah dihitung ulang
    final caption = hideGroupCount == true
        ? groupKey.toString().toUpperCase()
        : '$groupKey - $count Data';

    return customGroupRow != null
        ? customGroupRow!(rowColumnIndex, summaryValue)
        : Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
            decoration: groupRowColor == null
                ? null
                : BoxDecoration(color: groupRowColor),
            child: BaseText(
              useEllipsis: false,
              label: caption,
              color: groupRowTextColor == null
                  ? ""
                  : colorToHex(groupRowTextColor!),
            ),
          );
  }

  @override
  Future<void> performSorting(List<DataGridRow> rows) async {
    if (sortedColumns.isEmpty) {
      return;
    }
    rows.sort((DataGridRow a, DataGridRow b) {
      return compareValues(sortedColumns, a, b);
    });
    if (onPerformSorting != null) {
      onPerformSorting!();
    }
  }

  @override
  Widget? buildTableSummaryCellWidget(
    GridTableSummaryRow summaryRow,
    GridSummaryColumn? summaryColumn,
    RowColumnIndex rowColumnIndex,
    String summaryValue,
  ) {
    String formattedValue = summaryValue;

    final filteredRows = rows.where((row) {
      final isSummary = row.getCells().any(
        (cell) => cell.columnName == 'isSummary' && cell.value == true,
      );
      return !isSummary;
    });

    final columnName = summaryColumn == null ? "" : summaryColumn.columnName;

    final total = filteredRows
        .map((row) {
          final cell = row.getCells().firstWhere(
            (c) => c.columnName == columnName,
            orElse: () => DataGridCell(columnName: columnName, value: 0),
          );
          return cell.value ?? 0;
        })
        .fold<num>(0, (prev, curr) => prev + (curr is num ? curr : 0));

    formattedValue = numberFormat.format(total); // contoh: 10.000

    return Container(
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(6.0),
      ),
      alignment: Alignment.centerRight,
      child: Text(
        formattedValue,
        style: const TextStyle(fontSize: 11.7, fontWeight: FontWeight.bold),
      ),
    );
  }

  void onRefreshRow({RowColumnIndex? rowColumnIndex}) {
    notifyDataSourceListeners(rowColumnIndex: rowColumnIndex);
  }

  int compareValues(
    List<SortColumnDetails> sortedColumns,
    DataGridRow a,
    DataGridRow b,
  ) {
    if (sortedColumns.length > 1) {
      for (final int i = 0; i < sortedColumns.length;) {
        final SortColumnDetails sortColumn = sortedColumns[i];
        final int compareResult = compare(a, b, sortColumn);
        if (compareResult != 0) {
          return compareResult;
        } else {
          final List<SortColumnDetails> remainingSortColumns = sortedColumns
              .where((SortColumnDetails value) => value != sortColumn)
              .toList(growable: false);
          return compareValues(remainingSortColumns, a, b);
        }
      }
    }
    final SortColumnDetails sortColumn = sortedColumns.last;
    return compare(a, b, sortColumn);
  }
}

void performSorting(
  DataGridSource? source,
  DataGridController cont,
  Function(int idx) selectedRow,
) {
  if (source != null) {
    cont.selectedIndex = -1;
    cont.selectedIndex = 0;
    if (cont.selectedRow != null) {
      var idx = source.effectiveRows.indexOf(cont.selectedRow!);
      selectedRow(idx);
    }
  }
}
