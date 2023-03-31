import 'package:flutter/widgets.dart';

import '../../color.dart';

Widget settingBox(
    {required double h,
    required IconData leftIcon,
    required String content,
    required Widget rightWidget}) {
  return SizedBox(
    height: h * 0.15,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              leftIcon,
              size: 26,
              color: yellow_green_color,
            ),
            const SizedBox(width: 20),
            Text(
              content,
              style: const TextStyle(
                fontSize: 17,
                color: yellow_green_color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        rightWidget
      ],
    ),
  );
}
