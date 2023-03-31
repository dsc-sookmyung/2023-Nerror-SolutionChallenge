import 'package:flutter/material.dart';

Widget BadgeImageLock(int idx, double w) {
  return Stack(
    children: [
      // 잠긴 이미지의 경우
      Image.asset(
        'assets/img/badges$idx.png',
        width: w * 0.25,
        height: w * 0.25,
      ),
      Positioned(
        child: Container(
          width: w * 0.25,
          height: w * 0.25,
          decoration: BoxDecoration(
            color: const Color.fromARGB(155, 158, 158, 158),
            borderRadius: BorderRadius.circular(w * 0.25),
          ),
        ),
      ),
      Positioned(
        top: w * 0.072,
        left: w * 0.075,
        child: const Icon(
          Icons.lock_outline_sharp,
          color: Color.fromARGB(251, 255, 254, 254),
          size: 35,
        ),
      )
    ],
  );
}
