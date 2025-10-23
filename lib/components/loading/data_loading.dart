import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../cores/color.dart';
import '../text/text.dart';

class BaseDataLoading extends StatelessWidget {
  final String text;

  const BaseDataLoading({super.key, this.text = "Memuat Data"});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
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
          ),
        ],
      ),
    );
  }
}
