import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../cores/theme/theme_service.dart';
import '../../models/column_visibility.dart';
import 'empty_data.dart';

class BaseDataTable3 extends StatefulWidget {
  final DataGridController dataGridController;
  final DataGridSource dataGridSource;
  final List<GridColumn> dataGridColumn;
  final int? frozenColumnsCount;
  final Function(RowColumnIndex, RowColumnIndex)? rowChange;
  final Function(RowColumnIndex, RowColumnIndex)? rowChange2;
  final Function(DataGridCellDoubleTapDetails)? rowDoubleTap;
  final Function(DataGridCellDoubleTapDetails, DataGridSource)? rowDoubleTap2;
  final Function(DataGridCellTapDetails)? rowSecondaryTap;
  final Function(DataGridCellTapDetails, DataGridSource)? rowSecondaryTap2;
  final Function(DataGridCellLongPressDetails)? rowLopPress;
  final Function(Offset globalPosition, int? idx, int? columnIdx)? rightClick;
  final double? rowHeight;
  final bool? rowAutoHeight;
  final SelectionMode? selectionMode;
  final Function(DataGridFilterChangeDetails)? onFilterChanged;
  final bool allowExpandCollapseGroup;
  final String groupCaption;
  final Color? groupBackgroundColor;
  final Color? groupCaptionColor;
  final List<ColumnSettingModel>? columnSettings;
  final bool allowColumnsResizing;
  final Color selectedColorLightMode;
  final Color selectedColorDarkMode;
  final bool allowFiltering;
  final bool allowSorting;
  final List<GridTableSummaryRow>? tableSummaryRows;
  final bool? showHeader;

  const BaseDataTable3({
    super.key,
    required this.dataGridController,
    required this.dataGridSource,
    required this.dataGridColumn,
    this.frozenColumnsCount,
    this.rowChange,
    this.rowChange2,
    this.rowDoubleTap,
    this.rowDoubleTap2,
    this.rowSecondaryTap,
    this.rowHeight,
    this.rowAutoHeight,
    this.rowLopPress,
    this.selectionMode,
    this.rowSecondaryTap2,
    this.rightClick,
    this.onFilterChanged,
    this.allowExpandCollapseGroup = false,
    this.groupCaption = '{ColumnName} : {Key} - {ItemsCount} Items',
    this.groupBackgroundColor,
    this.groupCaptionColor,
    this.columnSettings,
    this.allowColumnsResizing = false,
    this.selectedColorLightMode = const Color(0xFFC2F6C9),
    this.selectedColorDarkMode = const Color.fromARGB(255, 30, 55, 153),
    this.allowFiltering = true,
    this.allowSorting = true,
    this.tableSummaryRows,
    this.showHeader = true,
  });

  @override
  BaseDataTable3State createState() => BaseDataTable3State();
}

