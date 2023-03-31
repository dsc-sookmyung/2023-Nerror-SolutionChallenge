import 'package:flutter/material.dart';

import '../color.dart';
import '../widgets/myPage/mail_company_item.dart';

class AddMailPage extends StatelessWidget {
  const AddMailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: transparent_color,
        iconTheme: const IconThemeData(),
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
          const SizedBox(height: 20),
          mailCompanyItem(context, "Google", "google"),
          mailCompanyItem(context, "iCloud", "apple"),
          mailCompanyItem(context, "Naver", "naver"),
          mailCompanyItem(context, "Daum", "daum"),
          mailCompanyItem(context, "IMAP", "imap"),
        ],
      ),
    );
  }
}
