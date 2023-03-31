import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:marbon/color.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../controller/countController.dart';
import '../../controller/userController.dart';
import '../../size.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var logger = Logger();
  @override
  Widget build(BuildContext context) {
    Get.put(CountController());
    Get.find<CountController>()
        .setDeleteCount(Get.find<UserController>().deleteCount);
    if (Get.find<UserController>().totalCount != null) {
      Get.find<CountController>()
          .setTotalCount(Get.find<UserController>().totalCount);
    }
    if (Get.find<UserController>().currentLevel != null) {
      Get.find<CountController>()
          .setLevel(Get.find<UserController>().currentLevel);
    }

    double deletePercent = Get.find<CountController>().totalCount != 0
        ? ((Get.find<CountController>().deleteCount.value) /
            (Get.find<CountController>().totalCount.value))
        : 0.0;

    return LayoutBuilder(
      builder: (context, constrains) => Center(
        child: Padding(
          padding: const EdgeInsets.only(
              left: mainscreen_padding_width / 2,
              right: mainscreen_padding_width / 2,
              top: 60,
              bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(
                // 원형 프로그래스바
                children: [
                  CircularPercentIndicator(
                    animation: true,
                    animationDuration: 1000,
                    radius: 200,
                    lineWidth: 15,
                    percent: 0.8,
                    progressColor: green_color,
                    backgroundColor: yellow_green_color,
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                  Positioned(
                    top: 50,
                    left: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100 * 0.3),
                      child: Image.asset(
                        'assets/img/marbon.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: total_delete_container_gap),
              _buildTotalDelete(constrains),
              const SizedBox(height: total_delete_container_gap),
              _buildPercentContainer(
                  constrains,
                  "${double.parse(deletePercent.toStringAsFixed(2)) * 100} %",
                  "전체메일에서 삭제된 메일 만큼의 비율",
                  deletePercent),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildHalfContainer(
                      constrains,
                      "📫 ${Get.find<CountController>().totalCount}",
                      "전체 메일 갯수"),
                  _buildHalfContainer(
                      constrains,
                      "🌲 ${Get.find<CountController>().currentLevel}",
                      "현재 당신의 레벨"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalDelete(BoxConstraints c) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: (c.maxWidth - line_img_width - mainscreen_padding_width) / 2,
          height: total_delete_height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "전체 삭제 메일",
                style: TextStyle(
                    color: unselected_color,
                    fontSize: 19,
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(
                height: total_delete_text_gap,
              ),
              Text(
                "${Get.find<CountController>().deleteCount} 건",
                style: const TextStyle(
                    color: green_color,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        SizedBox(
          width: line_img_width,
          height: total_delete_height,
          child: Image.asset(
            'assets/img/divide.png',
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(
          width: (c.maxWidth - line_img_width - mainscreen_padding_width) / 2,
          height: total_delete_height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "탄소 배출 감소",
                style: TextStyle(
                    color: unselected_color,
                    fontSize: 19,
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(
                height: total_delete_text_gap,
              ),
              Text(
                "${((Get.find<CountController>().deleteCount.value) * 4) / 1000}  kg",
                style: const TextStyle(
                    color: green_color,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPercentContainer(
      BoxConstraints c, String title, String explain, double percentNum) {
    return Container(
      height: 130,
      width: c.maxWidth - mainscreen_padding_width,
      padding: const EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  color: green_color,
                  fontSize: 25,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              explain,
              style: const TextStyle(
                  color: unselected_color,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 10,
            ),
            LinearPercentIndicator(
              animation: true,
              animationDuration: 1000,
              lineHeight: 30,
              percent: percentNum,
              progressColor: green_color,
              backgroundColor: background_color,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHalfContainer(BoxConstraints c, String title, String explain) {
    return Container(
      height: 130,
      width: (c.maxWidth - mainscreen_padding_width - halfcontainer_gap) / 2,
      padding: const EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: green_color,
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              explain,
              style: const TextStyle(
                color: unselected_color,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
