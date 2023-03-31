import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marbon/color.dart';
import 'package:marbon/size.dart';
import '../../controller/userController.dart';
import '../../service/api_service.dart';
import '../../widgets/input_field.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: circle_start,
          ),
          Expanded(
            child: Container(
              // 뒷배경 원
              decoration: const BoxDecoration(
                color: back_round_color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(circle_radius),
                  topRight: Radius.circular(circle_radius),
                ),
              ),
              child: ListView(
                children: [
                  const Text(
                    "Login",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      color: dark_green_color,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: title_input_gap),
                  // 로그인폼
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        InputField("Email", "email", emailController),
                        const SizedBox(height: input_input_gap),
                        InputField("Password", "pw", passwordController),
                        const SizedBox(height: 20),
                        Container(
                          height: 40,
                          padding: const EdgeInsets.only(right: 40),
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: transparent_color,
                              foregroundColor: dark_green_color,
                            ),
                            child: const Text(
                              "Forget Password?",
                              style: TextStyle(fontSize: 14),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                "/forget_pw",
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: button_width,
                          height: button_height,
                          child: TextButton(
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),

                            //로그인 성공시 해당 정보들을 받아서 getX에 등록하기
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                var refreshData = await ApiService().getRefresh(
                                    emailController.text.toString());
                                final returnData = await ApiService().postLogin(
                                    emailController.text.toString(),
                                    passwordController.text.toString());
                                // 새로고침 api 불러오기
                                if (returnData["flag"]) {
                                  var refreshData = await ApiService()
                                      .getRefresh(
                                          emailController.text.toString());
                                  Get.find<UserController>().upadateUserInform(
                                      id: returnData["id"],
                                      nick: returnData["nick"],
                                      pw: passwordController.text.toString(),
                                      accessToken: returnData["accessToken"],
                                      refreshToken: returnData["refreshToken"],
                                      deleteCount: returnData["deletedCount"],
                                      totalCount: refreshData['totalCount'],
                                      currentLevel: returnData['currentLevel'],
                                      badges: returnData["badgeList"],
                                      mailAccounts: returnData["mailAccounts"],
                                      mailCategory: []);
                                  Navigator.pushNamed(
                                      context, "/bottom_tab_bar");
                                  // Navigator.pushNamed(context, "/bottomBar", arguments: returnData);
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 135),
                  Row(
                    // 계정 추가 텍스트버튼
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don’t have an account?",
                        style: TextStyle(
                            fontSize: 16,
                            color: dark_green_color,
                            fontWeight: FontWeight.w400),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: transparent_color,
                        ),
                        child: const Text(
                          "Register Now",
                          style: TextStyle(
                              fontSize: 16,
                              color: yellow_green_color,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, "/register");
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
