import 'package:ev_charging_stations_user/models/stations.dart';

import 'road_map_data.dart';

class RoadMap {
  late String? source;
  late String? destination;
  late String? km;
  late RoadMapData? roadMapData;

  RoadMap({
    this.source,
    this.destination,
    this.km,
    this.roadMapData,
  });

  factory RoadMap.fromJson(Map<String, dynamic> json) {
    return RoadMap(
      source: json["Source"],
      destination: json["Destination"],
      km: json["Km"],
      roadMapData: json["Data"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (source != null) {
      data["Source"] = source;
    }
    if (destination != null) {
      data["Destination"] = destination;
    }
    if (km != null) {
      data["Km"] = km;
    }
    if (roadMapData != null) {
      data["Data"] = roadMapData;
    }
    return data;
  }
}
