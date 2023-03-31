import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:marbon/service/api_service.dart';
import 'package:marbon/size.dart';
import 'package:provider/provider.dart';

import '../../color.dart';
import '../../controller/userController.dart';
import '../../models/mail_category.dart';

class SmartScanDetail extends StatefulWidget {
  const SmartScanDetail({super.key});

  @override
  State<SmartScanDetail> createState() => _SmartScanDetailState();
}

var logger = Logger();

class _SmartScanDetailState extends State<SmartScanDetail> {
  // smartsan에서 인자로 보낸 mailcategorys 를 mail이라고 할것임
  //final List<MailCategory> _mails = generateMailCategory(jsonMailData1);
  final List<dynamic> accounts = Get.find<UserController>().mailAccounts;
  final List<MailCategory> mails = Get.find<UserController>().mailCategory;
  int mailCount = 0;

  @override
  void initState() {
    context.read<Checks>().settingMap(accounts);
    for (int i = 0; i < mails.length; i++) {
      mailCount += mails.elementAt(i).mails!.length;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        shadowColor: transparent_color,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: text_green_color,
        ),
        actions: <Widget>[
          IconButton(
              // 선택 전부 취소
              onPressed: () {
                //체크박스 전부 취소되도록
                setState(() {
                  // 카테고리 안의 메일들을 하나씩 돌면서 모두 추가
                  for (int i = 0; i < mails.length; i++) {
                    for (int j = 0; j < mails.elementAt(i).mails!.length; j++) {
                      mails.elementAt(i).mails!.elementAt(j).isChecked = false;
                    }
                    mails.elementAt(i).isChecked = false;
                  }
                  context.read<Checks>().settingMap(accounts);
                });
              },
              icon: const Icon(Icons.cancel_presentation_outlined)),
          IconButton(
              // 선택 삭제
              onPressed: () {
                //  context.read<Checks> 에 있는 값들 삭제요청 보낸 후 안의 data값 삭제
                int totalDelete = 0;
                bool pass = true;
                context.read<Checks>()._data.forEach((key, value) async {
                  totalDelete += value.length;
                  bool flag =
                      await ApiService().postSmartScanDelete(key, value);
                  if (!flag) {
                    pass = false;
                  }
                });
                if (pass) {
                  Navigator.pushNamed(context, "/smartscan_delete",
                      arguments: {"totalDelete": totalDelete});
                } else {
                  logger.d("삭제 실패");
                }
              },
              icon: const Icon(Icons.check_box_outlined)),
          IconButton(
              // 전체 삭제
              onPressed: () {
                setState(() {
                  // 카테고리 안의 메일들을 하나씩 돌면서 모두 추가
                  for (int i = 0; i < mails.length; i++) {
                    for (int j = 0; j < mails.elementAt(i).mails!.length; j++) {
                      context.read<Checks>().addItem(
                          mails.elementAt(i).mails!.elementAt(j).username,
                          mails.elementAt(i).mails!.elementAt(j).id);
                    }
                  }
                });
                bool pass = true;
                context.read<Checks>()._data.forEach((key, value) async {
                  bool flag =
                      await ApiService().postSmartScanDelete(key, value);
                  if (!flag) {
                    pass = false;
                  }
                });
                if (pass) {
                  Navigator.pushNamed(context, "/smartscan_delete",
                      arguments: {"totalDelete": mailCount});
                } else {
                  logger.d("삭제 실패");
                }
              },
              icon: const Icon(Icons.delete_forever)),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity, // 주지않으면 텍스트의 크기와 동일해짐
            padding: const EdgeInsets.only(
              top: 40,
              left: smartscan_title_left,
            ),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Smartscan",
                  style: TextStyle(
                    color: text_green_color,
                    fontSize: 35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "총 $mailCount건의 메일이 발견되었습니다.",
                  style: const TextStyle(
                    color: text_green_color,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: yellow_color,
            child: Container(
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(50.0),
                ),
              ),
            ),
          ),
          Expanded(
            // Vertical viewport was given unbounded height error 방지
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    _buildExpansionPanel(),
                    Container(
                      // 위쪽커브
                      color: color_list[3],
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: color_list[4],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50.0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: color_list[4],
                      height: 90,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionPanel() {
    int headerIndex = 0;
    int contentIndex = 0;

    return ExpansionPanelList(
      // ExpansionPanel의 gap을 줄이기 위함 (위쪽gap)
      expandedHeaderPadding: const EdgeInsets.only(
        bottom: 1,
      ),
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          mails[index].isExpanded = !isExpanded;
        });
      },
      children: mails.map<ExpansionPanel>((MailCategory mailCategory) {
        contentIndex += 1;
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            headerIndex += 1;
            return Column(
              children: [
                Container(
                  // 위쪽커브
                  color: color_list[headerIndex - 1],
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: color_list[headerIndex],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50.0),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  color: color_list[headerIndex],
                  padding: const EdgeInsets.only(left: 10, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          Checkbox(
                              value: mailCategory.isChecked,
                              onChanged: (value) {
                                setState(() {
                                  // 체크여부 변동
                                  mailCategory.isChecked = value!;

                                  // 체크상태 업데이트
                                  if (mailCategory.isChecked) {
                                    //카테고리 전체선택
                                    for (int i = 0;
                                        i < mailCategory.mails!.length;
                                        i++) {
                                      context.read<Checks>().addItem(
                                            mailCategory.mails!
                                                .elementAt(i)
                                                .username,
                                            mailCategory.mails!.elementAt(i).id,
                                          );
                                      mailCategory.mails!
                                          .elementAt(i)
                                          .isChecked = true;
                                    }
                                  } else {
                                    // 메일 카테고리 전체 삭제
                                    for (int i = 0;
                                        i < mailCategory.mails!.length;
                                        i++) {
                                      context.read<Checks>().removeItem(
                                            mailCategory.mails!
                                                .elementAt(i)
                                                .username,
                                            mailCategory.mails!.elementAt(i).id,
                                          );
                                      mailCategory.mails!
                                          .elementAt(i)
                                          .isChecked = false;
                                    }
                                  }
                                });
                              }),
                          Text(
                            mailCategory.category!,
                            style: const TextStyle(
                                color: text_green_color,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 70,
                        child: Text(
                          mailCategory.mails!.length.toString(), // 메일 총 갯수
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: text_green_color,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // 아랫쪽커브
                  color: color_list[headerIndex + 1],
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: color_list[headerIndex],
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(50.0),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          body: Container(
              // 받은 색상으로 해야함
              color: color_list[contentIndex],
              height: mail_list_height * 4,
              child: ListView(
                scrollDirection: Axis.vertical,
                // mailCategory.mails 는 리스트이고 이걸 반복하면서 mailitem에 넣어야함
                children: mailCategory.mails!
                    .map((m) => _buildMailItem(m, mailCategory))
                    .toList(),
              )),
          isExpanded: mailCategory.isExpanded,
          canTapOnHeader: true,
        );
      }).toList(),
    );
  }

  // 카테고리별 메일내용
  Widget _buildMailItem(Mails mails, MailCategory mc) {
    return Container(
      height: mail_list_height,
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              Checkbox(
                value: mails.isChecked,
                onChanged: (value) {
                  setState(() {
                    // 체크여부 변동
                    mails.isChecked = value!;

                    // 체크상태 업데이트
                    if (mails.isChecked) {
                      // 해당 메일 체크 및 전체 체크면 카테고리의 체크도 킬 것 & provider의 값 조정
                      context.read<Checks>().addItem(mails.username, mails.id);
                      var flag = true;
                      for (int i = 0; i < mc.mails!.length; i++) {
                        if (mc.mails!.elementAt(i).isChecked == false) {
                          flag = false;
                          break;
                        }
                      }
                      mc.isChecked = flag ? true : false;
                    } else {
                      // 해당 메일의 체크 끄고 카테고리의 체크도 끌 것  & provider의 값 조정
                      context
                          .read<Checks>()
                          .removeItem(mails.username, mails.id);
                      mc.isChecked = false;
                    }
                  });
                },
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mails.sender,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: text_green_color,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(mails.subject,
                        style: const TextStyle(
                            fontSize: 15,
                            color: text_green_color,
                            fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    // (mails.contents) != null
                    //     ? Text(mails.contents,
                    //         style: const TextStyle(
                    //           fontSize: 15,
                    //           color: placeholder_color,
                    //         ),
                    //         overflow: TextOverflow.ellipsis)
                    //     : const SizedBox()
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

// json 형태의 자료를 mailCategory 모델로 변환
List<MailCategory> generateMailCategory(List<dynamic> mailDatas) {
  List<MailCategory> mailCategories = [];

  for (var mailData in mailDatas) {
    // json을 웹툰 인스턴스로 만들어주는 코드
    mailCategories.add(MailCategory.fromJson(mailData));
  }
  return mailCategories;
}

// 메일 체크시 구현되어야 할 기능 구현
class Checks extends ChangeNotifier {
  Map<String, List<int>> data =
      {}; // data 형태는 {username1:[해당 메일 선택리스트], username2:[해당 메일 선택 리스트]}

  bool _disposed = false; // 메모리 해제
  Map<String, List<int>> get _data => data;

  // 메모리 누수 방지
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  // 메모리 해제가 아닐시 notifyListeners 호출
  @override
  notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  void settingMap(accountList) {
    for (String username in accountList) {
      data[username] = [];
    }
  }

  // 메일 선택 추가 (data에 없는 경우만 mail 리스트에 추가)
  void addItem(String username, int value) {
    // data에 없는 경우에만 mail리스트에 추가
    var flag = data[username]!.contains(value);
    if (!flag) {
      data[username]!.add(value);
      notifyListeners();
    }
  }

  // 메일 선택 해제 (data에 있을경우)
  void removeItem(String username, int value) {
    var flag = data[username]!.contains(value);
    if (flag) {
      data[username]!.remove(value);
    }
    notifyListeners();
  }

  // 메일 선택 전체 해제
  void clearItem() {
    data.clear();
    notifyListeners();
  }
}
