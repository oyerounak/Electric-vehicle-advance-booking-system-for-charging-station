import 'package:get/get.dart';

import '../../screens/bookings/view_all_users_screen.dart';
import '../../screens/bookings/view_booking_details_screen.dart';
import '../../screens/bookings/view_bookings_screen.dart';
import '../../screens/general/dashboard_screen.dart';
import '../../screens/general/splash_screen.dart';
import '../../screens/login/login_screen.dart';
import '../../screens/manage_stations/add_update_slot_screen.dart';
import '../../screens/manage_stations/add_update_station_screen.dart';
import '../../screens/manage_stations/google_map_view_screen.dart';
import '../../screens/manage_stations/manage_slots_screen.dart';
import '../../screens/manage_stations/manage_stations_screen.dart';
import '../constants/route_constants.dart';

class RouteScreen {
  static final routes = [
    GetPage(
      name: RouteConstants.splashScreen,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: RouteConstants.loginScreen,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: RouteConstants.dashboardScreen,
      page: () => DashBoardScreen(),
    ),
    GetPage(
      name: RouteConstants.manageStationsScreen,
      page: () => ManageStationsScreen(),
    ),
    GetPage(
      name: RouteConstants.addUpdateStationScreen,
      page: () => AddUpdateStationScreen(),
    ),
    GetPage(
      name: RouteConstants.manageSlots,
      page: () => ManageSlotsScreen(),
    ),
    GetPage(
      name: RouteConstants.addUpdateSlotsScreen,
      page: () => AddUpdateSlotsScreen(),
    ),
    GetPage(
      name: RouteConstants.viewBookings,
      page: () => ViewBookingsScreen(),
    ),
    GetPage(
      name: RouteConstants.viewBookingDetails,
      page: () => ViewBookingDetails(),
    ),
    GetPage(
      name: RouteConstants.viewAllUserScreen,
      page: () => ViewAllUsers(),
    ),
    GetPage(
      name: RouteConstants.googleMapViewScreen,
      page: () => GoogleMapViewScreen(),
    ),
  ];
}
