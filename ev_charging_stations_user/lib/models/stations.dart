class Stations {
  late String? stationId,
      stationName,
      location,
      city,
      kms,
      latLng,
      status,
      type;

  Stations({
    this.stationId,
    this.stationName,
    this.location,
    this.city,
    this.kms,
    this.latLng,
    this.status,
    this.type,
  });

  factory Stations.fromJson(Map<String, dynamic> json) {
    return Stations(
      stationId: json["stationId"],
      stationName: json["stationName"],
      location: json["location"],
      city: json["city"],
      kms: json["Kms"],
      latLng: json["latLng"],
      status: json["status"],
      type: json["type"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (stationId != null) {
      data["StationId"] = stationId;
    }
    if (stationName != null) {
      data["Name"] = stationName;
    }
    if (location != null) {
      data["Location"] = location;
    }
    if (city != null) {
      data["City"] = city;
    }
    if (kms != null) {
      data["Kms"] = kms;
    }
    if (latLng != null) {
      data["Latlng"] = latLng;
    }
    if (status != null) {
      data["Status"] = status;
    }
    if (type != null) {
      data["Type"] = type;
    }
    return data;
  }
}
