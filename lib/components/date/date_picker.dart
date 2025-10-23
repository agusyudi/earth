import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

import '../text/text.dart';

Future<DateTime?> showDate(BuildContext context, DateTime? currentDate) async {
  DateTime? result = currentDate;
  var data = await showCalendarDatePicker2Dialog(
    context: context,
    config: CalendarDatePicker2WithActionButtonsConfig(
      cancelButton: const BaseText(label: "Batal"),
      okButton: const BaseText(label: "OK"),
    ),
    dialogSize: const Size(450, 400),
    barrierDismissible: false,
    borderRadius: BorderRadius.circular(18),
    value: [currentDate],
  );

  if (data != null) {
    result = data.first;
  }

  return result;
}
