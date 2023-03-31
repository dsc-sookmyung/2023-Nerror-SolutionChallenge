import 'package:get/get.dart';

class CountController extends GetxController {
  final _deleteCount = 0.obs;
  final _totalCount = 0.obs;
  final _currentLevel = 0.obs;

  get deleteCount => _deleteCount;
  get totalCount => _totalCount;
  get currentLevel => _currentLevel;

  void setDeleteCount(int deleteCount) {
    _deleteCount.value = deleteCount;
    update();
  }

  void setTotalCount(int totalCount) {
    _totalCount.value = totalCount;
    update();
  }

  void setLevel(int level) {
    _currentLevel.value = level;
    update();
  }
}
