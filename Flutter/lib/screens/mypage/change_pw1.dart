import 'package:flutter/material.dart';
import 'package:marbon/size.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../color.dart';
import '../../widgets/input_field.dart';
import '../../widgets/two_line_text.dart';

class ChangePw1 extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController textController = TextEditingController();

  ChangePw1({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final String authCode = arguments["code"];
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: toolbar_height,
        shadowColor: transparent_color,
        backgroundColor: transparent_color,
        iconTheme: const IconThemeData(
          color: text_green_color,
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: circle_start - 70,
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
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    // 기존에 만들어둔거 사용하기
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (authCode == textController.text.toString()) {
                          Navigator.pushNamed(context, "/change_pw2");
                        } else {
                          // ++ 입력된 값 자동으로 지워주는것도 추가
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.warning,
                              text: "Please Check your verification code");
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
    );
  }
}
