import 'package:flutter/material.dart';

import '../../color.dart';

Widget addMailContainer(double width, BuildContext c, String moveAddress) {
  return Container(
    height: 120,
    alignment: Alignment.center,
    child: Container(
      width: width,
      height: 100,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: IconButton(
        icon: const Icon(
          Icons.add_circle_outline,
          color: green_color,
          size: 50,
        ),
        onPressed: () {
          Navigator.pushNamed(c, moveAddress);
        },
      ),
    ),
  );
}
