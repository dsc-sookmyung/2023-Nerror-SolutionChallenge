import 'package:flutter/material.dart';
import '../color.dart';

class AddMailAddressPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  AddMailAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final String mailCompany = arguments["mailCompany"];
    late String address;

    switch (mailCompany) {
      case "Naver":
        address = "naver.com";
        break;
      case "Google":
        address = "gmail.com";
        break;
      case "Daum":
        address = "hanmail.net";
        break;
      case "iCloud":
        address = "";
        break;
      default:
        address = "";
    }
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
              if (address == "") {
                address = companyController.text.toString();
              }
              if (_formKey.currentState!.validate()) {
                Navigator.pushNamed(context, "/add_mail_server", arguments: {
                  "mailAddress": "${emailController.text.toString()}@$address"
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
            "assets/img/mail.png",
            width: 100,
            height: 100,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 40),
          const Text(
            "이메일 설정",
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
                  address != ""
                      ? SizedBox(
                          width: 130,
                          child: Text(
                            address,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        )
                      : SizedBox(
                          width: 130,
                          child: TextFormField(
                              keyboardType: TextInputType.name,
                              controller: companyController,
                              validator: (value) {
                                if ((value?.length)! < 1) {
                                  return "값을 입력하세요";
                                }
                                return null;
                              }),
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
