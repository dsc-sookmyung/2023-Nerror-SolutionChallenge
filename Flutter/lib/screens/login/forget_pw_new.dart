import 'package:flutter/material.dart';
import 'package:marbon/size.dart';
import 'package:marbon/widgets/two_line_text.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../color.dart';
import '../../service/api_service.dart';
import '../../widgets/input_field.dart';

class ForgetPwNew extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController textController = TextEditingController();

  ForgetPwNew({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
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
                    " 🔐 Settings",
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
                    "Please Enter your new password",
                    "8~16 length, letters + numbers combination",
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        InputField("Password", "pw", textController),
                        const SizedBox(height: input_button_gap),
                        SizedBox(
                          width: button_width,
                          height: button_height,
                          child: TextButton(
                            child: const Text(
                              "Confirm",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                // pw를 바꾸는 api 성공하면 성공했다 알람띄우고 이동
                                // textController.text.toString() 값을 비밀번호로 수정하는 api

                                bool flag = await ApiService().modifyPassword(
                                    email, textController.text.toString());

                                if (flag) {
                                  await QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.success,
                                    confirmBtnColor: text_green_color,
                                    text: 'Change password successfully',
                                  );

                                  Navigator.popUntil(
                                      context, ModalRoute.withName('/login'));
                                } else {
                                  QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.error,
                                      text:
                                          "There is no account or something wrong Retry!");
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
