import 'package:flutter/widgets.dart';

Widget logoImage(String company, double logoSize) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(logoSize),
    child: Image.asset(
      "assets/img/$company.png",
      width: logoSize,
      height: logoSize,
      fit: BoxFit.contain,
    ),
  );
}
