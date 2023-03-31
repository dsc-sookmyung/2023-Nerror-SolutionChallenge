import 'package:flutter/widgets.dart';

Widget profileImg(double width, double imgSizePercent, String img) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(width * imgSizePercent),
    child: Image.asset(
      img,
      width: width * imgSizePercent,
      height: width * imgSizePercent,
      fit: BoxFit.fill,
    ),
  );
}
