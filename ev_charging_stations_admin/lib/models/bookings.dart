class Bookings {
  late String? bookingId,
      stationId,
      slotId,
      userId,
      vehicleId,
      bookingStatus,
      bookingDate,
      timeIn,
      timeOut,
      amount,
      dateTime,
      stationName,
      userName,
      vehicleName,
      vehicleNumber;

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

  factory Bookings.fromJson(Map<String, dynamic> json) => Bookings(
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
        stationName: json["stationName"],
        userName: json["userName"],
        vehicleName: json["vehicleName"],
        vehicleNumber: json["vehicleNumber"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bookingId != null) {
      data["Bookingid"] = bookingId;
    }
    if (stationId != null) {
      data["stationId"] = stationId;
    }
    if (slotId != null) {
      data["slotId"] = slotId;
    }
    if (userId != null) {
      data["userId"] = userId;
    }
    if (vehicleId != null) {
      data["vehicleId"] = vehicleId;
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
      data["amount"] = amount;
    }
    if (dateTime != null) {
      data["dateTime"] = dateTime;
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
