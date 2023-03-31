import 'package:flutter/material.dart';

import '../../color.dart';

Widget pencilIcon(double size, double iconWidth) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
        color: placeholder_color,
        borderRadius: BorderRadius.all(Radius.circular(size))),
    child: Icon(
      Icons.edit_rounded,
      color: text_green_color,
      size: iconWidth,
    ),
  );
}
