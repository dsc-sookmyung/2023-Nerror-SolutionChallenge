import 'package:flutter/widgets.dart';

Widget BadgeImage(int idx, double w) {
  return Image.asset(
    'assets/img/badges$idx.png',
    width: w * 0.25,
    height: w * 0.25,
  );
}
