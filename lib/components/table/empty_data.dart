import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../cores/decoration.dart';
import '../text/text_secondary.dart';

class EmptyData extends StatelessWidget {
  const EmptyData({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: containerBoxDecorantionSecondary(context),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 80,
              child: SvgPicture.asset(
                height: 80,
                "assets/images/show-data.svg",
              ),
            ),
            const Gap(14),
            const BaseTextSecondary(label: 'Tidak Ada Data'),
          ],
        ),
      ),
    );
  }
}
