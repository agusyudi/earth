import 'package:flutter/material.dart';

class BaseDividerSecondary extends StatelessWidget {
  const BaseDividerSecondary({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.5),
      thickness: 0.2,
    );
  }
}
