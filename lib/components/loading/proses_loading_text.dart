import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../cores/color.dart';

class BaseProsesLoadingText extends StatelessWidget {
  const BaseProsesLoadingText({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 17,
        width: 17,
        child: LoadingAnimationWidget.horizontalRotatingDots(
          color: buttonBlueColor,
          size: 17,
        ),
      ),
    );
  }
}
