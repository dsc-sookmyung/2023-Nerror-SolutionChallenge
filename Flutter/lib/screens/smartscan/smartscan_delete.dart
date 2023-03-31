import 'package:blobs/blobs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marbon/service/api_service.dart';

import '../../color.dart';
import '../../controller/userController.dart';
import '../../size.dart';
import '../../widgets/title_painter.dart';

class SmartScanDelete extends StatelessWidget {
  const SmartScanDelete({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final int totalDelte = arguments["totalDelete"];

    return LayoutBuilder(
      builder: (context, constrains) => Container(
        color: Colors.white,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: <Color>[
                gradient1_color,
                gradient2_color,
                gradient3_color
              ],
              tileMode: TileMode.mirror,
            ),
          ),
          child: Scaffold(
            backgroundColor: transparent_color,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 300, // 원하는높이 + 반지름길이
                      width: double.infinity,
                      child: CustomPaint(
                        painter: TitlePainter(),
                      ),
                    ),
                    Positioned(
                      left: smartscan_title_left,
                      top: 130,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Complete",
                            style: TextStyle(
                              color: text_green_color,
                              fontSize: 35,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "총 $totalDelte건의 메일이 삭제되었습니다.",
                            style: const TextStyle(
                              color: text_green_color,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: 300,
                  height: 300,
                  child: Image.asset(
                    'assets/img/delete.png',
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Blob.fromID(
                  id: const ['8-7-698'],
                  size: 150,
                  styles: BlobStyles(
                      gradient: const RadialGradient(colors: [
                    Color(0xffffffff),
                    Color.fromARGB(253, 247, 247, 247)
                  ]).createShader(
                          const Rect.fromLTRB(0, 140, 140, 0))), //0, y, x, 0
                  child: TextButton(
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(transparent_color),
                      ),
                      child: const Text(
                        "complete",
                        style: TextStyle(
                          color: text_green_color,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () async {
                        var refreshData = await ApiService()
                            .getRefresh(Get.find<UserController>().id);
                        var returnData = await ApiService().postLogin(
                            Get.find<UserController>().id,
                            Get.find<UserController>().pw);

                        Get.find<UserController>()
                            .setBadges(returnData["badgeList"]);
                        Get.find<UserController>()
                            .setDeleteCount(refreshData["deletedCount"]);
                        Get.find<UserController>()
                            .setLevel(returnData["currentLevel"]);
                        Get.find<UserController>()
                            .setTotalCount(refreshData["totalCount"]);

                        if (refreshData['flag']) {
                          Navigator.popUntil(
                              context, ModalRoute.withName('/bottom_tab_bar'));
                        } else {
                          logger.d("새로고침 실패");
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
