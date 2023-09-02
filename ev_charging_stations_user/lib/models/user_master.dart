import 'dart:convert';

class UserMaster {
  late String? userId;
  late String? userName;
  late String? emailId;
  late String? contact;
  late String? password, oldPassword, newPassword;
  late String? status;

  UserMaster({
    this.userId,
    this.userName,
    this.emailId,
    this.contact,
    this.password,
    this.oldPassword,
    this.newPassword,
    this.status,
  });

  factory UserMaster.fromJson(Map<String, dynamic> json) {
    return UserMaster(
      userId: json["userid"],
      userName: json["userName"],
      emailId: json["emailId"],
      contact: json["contact"],
      password: json["password"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userId != null) {
      data["Uid"] = userId;
    }
    if (userName != null) {
      data["Name"] = userName;
    }
    if (emailId != null) {
      data["Email"] = emailId;
    }
    if (contact != null) {
      data["Contact"] = contact;
    }
    if (password != null) {
      data["Password"] = password;
    }
    if (oldPassword != null) {
      data["OldPassword"] = oldPassword;
    }
    if (newPassword != null) {
      data["NewPassword"] = newPassword;
    }
    return data;
  }
}
