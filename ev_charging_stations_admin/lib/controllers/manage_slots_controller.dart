import 'package:get/get.dart';

import '../models/slots.dart';
import '../utils/constants/api_constants.dart';
import '../utils/constants/route_constants.dart';
import '../utils/helpers/common_helper.dart';
import '../utils/helpers/snack_bar_utils.dart';
import '../utils/services/api_service.dart';

class ManageSlotsController extends GetxController {
  var isLoading = true.obs;
  var dataList = <Slots>[].obs;
  late String? stationId;

  @override
  void onInit() {
    super.onInit();
    initObj();
    fetchSlots();
  }

  void initObj() {
    stationId = Get.arguments;
  }

  Future<void> fetchSlots() async {
    try {
      isLoading(true);
      Slots slots = Slots();
      slots.stationId = stationId;
      var jsonResponse = await ApiService.postGetData(
        ApiConstants.viewSlot,
        body: slots,
      ) as List;
      dataList.value = jsonResponse.map((e) => Slots.fromJson(e)).toList();
    } catch (e) {
      CommonHelper.printDebugError(e);
      SnackBarUtils.errorSnackBar(
        title: "ERROR",
        message: "Something went wrong. Please try again later",
      );
    } finally {
      isLoading(false);
    }
  }

  void addSlots() {
    Get.toNamed(
      RouteConstants.addUpdateSlotsScreen,arguments: [stationId]
    )?.then((value) => fetchSlots());
  }

  void onTapSlotCard({required Slots slot}) {
    Get.toNamed(
      RouteConstants.addUpdateSlotsScreen,
      arguments: [stationId, slot],
    )?.then((value) => fetchSlots());
  }
}
