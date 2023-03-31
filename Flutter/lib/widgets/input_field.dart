import 'package:flutter/material.dart';
import 'package:marbon/color.dart';
import 'package:marbon/size.dart';

const int minPw = 6; // pw 최소글자수
const int minNick = 2; // nick 최소 글자수

class InputField extends StatelessWidget {
  final String text;
  final String icon;
  final TextEditingController textController;

  const InputField(this.text, this.icon, this.textController, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: text_Field_width,
      height: text_field_height,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(65),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 3),
              spreadRadius: 1,
              blurRadius: 6,
            ),
          ],
        ),
        child: TextFormField(
          style: const TextStyle(
            color: placeholder_color,
          ),
          controller: textController,
          // 경고 문구
          validator: (value) {
            if ((value?.length)! < 1) {
              return "값을 입력하세요";
            }

            if (icon == "email") {
              if (!RegExp(
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                  .hasMatch(value!)) {
                return '잘못된 이메일 형식';
              }
            }

            if (icon == "pw") {
              if ((value?.length)! < minPw) {
                return "$minPw자 이상 입력 필수";
              }
            }

            if (icon == "nick") {
              if ((value?.length)! < minNick) {
                return "$minNick자 이상 입력 필수";
              }
            }

            return null;
          },
          // 텍스트필드의 값이 비밀번호일 경우 *로 가리기
          obscureText: text == "Password" ? true : false,
          keyboardType: icon == "email"
              ? TextInputType.emailAddress
              : icon == "none"
                  ? TextInputType.number
                  : TextInputType.text,
          decoration: InputDecoration(
            hintStyle: const TextStyle(
              color: placeholder_color,
            ),
            prefixIcon: icon == "none"
                ? const Icon(
                    Icons.wordpress,
                    color: transparent_color,
                  )
                : icon == "pw"
                    ? const Icon(
                        Icons.lock_outline,
                        color: placeholder_color,
                      )
                    : icon == "email"
                        ? const Icon(
                            Icons.email_outlined,
                            color: placeholder_color,
                          )
                        : const Icon(
                            Icons.person_outline,
                            color: placeholder_color,
                          ),
            hintText: icon == "none" ? text : "Enter $text", // 텍스트 필드안의 값
            focusedBorder: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              // 기본 텍스트필드 디자인
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none, // 테두리 없애기
            ),
          ),
        ),
      ),
    );
  }
}
