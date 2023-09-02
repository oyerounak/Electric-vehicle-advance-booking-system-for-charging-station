class Bookings {
  late String? bookingId;
  late String? stationId;
  late String? slotId;
  late String? userId;
  late String? vehicleId;
  late String? bookingStatus;
  late String? bookingDate;
  late String? timeIn;
  late String? timeOut;
  late String? amount;
  late String? dateTime;
  late String? stationName;
  late String? userName;
  late String? vehicleName;
  late String? vehicleNumber;

  Bookings({
    this.bookingId,
    this.stationId,
    this.slotId,
    this.userId,
    this.vehicleId,
    this.bookingStatus,
    this.bookingDate,
    this.timeIn,
    this.timeOut,
    this.amount,
    this.dateTime,
    this.stationName,
    this.userName,
    this.vehicleName,
    this.vehicleNumber,
  });

  factory Bookings.fromJson(Map<String, dynamic> json) {
    return Bookings(
      bookingId: json["bookingId"],
      stationId: json["stationId"],
      slotId: json["slotId"],
      userId: json["userId"],
      vehicleId: json["vehicleId"],
      bookingStatus: json["bookingStatus"],
      bookingDate: json["bookingDate"],
      timeIn: json["timeIn"],
      timeOut: json["timeOut"],
      amount: json["Amount"],
      dateTime: json["dateTime"],
      stationName: json["Column1"],
      userName: json["userName"],
      vehicleName: json["Column2"],
      vehicleNumber: json["Column3"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bookingId != null) {
      data["Bid"] = bookingId;
    }
    if (stationId != null) {
      data["StationId"] = stationId;
    }
    if (slotId != null) {
      data["Slotid"] = slotId;
    }
    if (userId != null) {
      data["Uid"] = userId;
    }
    if (vehicleId != null) {
      data["Vid"] = vehicleId;
    }
    if (bookingStatus != null) {
      data["bookingStatus"] = bookingStatus;
    }
    if (bookingDate != null) {
      data["Date"] = bookingDate;
    }
    if (timeIn != null) {
      data["timeIn"] = timeIn;
    }
    if (timeOut != null) {
      data["timeOut"] = timeOut;
    }
    if (amount != null) {
      data["Amount"] = amount;
    }
    if (dateTime != null) {
      data["DT"] = dateTime;
    }
    if (stationName != null) {
      data["stationName"] = stationName;
    }
    if (userName != null) {
      data["userName"] = userName;
    }
    if (vehicleName != null) {
      data["vehicleName"] = vehicleName;
    }
    if (vehicleNumber != null) {
      data["vehicleNumber"] = vehicleNumber;
    }
    return data;
  }
}
