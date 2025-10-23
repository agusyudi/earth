import 'package:flutter/material.dart';

class BaseVerticalLine extends StatelessWidget {
  const BaseVerticalLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Container(
        height: 35,
        constraints: const BoxConstraints(
          minHeight: 35,
          maxHeight: 50,
          maxWidth: 1.5,
        ),
        color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.1),
      ),
    );
  }
}
