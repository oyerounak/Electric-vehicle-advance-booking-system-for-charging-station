import 'package:get_storage/get_storage.dart';

import '../constants/string_constants.dart';
import 'common_helper.dart';

class UserPref {
  static final getStorage = GetStorage();

  static void setLoginUserName(userName) async {
    await getStorage.write(StringConstants.loggedInUserName, userName);
  }

  static Future<String> getLoginUserName() async {
    try {
      return await getStorage.read(StringConstants.loggedInUserName) ?? "";
    } catch (e) {
      CommonHelper.printDebugError(e);
    }
    return "";
  }

  static void setLoginUserId(userId) async {
    await getStorage.write(StringConstants.loggedInUserId, userId);
  }

  static Future<String> getLoginUserId() async {
    try {
      return await getStorage.read(StringConstants.loggedInUserId) ?? "";
    } catch (e) {
      CommonHelper.printDebugError(e);
    }
    return "";
  }

  static void setLoginStatus(status) async {
    await getStorage.write(StringConstants.isLoggedIn, status);
  }

  static Future<bool> getLoginStatus() async {
    try {
      return await getStorage.read(StringConstants.isLoggedIn) ?? false;
    } catch (e) {
      CommonHelper.printDebugError(e);
    }
    return false;
  }

  static void removeAllFromUserPref() async {
    try {
      return await getStorage.erase();
    } catch (e) {
      CommonHelper.printDebugError(e);
    }
  }
}
