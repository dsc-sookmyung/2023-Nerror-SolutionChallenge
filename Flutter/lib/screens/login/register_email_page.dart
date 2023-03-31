import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:marbon/color.dart';
import 'package:marbon/size.dart';
import 'package:marbon/widgets/two_line_text.dart';
import 'package:quickalert/quickalert.dart';
import '../../controller/userController.dart';
import '../../service/api_service.dart';
import '../../widgets/input_field.dart';

var logger = Logger();

class RegisterEmailPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>(); // 글로벌 key

  TextEditingController textController = TextEditingController();

  RegisterEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 전 회원가입 페이지에서 인자로 보내준 인증 코드 가져오기
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final String authCode = arguments["code"];
    final String email = arguments["email"];
    final String nick = arguments["nick"];
    final String pw = arguments["pw"];
    late String accessToken;
    late String refreshToken;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: toolbar_height,
        shadowColor: transparent_color,
        backgroundColor: transparent_color,
        iconTheme: const IconThemeData(
          color: text_green_color,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: back_round_color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(circle_radius),
                  topRight: Radius.circular(circle_radius),
                ),
              ),
              child: ListView(
                children: [
                  const SizedBox(
                    height: toolbar_height,
                  ),
                  const Text(
                    "Register",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 40,
                        color: dark_green_color,
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: title_txt_gap),
                  twoLineText(
                    "We have sent an email to your account",
                    "with a verification code!",
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        InputField("Ex) fs18dx4", "none", textController),
                        const SizedBox(height: input_button_gap),
                        SizedBox(
                          width: button_width,
                          height: button_height,
                          child: TextButton(
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (authCode ==
                                    textController.text.toString()) {
                                  // 등록 완료됨을 띄우고 okay -> 로그인창

                                  var tokens = await ApiService()
                                      .postSignup(email, pw, nick);

                                  accessToken = tokens["accessToken"];
                                  refreshToken = tokens["refreshToken"];

                                  if (accessToken == "" && refreshToken == "") {
                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.error,
                                      text:
                                          "Member registration failed. Retry Plz",
                                    );
                                  } else {
                                    // 가입성공

                                    final returnData =
                                        await ApiService().postLogin(email, pw);
                                    if (returnData["flag"]) {
                                      Get.find<UserController>()
                                          .upadateUserInform(
                                              id: returnData["id"],
                                              nick: returnData["nick"],
                                              pw: pw,
                                              accessToken:
                                                  returnData["accessToken"],
                                              refreshToken:
                                                  returnData["refreshToken"],
                                              deleteCount:
                                                  returnData["deletedCount"],
                                              totalCount:
                                                  returnData['totalCount'],
                                              currentLevel:
                                                  returnData['currentLevel'],
                                              badges: returnData["badgeList"],
                                              mailAccounts:
                                                  returnData["mailAccounts"],
                                              mailCategory: []);
                                    }

                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.success,
                                      text: "Signup Completed Successfully",
                                      onConfirmBtnTap: () {
                                        Navigator.pushNamed(
                                            context, "/bottom_tab_bar");
                                      },
                                    );
                                  }
                                } else {
                                  QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.warning,
                                    text: "Please Check your verification code",
                                  );
                                  // + 입력된 값 자동으로 지워주는것도 추가
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
