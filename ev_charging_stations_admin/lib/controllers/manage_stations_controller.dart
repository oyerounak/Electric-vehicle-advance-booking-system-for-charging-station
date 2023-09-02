import 'package:get/get.dart';

import '../models/stations.dart';
import '../utils/constants/api_constants.dart';
import '../utils/constants/route_constants.dart';
import '../utils/helpers/snack_bar_utils.dart';
import '../utils/services/api_service.dart';

class ManageStationsController extends GetxController {
  var isLoading = true.obs;
  var dataList = <Stations>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchStations();
  }

  void addStation() {
    Get.toNamed(
      RouteConstants.addUpdateStationScreen,
    )?.then((value) => fetchStations());
  }

  Future<void> fetchStations() async {
    try {
      isLoading(true);
      var jsonResponse = await ApiService.postGetData(
        ApiConstants.viewStation,
        body: {},
      ) as List;
      dataList.value = jsonResponse.map((e) => Stations.fromJson(e)).toList();
    } catch (e) {
      SnackBarUtils.errorSnackBar(
        title: "ERROR",
        message: "Something went wrong. Please try again later",
      );
    } finally {
      isLoading(false);
    }
  }

  void onTapStationCard({required Stations station}) {
    Get.toNamed(
      RouteConstants.addUpdateStationScreen,
      arguments: station,
    )?.then((value) {
      fetchStations();
    });
  }
}
