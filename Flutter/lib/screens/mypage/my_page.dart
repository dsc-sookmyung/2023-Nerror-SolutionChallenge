import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:marbon/color.dart';
import 'package:marbon/screens/mypage/pencil_icon.dart';
import 'package:marbon/screens/mypage/profile_img.dart';
import 'package:marbon/screens/mypage/setting_box.dart';
import 'package:marbon/widgets/myPage/add_mail_container.dart';
import 'package:marbon/widgets/logo_img.dart';
import 'package:tab_container/tab_container.dart';

import '../../controller/nickController.dart';
import '../../controller/userController.dart';
import '../../service/api_service.dart';
import '../../widgets/myPage/badge_img.dart';
import '../../widgets/myPage/badge_img_lock.dart';
import '../../widgets/myPage/nickModal.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  var nick = "nickname".obs;

  var logger = Logger();

  final List<int> HaveBadge = Get.find<UserController>().badges;

  final List<dynamic> tmp = Get.find<UserController>().mailAccounts;

  final _lightController = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    setState(() {});
    Get.put(NickController());
    if (Get.find<UserController>().nick != null) {
      Get.find<NickController>().setNick(Get.find<UserController>().nick);
    }

    return LayoutBuilder(
      builder: (context, constrains) => Column(
        children: [
          // 프로필부분
          _BuildProfileContainer(
              constrains.maxHeight * 0.45, constrains.maxWidth, context),
          // tab bar 부분
          Stack(
            children: [
              Container(
                height: constrains.maxHeight * 0.08,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40))),
              ),
              SizedBox(
                height: constrains.maxHeight * 0.55,
                child: TabContainer(
                  selectedTextStyle: const TextStyle(
                      color: green_color,
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  unselectedTextStyle: const TextStyle(
                      color: unselected_color,
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  tabs: const [
                    "BADGES",
                    "MY MAILS",
                    "SETTINGS",
                  ],
                  children: [
                    _BuildBadgeContainer(
                        constrains.maxHeight * 0.6, constrains.maxWidth * 0.9),
                    _BuildMymailsContainer(
                      constrains.maxHeight * 0.6,
                      constrains.maxWidth * 0.9,
                      context,
                    ),
                    _BuildSettingsContainer(constrains.maxHeight * 0.6,
                        constrains.maxWidth * 0.9, context),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 상단 프로필 관련 컨테이너
  Widget _BuildProfileContainer(double h, double w, BuildContext context) {
    const double imgSizePercent = 0.45;
    return Container(
      width: w,
      height: h,
      color: Colors.white,
      padding: EdgeInsets.only(left: w * 0.1, right: w * 0.1, top: h * 0.22),
      child: Center(
          child: Column(
        children: [
          profileImg(w, imgSizePercent, 'assets/img/signup_default.png'),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() {
                return Text(
                  Get.find<NickController>().nick.value.toString(),
                  style: const TextStyle(
                      color: text_green_color,
                      fontSize: 25,
                      fontWeight: FontWeight.w800),
                );
              }),
              IconButton(
                onPressed: () {
                  nickModal(context);
                },
                icon: pencilIcon(25, 18),
              ),
            ],
          )
        ],
      )),
    );
  }

  // 뱃지 관련 컨테이너
  Widget _BuildBadgeContainer(double h, double w) {
    return Container(
      padding: EdgeInsets.only(top: h * 0.16, bottom: h * 0.11),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (index) {
              return Center(
                child: HaveBadge[index] == 0
                    ? BadgeImageLock(index + 1, w)
                    : BadgeImage(index + 1, w),
              );
            }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (index) {
              return Center(
                child: HaveBadge[index + 3] == 0
                    ? BadgeImageLock(index + 4, w)
                    : BadgeImage(index + 4, w),
              );
            }),
          )
        ],
      ),
    );
  }

  // 메일 추가 관련 컨테이너
  Widget _BuildMymailsContainer(double h, double w, BuildContext c) {
    final List<dynamic> accounts = tmp.reversed.toList();
    List<int> items = List<int>.generate(accounts.length, (int index) => index);
    return ListView.builder(
      itemCount: accounts.length + 1,
      itemBuilder: (BuildContext context, int index) {
        return index < accounts.length
            ? _mailContainer(w, accounts[index], index, items, c)
            : addMailContainer(w, c, "/add_mail");
      },
    );
  }

  // Setting 관련 컨테이너
  Widget _BuildSettingsContainer(double h, double w, BuildContext c) {
    return Container(
      padding: EdgeInsets.only(left: w * 0.1, right: w * 0.1, top: h * 0.06),
      child: Column(
        children: [
          settingBox(
            h: h,
            leftIcon: Icons.lock_outline,
            content: "Change Password",
            rightWidget: IconButton(
              onPressed: () async {
                String authCode =
                    await ApiService().postEmail(Get.find<UserController>().id);
                if (authCode != "") {
                  logger.d("${Get.find<UserController>().id}  :  $authCode");
                  Navigator.pushNamed(
                    c,
                    "/change_pw1",
                    arguments: {"code": authCode},
                  );
                } else {
                  logger.d("인증코드가 정상적으로 오지 않았음");
                }
              },
              icon: const Icon(Icons.navigate_next_outlined),
              iconSize: 30,
              color: yellow_green_color,
            ),
          ),
          settingBox(
            h: h,
            leftIcon: Icons.dark_mode_outlined,
            content: "Dark Mode",
            rightWidget: AdvancedSwitch(
              controller: _lightController,
              height: 25,
              width: 40,
              activeColor: yellow_green_color,
            ),
          ),
        ],
      ),
    );
  }

  // 내 메일 한개한개 담고있는 컨테이너
  Widget _mailContainer(double width, String account, int index,
      List<int> items, BuildContext c) {
    // 메일 회사에 맞는 회사 및 로고 이미지 지정
    late String company;
    late Widget logo;
    double logoSize = 35;
    String mailCompany = account.contains("@")
        ? account.substring(account.indexOf("@") + 1, account.indexOf("."))
        : "";

    switch (mailCompany) {
      case "naver":
        company = "Naver";
        logo = logoImage("naver", logoSize);
        break;
      case "gmail":
        company = "Google";
        logo = logoImage("google", logoSize);
        break;
      case "hanmail":
        company = "Daum";
        logo = logoImage("daum", logoSize);
        break;
      case "icloud":
        company = "iCloud";
        logo = logoImage("apple", logoSize);
        break;
      case "mac":
        company = "iCloud";
        logo = logoImage("apple", logoSize);
        break;
      default:
        company = "기타(IMAP)";
        logo = logoImage("imap", logoSize);
    }

    // 스와이프 가능한 메일 패널 생성
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      //삭제할거냐 묻고한다면 메일삭제 api -> 성공시 지우고 성공못하면 Quickalert
      confirmDismiss: (direction) async {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text(account, style: const TextStyle(fontSize: 15)),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      return Navigator.of(context).pop(false);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: placeholder_color,
                    ),
                    child: const Text(
                      'CANCEL',
                      style: TextStyle(color: text_green_color),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      bool flag = await ApiService().deleteMailAccount(account);
                      if (flag) {
                        Get.find<UserController>().deleteAccount(account);
                        logger.d(Get.find<UserController>().mailAccounts);
                        return Navigator.of(context).pop(true);
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: green_color,
                    ),
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            });
      },
      onDismissed: (direction) {},
      background: Container(color: transparent_color),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 30.0),
        margin: const EdgeInsets.only(bottom: 22, top: 2),
        color: green_color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Icon(Icons.delete, color: Colors.white),
            SizedBox(width: 10),
            Text("Delete",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Colors.white)),
          ],
        ),
      ),
      child: Container(
        height: 115,
        alignment: Alignment.topCenter,
        child: Container(
          height: 90,
          width: width,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 40),
              logo,
              const SizedBox(width: 25),
              Text(
                company,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
