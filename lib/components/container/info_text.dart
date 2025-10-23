import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

import '../divider/divider.dart';
import '../text/text_secondary.dart';
import '../text/text_selected.dart';

class BaseInfoText extends StatelessWidget {
  const BaseInfoText({
    super.key,
    required this.label,
    required this.value,
    this.valueTextEnd = false,
    this.widget,
    this.labelWidth,
    this.showBaseDivider = true,
  });

  final String label;
  final String value;
  final bool valueTextEnd;
  final Widget? widget;
  final double? labelWidth;
  final bool showBaseDivider;

  @override
  Widget build(BuildContext context) {
    // if (value == "null") {
    //   return SizedBox();
    // }
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            labelWidth == null
                ? Expanded(
                    flex: 4,
                    child: BaseTextSecondary(useEllipsis: false, label: label),
                  )
                : SizedBox(
                    width: labelWidth,
                    child: BaseTextSecondary(useEllipsis: false, label: label),
                  ),
            const Gap(5),
            Expanded(
              flex: 5,
              child: BaseSelectedText(
                fontWeight: FontWeight.w600,
                label: value,
                textAlign: valueTextEnd == true
                    ? TextAlign.end
                    : TextAlign.start,
              ),
            ),
            widget == null
                ? const SizedBox()
                : SizedBox(width: 30, child: widget),
          ],
        ),
        if (showBaseDivider) const BaseDividerSecondary(),
      ],
    );
  }
}
