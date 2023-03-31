import 'package:flutter/material.dart';
import 'package:marbon/color.dart';
import 'package:marbon/size.dart';
import 'package:marbon/widgets/two_line_text.dart';

import '../../service/api_service.dart';
import '../../widgets/input_field.dart';

class ForgetPwPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  TextEditingController textController = TextEditingController();

  ForgetPwPage({super.key});
  @override
  Widget build(BuildContext context) {
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
                    "Forget Password?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 32,
                        color: dark_green_color,
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  twoLineText(
                    "Don't worry 😇 Please enter the Email",
                    "linked with your account",
                  ),
                  const SizedBox(
                    height: title_txt_gap,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        InputField("Email", "email", textController),
                        const SizedBox(height: input_button_gap),
                        SizedBox(
                          width: button_width,
                          height: button_height,
                          child: TextButton(
                            child: const Text(
                              "Send code",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                String authCode = await ApiService()
                                    .postEmail(textController.text.toString());

                                if (authCode != "") {
                                  // if (context.mounted) return;  // Don't use 'BuildContext's across async gaps 이지만 이 조건문을 쓰면 안넘어가져서 쓰면 안될 것 같음
                                  Navigator.pushNamed(
                                    context,
                                    "/forget_pw_email",
                                    arguments: {
                                      "code": authCode,
                                      "email": textController.text.toString()
                                    },
                                  );
                                } else {
                                  logger.d("인증코드가 정상적으로 오지 않았음");
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
