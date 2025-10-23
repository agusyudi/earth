import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../cores/color.dart';
import '../text/text_secondary.dart';

class BaseProsesLoadingHitung extends StatelessWidget {
  const BaseProsesLoadingHitung({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 17,
            width: 17,
            child: LoadingAnimationWidget.fourRotatingDots(
              color: buttonBlueColor,
              size: 17,
            ),
          ),
          const Gap(10),
          const BaseTextSecondary(label: 'Kalkulasi Total Data...'),
        ],
      ),
    );
  }
}
