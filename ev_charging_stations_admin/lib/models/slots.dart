class Slots {
  late String? slotsId, stationId, voltage, price, status;

  Slots({
    this.slotsId,
    this.stationId,
    this.voltage,
    this.price,
    this.status,
  });

  factory Slots.fromJson(Map<String, dynamic> json) => Slots(
        slotsId: json["slotId"],
        stationId: json["stationId"],
        voltage: json["voltage"],
        price: json["price"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (slotsId != null) {
      data["Slotid"] = slotsId;
    }
    if (stationId != null) {
      data["Stationid"] = stationId;
    }
    if (voltage != null) {
      data["Voltage"] = voltage;
    }
    if (price != null) {
      data["Price"] = price;
    }
    if (status != null) {
      data["Status"] = status;
    }
    return data;
  }
}
