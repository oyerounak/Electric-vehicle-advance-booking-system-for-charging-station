class Stations {
  late String? stationId, stationName, location, city, latLng, status;

  Stations({
    this.stationId,
    this.stationName,
    this.location,
    this.city,
    this.latLng,
    this.status,
  });

  factory Stations.fromJson(Map<String, dynamic> json) => Stations(
        stationId: json["stationId"],
        stationName: json["stationName"],
        location: json["location"],
        city: json["city"],
        latLng: json["latLng"],
        status: json["status"],
      );

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
    if (latLng != null) {
      data["Latlng"] = latLng;
    }
    if (status != null) {
      data["Status"] = status;
    }
    return data;
  }
}
