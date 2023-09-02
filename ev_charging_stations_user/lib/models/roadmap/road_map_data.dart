import 'road_map_steps.dart';

class RoadMapData {
  late List<RoadMapSteps>? steps;

  RoadMapData({this.steps});

  factory RoadMapData.fromJson(Map<String, dynamic> json) {
    return RoadMapData(
      steps: json["Steps"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (steps != null) {
      data["Steps"] = steps;
    }
    return data;
  }
}
