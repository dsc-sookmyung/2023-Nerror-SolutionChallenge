import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../models/mail_category.dart';

class UserController extends GetxController {
  String _id = "";
  String _nick = "";
  String _pw = "";
  String _accessToken = "";
  String _refreshToken = "";
  int _deleteCount = 0;
  int _totalCount = 0;
  int _currentLevel = 0;
  List<int> _badges = [];
  List<dynamic> _mailAccounts = [];
  List<MailCategory> _mailCategory = [];

  get id => _id;
  get nick => _nick;
  get pw => _pw;
  get accessToken => _accessToken;
  get refreshToken => _refreshToken;
  get deleteCount => _deleteCount;
  get totalCount => _totalCount;
  get currentLevel => _currentLevel;
  get badges => _badges;
  get mailAccounts => _mailAccounts;
  get mailCategory => _mailCategory;

  void upadateUserInform(
      {required String id,
      required String nick,
      required String pw,
      required String accessToken,
      required String refreshToken,
      required int deleteCount,
      required int totalCount,
      required int currentLevel,
      required List<int> badges,
      required List<dynamic> mailAccounts,
      required List<MailCategory> mailCategory}) {
    _id = id;
    _nick = nick;
    _pw = pw;
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _deleteCount = deleteCount;
    _totalCount = totalCount;
    _currentLevel = currentLevel;
    _badges = badges;
    _mailAccounts = mailAccounts;
    _mailCategory = mailCategory;
    update();
  }

  void setNick(String nick) {
    _nick = nick;
    update();
  }

  void setTotalCount(int total) {
    _totalCount = total;
    update();
  }

  void deleteAccount(String account) {
    _mailAccounts.remove(account);
    update();
  }

  void setMailAccounts(List<dynamic> accounts) {
    _mailAccounts = accounts;
    update();
  }

  void setMailCategory(List<MailCategory> mails) {
    _mailCategory = mails;
    update();
  }

  void setBadges(List<int> badgeList) {
    _badges = badgeList;
    update();
  }

  void setDeleteCount(int delete) {
    _deleteCount = delete;
    update();
  }

  void setLevel(int lv) {
    _currentLevel = lv;
    update();
  }

  void setTotalCount(int total) {
    _totalCount = total;
    update();
  }
}
