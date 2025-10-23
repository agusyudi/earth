import 'package:flutter/material.dart';

class BaseInfoContainer extends StatelessWidget {
  const BaseInfoContainer({super.key, this.listInfo, this.isTransparent});

  final List<Widget>? listInfo;
  final bool? isTransparent;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isTransparent == true
            ? Colors.transparent
            : Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: listInfo!,
      ),
    );
  }
}
