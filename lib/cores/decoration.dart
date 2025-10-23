import 'package:flutter/material.dart';

BoxDecoration containerBoxDecorantion(BuildContext context) {
  return BoxDecoration(
    color: Theme.of(context).scaffoldBackgroundColor,
    border: Border.all(color: Theme.of(context).shadowColor, width: 1),
    borderRadius: BorderRadius.circular(5),
  );
}

BoxDecoration containerBoxDecorantionSecondary(BuildContext context) {
  return BoxDecoration(
    color: Theme.of(context).cardColor.withOpacity(0.5),
    border: Border.all(color: Theme.of(context).shadowColor, width: 0.4),
    borderRadius: BorderRadius.circular(5),
  );
}

BoxDecoration selectedMenuDecoration(BuildContext context) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(5),
    color: Theme.of(context).secondaryHeaderColor,
  );
}

BoxDecoration selectedMenuRoundedDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(50),
    color: Colors.black12,
    border: Border.all(width: 1, color: Colors.black12),
  );
}
