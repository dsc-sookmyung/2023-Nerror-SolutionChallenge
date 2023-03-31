class MailCategory {
  String? category;
  List<Mails>? mails;
  bool isExpanded = false;
  bool isChecked = false;

  MailCategory(
      {this.category,
      this.mails,
      this.isExpanded = false,
      this.isChecked = false});

  MailCategory.fromJson(Map<String, dynamic> json) {
    category = json["category"];
    if (json["smartScanResult"] != null) {
      mails = <Mails>[];
      json["smartScanResult"].forEach((v) {
        mails!.add(Mails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["category"] = category;
    if (mails != null) {
      data["smartScanResult"] = mails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Mails {
  late int id;
  late int msgNum;
  late int msgId;
  late String sender;
  late String subject;
  late String contents;
  late String tag;
  late String recivedDate;
  late String username;
  bool isChecked = false;

  //       "attachmentSize": 0,
  //       "attachments": [],

  Mails(
      {required this.id,
      required this.msgId,
      required this.msgNum,
      required this.sender,
      required this.subject,
      required this.contents,
      required this.tag,
      required this.recivedDate,
      required this.username,
      this.isChecked = true});

  Mails.fromJson(Map<String, dynamic> json) {
    id = json['mailId'];
    msgNum = json['mgsNum'];
    msgId = json['msgId'];
    sender = json['sender'];
    subject = json['subject'];
    contents = json['contents'].toString();
    tag = json['tag'];
    recivedDate = json['recivedDate'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mailId'] = id;
    data['mgsNum'] = msgNum;
    data['msgId'] = msgId;
    data['author'] = sender;
    data['subject'] = subject;
    data['contents'] = contents;
    data['tag'] = tag;
    data['recivedDate'] = recivedDate;
    data['username'] = username;
    return data;
  }
}
