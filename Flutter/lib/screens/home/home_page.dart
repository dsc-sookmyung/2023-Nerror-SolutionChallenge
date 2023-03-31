import 'package:flutter/material.dart';
import 'package:marbon/color.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffedeedd),
      body: LayoutBuilder(
        builder: (context, constrains) => Column(
          children: [
            SizedBox(
              height: 120,
              width: constrains.maxWidth,
            ),
            Container(
              height: constrains.maxWidth * 0.85,
              width: constrains.maxWidth * 0.85,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/img/round_mail.png"),
                      fit: BoxFit.fill)),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: constrains.maxWidth * 0.82,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Mail",
                    style: TextStyle(
                        fontSize: 42,
                        color: Color.fromARGB(216, 0, 0, 0),
                        fontWeight: FontWeight.w900),
                  ),
                  const Text(
                    "Cleaner",
                    style: TextStyle(
                        fontSize: 42,
                        color: Color.fromARGB(216, 0, 0, 0),
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "By deleting unnecessary emails",
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    "Shall we reduce our digital",
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    "carbon footprint?",
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      shadowColor: const Color.fromARGB(96, 158, 158, 158),
                      elevation: 3,
                      backgroundColor: white_90_color,
                      fixedSize: const Size(150, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(67),
                      ),
                    ),
                    child: const Text(
                      "Get Statred",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/login");
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
