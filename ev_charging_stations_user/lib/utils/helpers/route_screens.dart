import 'package:get/get.dart';

import '../../screens/bookings/google_map_view_road_map.dart';
import '../../screens/bookings/view_booking_details_screen.dart';
import '../../screens/bookings/view_bookings_screen.dart';
import '../../screens/ev_vehicles/add_update_ev_vehicles_screen.dart';
import '../../screens/ev_vehicles/manage_ev_vehicles_screen.dart';
import '../../screens/find_stations/find_stations_screen.dart';
import '../../screens/find_stations/manage_slots_screen.dart';
import '../../screens/general/dashboard_screen.dart';
import '../../screens/general/profile_screen.dart';
import '../../screens/general/splash_screen.dart';
import '../../screens/login/login_screen.dart';
import '../../screens/login/registration_screen.dart';
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
      name: RouteConstants.registrationScreen,
      page: () => RegistrationScreen(),
    ),
    GetPage(
      name: RouteConstants.dashboardScreen,
      page: () => DashBoardScreen(),
    ),
    GetPage(
      name: RouteConstants.profileScreen,
      page: () => ProfileScreen(),
    ),
    GetPage(
      name: RouteConstants.manageEVVehicles,
      page: () => ManageEVVehicles(),
    ),
    GetPage(
      name: RouteConstants.addUpdateEVVehicles,
      page: () => AddUpdateEVVehicles(),
    ),
    GetPage(
      name: RouteConstants.findStations,
      page: () => FindStationsScreen(),
    ),
    GetPage(
      name: RouteConstants.manageSlots,
      page: () => ManageSlotsScreen(),
    ),
    GetPage(
      name: RouteConstants.viewBookings,
      page: () => ViewBookingsScreen(),
    ),
    GetPage(
      name: RouteConstants.viewBookingDetails,
      page: () => ViewBookingDetailsScreen(),
    ),
    GetPage(
      name: RouteConstants.googleMapViewRoadMap,
      page: () => GoogleMapViewGoogleMap(),
    ),
  ];
}
