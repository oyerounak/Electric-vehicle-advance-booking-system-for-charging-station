class EvVehicles {
  late String? vehicleId;
  late String? userId;
  late String? vehicleName;
  late String? vehicleNumber;

  EvVehicles({
    this.vehicleId,
    this.userId,
    this.vehicleName,
    this.vehicleNumber,
  });

  factory EvVehicles.fromJson(Map<String, dynamic> json) {
    return EvVehicles(
      vehicleId: json["vehicleId"],
      userId: json["UserId"],
      vehicleName: json["vehicleName"],
      vehicleNumber: json["vehicleNumber"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (vehicleId != null) {
      data["Vid"] = vehicleId;
    }
    if (userId != null) {
      data["Uid"] = userId;
    }
    if (vehicleName != null) {
      data["VName"] = vehicleName;
    }
    if (vehicleNumber != null) {
      data["VNumber"] = vehicleNumber;
    }
    return data;
  }
}
