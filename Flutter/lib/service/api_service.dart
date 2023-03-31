import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../models/mail_category.dart';

var logger = Logger();

class ApiService {
  static const String baseUrl = " https://localhost:8080/api/v1";

  // Post Login
  Future<dynamic> postLogin(String email, password) async {
    try {
      final url = Uri.parse('$baseUrl/auth/login');
      final response = await http.post(
        url,
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          'Accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "id": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        var head = response.headers;
        String accessToken = head["access_token"].toString();
        String refreshToken = head["refresh_token"].toString();

        // 뱃지 정보를 리스트로 가공
        List<int> badgeList = [0, 0, 0, 0, 0, 0];
        var badgeMatch = [
          "MAIL_RICH",
          "STARTERS",
          "ENVIRONMENTAL_MODEL",
          "ENVIRONMENTAL_TUTELARY",
          "EARTH_TUTELARY",
          "MARBON_MARATHONER"
        ];

        if (data["badge"] != null) {
          for (String bg in data["badge"]) {
            badgeList[badgeMatch.indexOf(bg)] = 1;
          }
        }
        logger.d(data);
        return {
          "flag": true,
          "id": data['id'],
          "nick": data['nickname'],
          "pw": data['password'],
          "deletedCount": data["deletedCount"],
          "totalCount": data['totalCount'],
          "currentLevel": data['currentLevel'],
          "mailAccounts": data["accountList"],
          "badgeList": badgeList,
          "accessToken": accessToken,
          "refreshToken": refreshToken
        };
      } else {
        logger.d('등록되지 않은 이메일이거나 틀린 번호입니다');
        return {"flag": false};
      }
    } catch (e) {
      logger.d(e.toString());
      return {"flag": false};
    }
  }

  // Post Signup
  Future<dynamic> postSignup(String email, password, nickname) async {
    try {
      final url = Uri.parse('$baseUrl/auth/signup');
      final response = await http.post(
        url,
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          'Accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "id": email,
          "password": password,
          "nickname": nickname,
        }),
      );

      if (response.statusCode == 200) {
        var head = response.headers;
        String accessToken = head["access_token"].toString();
        String refreshToken = head["refresh_token"].toString();
        logger.d(jsonDecode(response.body.toString()));
        return {"accessToken": accessToken, "refreshToken": refreshToken};
      } else if (response.statusCode == 409) {
        logger.d("중복 닉네임 혹은 이미 가입되어 있음");
        return {"accessToken": "", "refreshToken": ""};
      } else {
        logger.d('오류 ${response.statusCode}');
        return {"accessToken": "", "refreshToken": ""};
      }
    } catch (e) {
      logger.d(e.toString());
    }
  }

  // 이메일 인증 요청 (로그 나오는거 보고 리턴값 String으로 변환할것 Future<String>으로)
  Future<dynamic> postEmail(String email) async {
    try {
      final url = Uri.parse('$baseUrl/auth/confirm');
      final response = await http.post(
        url,
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          'Accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            "email": email,
          },
        ),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        logger.d(data["AuthenticationCode"]);
        return data["AuthenticationCode"];
      } else {
        logger.d((response.body).toString());
        return "";
      }
    } catch (e) {
      logger.d("Error : ${e.toString()}");
    }
  }

  Future<bool> modifyPassword(String email, password) async {
    try {
      final url = Uri.parse('$baseUrl/auth/modify/pw');
      final response = await http.post(
        url,
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          'Accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "id": email.toString(),
          "password": password.toString(),
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        logger.d('오류 ${response.statusCode}');
        return false;
      }
    } catch (e) {
      logger.d(e.toString());
      return false;
    }
  }

  Future<bool> modifyNick(String email, nick) async {
    try {
      final url = Uri.parse('$baseUrl/auth/modify/nickname');
      final response = await http.post(
        url,
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          'Accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "id": email,
          "nickname": nick,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        logger.d('오류 ${response.statusCode}');
        return false;
      }
    } catch (e) {
      logger.d(e.toString());
      return false;
    }
  }

  // MyPage 이메일 계정 추가 API
  Future<dynamic> addMail(String email, username, password, host, port) async {
    try {
      final url = Uri.parse('$baseUrl/mailbox/add');
      final response = await http.post(
        url,
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          'Accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            "id": email,
            "username": username,
            "password": password,
            "host": host,
            "port": port,
          },
        ),
      );
      // addmail  응답 리턴 -> accountList totalCount 받아와서 갱신
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));

        var accountList =
            data["accountList"]; //List<String>의 값을 accountList에 넣어주어야함
        return {"accountList": accountList};
      } else {
        logger.d('오류 ${response.statusCode}');
        return {"accountList": []};
      }
    } catch (e) {
      logger.d("Error : ${e.toString()}");
    }
  }

  // 메일 수신 및 저장 ---> 메일 회사 추가할때 수행할 것
  Future<dynamic> getSaveMail(
      String email, username, password, host, port) async {
    try {
      final url = Uri.parse('$baseUrl/mailbox/save?id=$email');
      // 안돼면 헤더 붙이기
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return {"flag": true, "totalCount": data["totalCount"]};
      } else {
        logger.d('오류 ${response.statusCode}');
        return {"flag": false};
      }
    } catch (e) {
      logger.d(e.toString());
      return {"flag": false};
    }
  }

  Future<bool> deleteMailAccount(String deleteMail) async {
    try {
      final url =
          Uri.parse('$baseUrl/mailbox/deleteMailbox?username=$deleteMail');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        logger.d(response.body.toString());
        return true;
      } else {
        logger.d('오류 ${response.statusCode}');
        return false;
      }
    } catch (e) {
      logger.d(e.toString());
      return false;
    }
  }

  // 스마트 스캔 수행
  Future<dynamic> getSmartScan(String id) async {
    try {
      final url = Uri.parse('$baseUrl/scan?id=$id');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        List<MailCategory> mailCategories = [];
        for (var mailData in data) {
          mailCategories.add(MailCategory.fromJson(mailData));
        }

        return mailCategories;
      } else {
        logger.d('오류 ${response.statusCode}');
        return [];
      }
    } catch (e) {
      logger.d(e.toString());
      return [];
    }
  }

  // 스마트스캔 후 메일 삭제 요청
  Future<bool> postSmartScanDelete(
      String userName, List<int> deleteMailList) async {
    try {
      final url = Uri.parse('$baseUrl/scan/delete');
      final response = await http.post(
        url,
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          'Accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            "username": userName,
            "deleteIdList": deleteMailList,
          },
        ),
      );

      if (response.statusCode == 200) {
        logger.d(response.body.toString());
        return true;
      } else {
        logger.d((response.body).toString());
        return false;
      }
    } catch (e) {
      logger.d("Error : ${e.toString()}");
      return false;
    }
  }

  // 새로고침  --> 계정과 연결된 새로운 메일 모두 수신 (로그인시 실행할 것)
  Future<dynamic> getRefresh(String id) async {
    try {
      final url = Uri.parse('$baseUrl/mailbox/refresh?id=$id');
      final response = await http.get(url);

      logger.d("refreshdata => ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        logger.d("refreshdata => $data");
        return {
          "flag": true,
          "deletedCount": data["deletedCount"],
          "currentLevel": data["currentLevel"],
          "totalCount": data["totalCount"]
        };
      } else {
        logger.d('오류 ${response.statusCode}');
        return {"flag": false};
      }
    } catch (e) {
      logger.d(e.toString());
      return {"flag": false};
    }
  }
}
