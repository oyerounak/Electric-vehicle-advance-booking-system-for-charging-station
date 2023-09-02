import 'dart:convert';

class AdminMaster {
  late String? adminId;
  late String? emailId;
  late String? password;
  late String? status;

  AdminMaster({
    this.adminId,
    this.emailId,
    this.password,
    this.status,
  });

  factory AdminMaster.fromJson(Map<String, dynamic> json) {
    return AdminMaster(
      adminId: json["adminId"],
      emailId: json["Email"],
      password: json["Password"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (adminId != null) {
      data["adminId"] = adminId;
    }
    if (emailId != null) {
      data["Email"] = emailId;
    }
    if (password != null) {
      data["Password"] = password;
    }
    if (status != null) {
      data["status"] = status;
    }
    return data;
  }
}
