import 'package:get/get.dart';

import '../models/ev_vehicles.dart';
import '../utils/constants/api_constants.dart';
import '../utils/constants/route_constants.dart';
import '../utils/helpers/user_pref.dart';
import '../utils/services/api_service.dart';

class ManageEVVehicleController extends GetxController {
  var isLoading = true.obs;
  var dataList = <EvVehicles>[].obs;
  String? userId;

  @override
  Future<void> onInit() async {
    super.onInit();
    userId = await UserPref.getLoginUserId();
    fetchEVVehicles();
  }

  void fetchEVVehicles() async {
    try {
      isLoading(true);
      EvVehicles evVehicles = EvVehicles();
      evVehicles.userId = userId;
      var jsonResponse = await ApiService.postGetData(
        ApiConstants.viewEVVehicles,
        body: evVehicles,
      ) as List;
      dataList.value = jsonResponse.map((e) => EvVehicles.fromJson(e)).toList();
    } finally {
      isLoading(false);
    }
  }

  void addEVVehicles() {
    Get.toNamed(RouteConstants.addUpdateEVVehicles)
        ?.then((value) => fetchEVVehicles());
  }

  void onTapVehicleCard({required EvVehicles evVehicle}) {
    Get.toNamed(
      RouteConstants.addUpdateEVVehicles,
      arguments: evVehicle,
    )?.then((value) => fetchEVVehicles());
  }
}
