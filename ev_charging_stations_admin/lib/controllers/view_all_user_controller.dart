import 'package:get/get.dart';

import '../models/user_master.dart';
import '../utils/constants/api_constants.dart';
import '../utils/services/api_service.dart';

class ViewAllUserController extends GetxController {
  var isLoading = true.obs;
  var dataList = <UserMaster>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllUsers();
  }

  Future<void> fetchAllUsers() async {
    try {
      isLoading(true);
      var jsonResponse = await ApiService.postGetData(
        ApiConstants.viewAllUser,
        body: {},
      ) as List;
      dataList.value = jsonResponse.map((e) => UserMaster.fromJson(e)).toList();
    } finally {
      isLoading(false);
    }
  }
}