class BaseDataTable3State extends State<BaseDataTable3> {
  @override
  Widget build(BuildContext context) {
    List<GridColumn> gridColumnAdjusted = prepareColumn();

    return widget.dataGridSource.rows.isEmpty
        ? const EmptyData()
        : FocusScope(
            autofocus: false,
            canRequestFocus: false,
            child: Consumer<ThemeService>(
              builder: (context, themeService, _) {
                return SfDataGridTheme(
                  data: SfDataGridThemeData(
                    selectionColor: themeService.isDarkMode
                        ? widget.selectedColorDarkMode
                        : widget.selectedColorLightMode,
                    frozenPaneLineColor: Colors.transparent,
                    frozenPaneElevation: 0,
                    filterIcon: const Icon(
                      Icons.more_vert_outlined,
                      color: Colors.white,
                      size: 15,
                    ),
                    filterPopupTextStyle: GoogleFonts.inter(fontSize: 11.7),
                    gridLineColor: Theme.of(
                      context,
                    ).textTheme.bodySmall!.color!.withOpacity(0.2),
                    headerColor: Theme.of(context).secondaryHeaderColor,
                    filterIconColor: Colors.white,
                    sortIconColor: Colors.white,
                    currentCellStyle: const DataGridCurrentCellStyle(
                      borderColor: Colors.transparent,
                      borderWidth: 0,
                    ),
                    indentColumnWidth: 30,
                    indentColumnColor: widget.groupBackgroundColor,
                    groupExpanderIcon: Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: widget.groupCaptionColor,
                    ),
                    columnResizeIndicatorColor: Color(0xFF1053B8),
                    columnResizeIndicatorStrokeWidth: 2,
                  ),
                  child: SfDataGrid(
                    frozenColumnsCount: widget.frozenColumnsCount ?? 0,
                    footerFrozenColumnsCount: 0,
                    allowMultiColumnSorting: true,
                    showColumnHeaderIconOnHover: true,
                    allowExpandCollapseGroup: widget.allowExpandCollapseGroup,
                    groupCaptionTitleFormat: widget.groupCaption,
                    showSortNumbers: true,
                    isScrollbarAlwaysShown: true,
                    headerGridLinesVisibility: GridLinesVisibility.vertical,
                    controller: widget.dataGridController,
                    source: widget.dataGridSource,
                    editingGestureType: EditingGestureType.doubleTap,
                    columns: gridColumnAdjusted,
                    allowFiltering: widget.allowFiltering,
                    allowSorting: widget.allowSorting,
                    columnWidthMode: ColumnWidthMode.fill,
                    selectionMode: widget.selectionMode ?? SelectionMode.single,
                    navigationMode: GridNavigationMode.cell,
                    headerRowHeight: widget.showHeader == false ? 0 : 37,
                    tableSummaryRows: widget.tableSummaryRows ?? [],
                    rowHeight: widget.rowHeight == null
                        ? double.nan
                        : widget.rowHeight!,
                    onCurrentCellActivated: widget.rowChange,
                    onSelectionChanged: (addedRows, removedRows) {
                      var idx = -1;
                      if (addedRows.isNotEmpty) {
                        idx = widget.dataGridSource.effectiveRows.indexOf(
                          addedRows.first,
                        );
                      }
                      if (widget.rowChange2 != null) {
                        widget.rowChange2!(
                          RowColumnIndex(idx, 0),
                          RowColumnIndex(0, 0),
                        );
                      }
                    },
                    onCellDoubleTap: (p) {
                      if (widget.rowDoubleTap != null) {
                        widget.rowDoubleTap!(p);
                      }
                      if (widget.rowDoubleTap2 != null) {
                        widget.rowDoubleTap2!(p, widget.dataGridSource);
                      }
                    },
                    onCellSecondaryTap: (details) {
                      if (widget.rowSecondaryTap != null) {
                        widget.rowSecondaryTap!(details);
                        return;
                      }
                      if (widget.rowSecondaryTap2 != null) {
                        widget.rowSecondaryTap2!(
                          details,
                          widget.dataGridSource,
                        );
                      }
                      if (widget.rightClick != null) {
                        var index = details.rowColumnIndex.rowIndex - 1;
                        var columnIndex = details.rowColumnIndex.columnIndex;
                        if (widget.dataGridController.selectedRow != null &&
                            index >= 0 &&
                            columnIndex >= 0) {
                          var currentIdx =
                              widget.dataGridController.selectedIndex;
                          widget.dataGridController.selectedIndex =
                              index == currentIdx ? -1 : index;
                          widget.dataGridController.selectedIndex = index;
                          int idx =
                              widget.dataGridController.selectedRow != null
                              ? widget.dataGridSource.effectiveRows.indexOf(
                                  widget.dataGridController.selectedRow!,
                                )
                              : -1;

                          widget.rightClick!(
                            details.globalPosition,
                            idx,
                            columnIndex,
                          );
                        }
                      }
                    },
                    onCellLongPress: widget.rowLopPress,
                    onQueryRowHeight: (RowHeightDetails details) {
                      if (widget.rowAutoHeight == true) {
                        final rowIndex = details.rowIndex - 1;

                        if (rowIndex >= 0 &&
                            rowIndex < widget.dataGridSource.rows.length) {
                          final row = widget.dataGridSource.rows[rowIndex];
                          final maxTextHeight = _getMaxTextHeight(
                            row,
                            250,
                            GoogleFonts.inter(
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium!.color,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            //const TextStyle(fontWeight: FontWeight.w600),
                          );
                          return maxTextHeight > details.rowHeight
                              ? maxTextHeight + 7
                              : details.rowHeight;
                        }
                      }
                      return details.rowHeight;
                    },
                    onFilterChanged: widget.onFilterChanged ?? (details) {},
                    allowColumnsResizing: widget.allowColumnsResizing,
                    onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
                      if (widget.columnSettings != null) {
                        setState(() {
                          var f = widget.columnSettings!
                              .where((s) => s.name == details.column.columnName)
                              .firstOrNull;
                          if (f != null) {
                            f.width = details.width;
                          }
                          gridColumnAdjusted = prepareColumn();
                        });
                      }
                      return true;
                    },
                  ),
                );
              },
            ),
          );
  }

  double _getMaxTextHeight(DataGridRow row, double maxWidth, TextStyle style) {
    double maxHeight = widget.rowHeight ?? 37;
    int i = 0;
    for (final cell in row.getCells()) {
      //final textHeight = _calculateTextHeight(cell.value.toString(), maxWidth, style);
      final col = widget.dataGridColumn[i];
      if (col.visible != false &&
          col.columnName != "statusFreeze" &&
          col.columnName != "statusfreeze") {
        final textHeight = _calculateTextHeight(
          cell.value.toString(),
          col.actualWidth,
          style,
        );
        if (cell.value.toString().split('\n').length > 1) {
          double tempHeight = (14.0) * cell.value.toString().split('\n').length;
          tempHeight = tempHeight > (widget.rowHeight ?? 37)
              ? tempHeight + 5
              : (widget.rowHeight ?? 37);
          // maxHeight =
          //     textHeight > textHeight * cell.value.toString().split('\n').length
          //         ? textHeight
          //         : textHeight * cell.value.toString().split('\n').length;
          maxHeight = tempHeight > maxHeight ? tempHeight : maxHeight;
          maxHeight = textHeight > maxHeight ? textHeight : maxHeight;
        } else {
          if (cell.value is List<String>) {
            double tempHeight = (14.0) * cell.value.length;
            tempHeight = tempHeight > (widget.rowHeight ?? 37)
                ? tempHeight + 5
                : (widget.rowHeight ?? 37);
            maxHeight = tempHeight > maxHeight ? tempHeight : maxHeight;
            maxHeight = textHeight > maxHeight ? textHeight : maxHeight;
          } else {
            maxHeight = textHeight > maxHeight ? textHeight : maxHeight;
          }
        }
      }
      i++;
    }
    return maxHeight;
  }

  double _calculateTextHeight(String text, double maxWidth, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: null,
    )..layout(maxWidth: maxWidth);
    return textPainter.size.height;
  }

  List<GridColumn> prepareColumn() {
    List<GridColumn> gridColumnAdjusted = [];

    var lc = widget.dataGridColumn.where((s) => s.visible == true).lastOrNull;

    for (var c in widget.dataGridColumn) {
      if (widget.columnSettings != null) {
        var f = widget.columnSettings!
            .where((s) => s.name == c.columnName)
            .firstOrNull;
        if (f != null) {
          gridColumnAdjusted.add(
            GridColumn(
              visible: c.visible && f.value,
              width: f.width ?? c.width,
              minimumWidth: f.minimumWidth ?? c.minimumWidth,
              maximumWidth: c.maximumWidth,
              columnWidthMode: lc != null && lc.columnName == c.columnName
                  ? ColumnWidthMode.lastColumnFill
                  : (lc != null && lc.columnName != c.columnName
                        ? ColumnWidthMode.fitByCellValue
                        : c.columnWidthMode),
              columnName: c.columnName,
              label: c.label,
              allowEditing: c.allowEditing,
              allowFiltering: c.allowFiltering,
              allowSorting: c.allowSorting,
              autoFitPadding: c.autoFitPadding,
              filterPopupMenuOptions: c.filterPopupMenuOptions,
              filterIconPadding: c.filterIconPadding,
              filterIconPosition: c.filterIconPosition,
            ),
          );
          continue;
        }
      }
      gridColumnAdjusted.add(c);
    }

    return gridColumnAdjusted;
  }
}
