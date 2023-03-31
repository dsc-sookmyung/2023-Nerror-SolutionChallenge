import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../color.dart';
import '../controller/userController.dart';

class AddMailServerPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();

  AddMailServerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final String mailAddress =
        arguments["mailAddress"]; //mailAddress가 내가 등록한 이메일 주소

    final mailCompany = mailAddress.substring(
        mailAddress.indexOf("@") + 1, mailAddress.indexOf("."));

    late String imap;
    late String port;

    switch (mailCompany) {
      case "naver":
        imap = "imap.naver.com";
        port = "993";
        break;
      case "gmail":
        imap = "imap.gmail.com";
        port = "993";
        break;
      case "hanmail":
        imap = "smtp.daum.net";
        port = "993";
        break;
      case "icloud":
        imap = "imap.mail.me.com";
        port = "993";
        break;
      case "mac":
        imap = "iCloud";
        port = "993";
        break;
      default:
        imap = "기타(IMAP)";
        port = "993";
    }

    print(mailAddress);
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
            onPressed: () async {
              // 메일 추가 api

              if (_formKey.currentState!.validate()) {
                final returnData = await ApiService().addMail(
                    Get.find<UserController>().id,
                    mailAddress,
                    passwordController.text.toString(),
                    imap,
                    port);
                if (returnData["accountList"] != []) {
                  final totalCount = await ApiService().getSaveMail(
                      Get.find<UserController>().id,
                      mailAddress,
                      passwordController.text.toString(),
                      imap,
                      port);
                  // 메일 계정 리스트 업데이트

                   Get.find<UserController>()
                       .setMailAccounts(returnData["accountList"]);

if (totalCount["flag"] == true) {
                    // 메일계정 추가 & 메일 저장 끝
                    Get.find<UserController>()
                        .setTotalCount(totalCount["totalCount"]);

                    await QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      confirmBtnColor: text_green_color,
                      text: "Mail account added successfully",
                    );
                    // 메일 갯수 업데이트

                    Navigator.popUntil(
                        context, ModalRoute.withName('/bottom_tab_bar'));
                  }
                }
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
            "assets/img/mail.png",
            width: 100,
            height: 100,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 40),
          const Text(
            "수신 서버 설정",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 20),
          const Divider(color: text_green_color, thickness: 2.5),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  Text("사용자이름 : ${Get.find<UserController>().id}"),
                  const SizedBox(height: 40),
                  TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Your Password',
                        labelText: '비밀번호',
                      ),
                      keyboardType: TextInputType.name,
                      controller: passwordController,
                      validator: (value) {
                        if ((value?.length)! < 1) {
                          return "값을 입력하세요";
                        }
                        return null;
                      }),
                  const SizedBox(height: 40),
                  Text("IMAP : $imap"),
                  const SizedBox(height: 40),
                  Text("Port : $port"),
                ]),
              ),
            ),
          )
        ],
      ),
    );
  }
}
