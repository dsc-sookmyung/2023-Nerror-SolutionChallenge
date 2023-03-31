import 'package:flutter/material.dart';
import '../color.dart';

class AddGMailAddressPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  AddGMailAddressPage({super.key});
  renderTextFormField({
    required String label,
    required FormFieldSetter onSaved,
    required FormFieldValidator validator,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        TextFormField(
          onSaved: onSaved,
          validator: validator,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final String authCode = arguments["code"];
    final String email = arguments["email"];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: transparent_color,
        iconTheme: const IconThemeData(),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: transparent_color,
              foregroundColor: dark_green_color,
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // 외부 링크로 갔다가 메일 서버로

                Navigator.pushNamed(context, "/add_mail_server", arguments: {
                  "mailAddress": "${emailController.text.toString()}@gmail.com"
                });
              }
            },
            child: const Text(
              "NEXT",
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 10, right: 10),
        children: [
          const SizedBox(height: 20),
          Image.asset(
            "assets/img/gmail.png",
            width: 100,
            height: 100,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 40),
          const Text(
            "이메일 주소 추가",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 20),
          const Divider(color: text_green_color, thickness: 2.5),
          const SizedBox(height: 20),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  //textAlign: TextAlign.center,
                  "GMAIL",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
                Text(
                  textAlign: TextAlign.center,
                  "계정 보호를 위해 Google 에서 2단계 인증을 진행합니다.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  textAlign: TextAlign.center,
                  "1. Google 계정에 로그인 후 'Google 계정' ",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  textAlign: TextAlign.center,
                  "(https://myaccount.google.com/) 으로 이동합니다.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  textAlign: TextAlign.center,
                  "2. 왼쪽에서 '보안' 탭으로 이동합니다.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  textAlign: TextAlign.center,
                  "3. 2단계 인증을 사용 설정합니다.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  textAlign: TextAlign.center,
                  "4. '앱 비밀번호 설정'으로 이동합니다. ",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  textAlign: TextAlign.center,
                  "5. (사진) '앱 선택'에서 '메일'을 선택하고, 사용자의 기기를",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  textAlign: TextAlign.center,
                  "선택하여 비밀번호를 발급하고 로그인합니다.",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Form(
              key: _formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 150,
                    child: TextFormField(
                        keyboardType: TextInputType.name,
                        controller: emailController,
                        validator: (value) {
                          if ((value?.length)! < 1) {
                            return "값을 입력하세요";
                          }
                          return null;
                        }),
                  ),
                  const Text(
                    "@",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    width: 130,
                    child: Text(
                      "gmail.com",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
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
