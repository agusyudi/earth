import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../cores/color.dart';

class BaseProsesLoadingOnlyCircular extends StatelessWidget {
  const BaseProsesLoadingOnlyCircular({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 17,
        width: 17,
        child: LoadingAnimationWidget.fourRotatingDots(
          color: color ?? buttonBlueColor,
          size: 17,
        ),
      ),
    );
  }
}
