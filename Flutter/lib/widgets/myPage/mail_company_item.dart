import 'package:flutter/material.dart';

import '../logo_img.dart';

Widget mailCompanyItem(BuildContext c, String mailCompany, String mailImg) {
  return SizedBox(
    height: 65,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 20),
                  logoImage(mailImg, 25),
                  const SizedBox(width: 25),
                  Text(
                    mailCompany,
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  mailCompany == "Google"
                      ? Navigator.pushNamed(c, "/add_gmail_address",
                          arguments: {"mailCompany": mailCompany})
                      : Navigator.pushNamed(c, "/add_mail_address",
                          arguments: {"mailCompany": mailCompany});
                },
                icon: const Icon(Icons.navigate_next_outlined),
                iconSize: 30,
              ),
            ],
          ),
        ),
        const Divider(color: Colors.grey, thickness: 1.0),
      ],
    ),
  );
}
