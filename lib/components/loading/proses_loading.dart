import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../cores/color.dart';
import '../text/text.dart';

class BaseProsesLoading extends StatelessWidget {
  const BaseProsesLoading({super.key, this.text = 'Tunggu sebentar...'});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
            width: 30,
            child: LoadingAnimationWidget.inkDrop(
              color: buttonBlueColor,
              size: 30,
            ),
          ),
          const Gap(10),
          BaseText(label: text, size: 13),
        ],
      ),
    );
  }
}
