import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../divider/divider.dart';
import '../text/text_secondary.dart';
import '../text/text_selected.dart';

class BaseInfoTextMultiLine extends StatelessWidget {
  const BaseInfoTextMultiLine({
    super.key,
    required this.label,
    required this.value,
    this.valueTextEnd = false,
    this.widget,
    this.withDivider = true,
    this.isNumber = false,
    this.simbol = '',
    this.isPercentase = false,
  });

  final String label;
  final String value;
  final bool valueTextEnd;
  final Widget? widget;
  final bool? withDivider;
  final bool isNumber;
  final String simbol;
  final bool isPercentase;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseTextSecondary(useEllipsis: false, label: label),
        BaseSelectedText(
          useEllipsis: false,
          fontWeight: FontWeight.w600,
          label: isNumber ? numberToStringFormat() : value,
          textAlign: valueTextEnd == true ? TextAlign.end : TextAlign.start,
        ),
        if (widget != null) widget!,
        withDivider == true ? const BaseDividerSecondary() : const Gap(10),
      ],
    );
  }

  String numberToStringFormat() {
    var numberValue = double.parse(value);
    var angka = '';
    var labelFinal = 0.0;

    if (numberValue < 0) {
      labelFinal = numberValue * -1;
    } else {
      labelFinal = numberValue;
    }

    if (labelFinal % 1 == 0) {
      angka =
          '${simbol == '' ? '' : simbol}${NumberFormat("##,##0", "id_ID").format(labelFinal)}${isPercentase == true ? '%' : ''}';
    } else {
      angka =
          '${simbol == '' ? '' : simbol}${NumberFormat('#,##0.00', 'id_ID').format(labelFinal)}${isPercentase == true ? '%' : ''}';
    }

    return angka;
  }
}
