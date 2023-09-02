class UserMaster {
  late String? userId;
  late String? userName;
  late String? emailId;
  late String? contact;
  late String? password;

  UserMaster({
    this.userId,
    this.userName,
    this.emailId,
    this.contact,
    this.password,
  });

  factory UserMaster.fromJson(Map<String, dynamic> json) => UserMaster(
        userId: json["userId"],
        userName: json["userName"],
        emailId: json["emailId"],
        contact: json["contact"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userId != null) {
      data["userId"] = userId;
    }
    if (userName != null) {
      data["userName"] = userName;
    }
    if (emailId != null) {
      data["Email"] = emailId;
    }
    if (contact != null) {
      data["contact"] = contact;
    }
    if (password != null) {
      data["Password"] = password;
    }
    return data;
  }
}
