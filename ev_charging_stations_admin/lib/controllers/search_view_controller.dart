import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../models/suggestions.dart';
import '../utils/constants/string_constants.dart';

class SearchViewController extends GetxController {
  final client = Dio();
  late var placeList = <Suggestion>[].obs;
  var isLoading = false.obs;

  Future<dynamic> getPredictions(String input) async {
    var jsonResponse = [];
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String apiKey = StringConstants.googleMapApiKey;

    var _sessionToken = const Uuid().v4();
    String request =
        '$baseURL?input=$input&key=$apiKey&sessiontoken=$_sessionToken';
    var response = await client.get(request);
    if (response.statusCode == 200) {
      var data = response.data;
      for (int i = 0; i < data["predictions"].length; i++) {
        jsonResponse.add(data["predictions"][i]);
      }
    }
    return jsonResponse;
  }

  void getSuggestion(String input) async {
    try {
      isLoading(true);
      var jsonResponse = await getPredictions(input) as List;
      placeList.value =
          jsonResponse.map((e) => Suggestion.fromJson(e)).toList();
    } finally {
      isLoading(false);
    }
  }
}
