import 'package:flutter/material.dart';
import 'package:marbon/color.dart';
import 'package:marbon/size.dart';
import 'package:marbon/widgets/two_line_text.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../widgets/input_field.dart';

class ForgetPwEmailPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController textController = TextEditingController();

  ForgetPwEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final String authCode = arguments["code"];
    final String email = arguments["email"];

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
                    "Authentication",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 35,
                      color: dark_green_color,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(
                    height: title_txt_gap,
                  ),
                  twoLineText(
                    "We have sent an email to your account",
                    "with a verification code! 🧑🏻‍💻",
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
                              "Confirm",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            // 기존에 만들어둔거 사용하기
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (authCode ==
                                    textController.text.toString()) {
                                  Navigator.pushNamed(
                                    context,
                                    "/forget_pw_new",
                                    arguments: {"email": email},
                                  );
                                } else {
                                  QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.error,
                                      text:
                                          "Please Check your verification code");
                                } // + 입력된 값 자동으로 지워주는것도 추가
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
