class RoadMapSteps {

  late String? latLng;

  RoadMapSteps({this.latLng});

  factory RoadMapSteps.fromJson(Map<String, dynamic> json) {
    return RoadMapSteps(
      latLng: json["Latlng"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (latLng != null) {
      data["Latlng"] = latLng;
    }
    return data;
  }
}
