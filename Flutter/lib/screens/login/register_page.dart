import 'package:flutter/material.dart';
import 'package:marbon/color.dart';
import 'package:quickalert/quickalert.dart';

import '../../service/api_service.dart';
import '../../size.dart';
import '../../widgets/input_field.dart';

class RegisterPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController nickController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String defaultImage = "testfile.png";

  RegisterPage({super.key});

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
              decoration: const BoxDecoration(
                color: back_round_color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(circle_radius),
                  topRight: Radius.circular(circle_radius),
                ),
              ),
              child: ListView(children: [
                const Text(
                  "Register",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 40,
                      color: dark_green_color,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: title_input_gap),
                // 회원가입폼
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      InputField("Email", "email", emailController),
                      const SizedBox(height: input_input_gap),
                      InputField("nickname", "nick", nickController),
                      const SizedBox(height: input_input_gap),
                      InputField("Password", "pw", passwordController),
                      const SizedBox(height: input_button_gap),
                      // 3. TextButton 추가
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
                              String authCode = await ApiService()
                                  .postEmail(emailController.text.toString());

                              Navigator.pushNamed(
                                context,
                                "/register_email",
                                arguments: {
                                  "code": authCode,
                                  "email": emailController.text.toString(),
                                  "nick": nickController.text.toString(),
                                  "pw": passwordController.text.toString()
                                },
                              ); // 인증번호를 register_email에 인자로 전달

                              // 실패라면 다시 회원가입하라고 알리기
                              if (authCode.isEmpty) {
                                QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.warning,
                                    text: "Signup Failed! Try again");
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 70,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontSize: 16,
                        color: dark_green_color,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: transparent_color,
                      ),
                      child: const Text(
                        "Login Now",
                        style: TextStyle(
                            fontSize: 16,
                            color: yellow_green_color,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
