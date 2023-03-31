import 'package:get/get.dart';

class NickController extends GetxController {
  var nick = "Song Kim".obs;

  void setNick(String newNick) {
    nick.value = newNick;
    update();
  }
}
