import 'package:flutter/material.dart';

class BaseDivider extends StatelessWidget {
  const BaseDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.3),
      thickness: 0.5,
    );
  }
}
