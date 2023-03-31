import 'package:flutter/material.dart';

import '../color.dart';
import '../size.dart';

Widget twoLineText(String up, String down) {
  return SizedBox(
    height: two_line_text_box,
    width: 330,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          up,
          style: const TextStyle(
            fontSize: 16,
            color: explain_text_color,
          ),
        ),
        Text(
          down,
          style: const TextStyle(
            fontSize: 16,
            color: explain_text_color,
          ),
        )
      ],
    ),
  );
}
