import 'package:flutter/material.dart';

class BaseVerticalLineExpanded extends StatelessWidget {
  const BaseVerticalLineExpanded({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
      child: Container(
        width: 1.5,
        height: double.infinity,
        color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.1),
      ),
    );
  }
}
