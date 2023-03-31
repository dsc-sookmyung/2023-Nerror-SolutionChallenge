import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../color.dart';
import '../../controller/nickController.dart';
import '../../controller/userController.dart';
import '../../service/api_service.dart';
import '../../size.dart';

Future<dynamic> nickModal(BuildContext context) {
  String newNick = '';
  return QuickAlert.show(
    context: context,
    type: QuickAlertType.custom,
    barrierDismissible: true,
    confirmBtnText: 'Save',
    confirmBtnColor: text_green_color,
    widget: TextFormField(
      decoration: const InputDecoration(
        alignLabelWithHint: true,
        hintText: 'Enter Your Nickname',
        prefixIcon: Icon(
          Icons.person_outline,
          color: text_green_color,
        ),
      ),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.name,
      onChanged: (value) => newNick = value,
    ),
    onConfirmBtnTap: () async {
      if (newNick.length < minNick) {
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          confirmBtnColor: text_green_color,
          text: 'Please input at least 2 characters',
        );
        return;
      }
      Navigator.pop(context);
      await Future.delayed(const Duration(milliseconds: 500));
      if ((newNick.length) > minNick) {
        bool flag = await ApiService()
            .modifyNick(Get.find<UserController>().id, newNick);

        if (flag) {
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            confirmBtnColor: text_green_color,
            confirmBtnText: "OK",
            text: "Your Nickname has been saved!",
          );
          Get.find<NickController>().setNick(newNick);
          Get.find<UserController>().setNick(newNick);
        } else {
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            confirmBtnColor: text_green_color,
            text: 'Failed to modify nickname',
          );
        }
      }
    },
  );
}
