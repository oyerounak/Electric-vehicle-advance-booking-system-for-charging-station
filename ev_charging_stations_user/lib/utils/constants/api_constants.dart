class ApiConstants {
  static const String _baseUrl = "http://aevstations.hostoise.com/api/User";

  static const String post = "Post";

  static const String userLogin = "$_baseUrl/Login";
  static const String userRegistration = "$_baseUrl/Register";
  static const String viewUserProfile = "$_baseUrl/ViewProfile";
  static const String updateUserProfile = "$_baseUrl/UpdateProfile";
  static const String changePassword = "$_baseUrl/ChangePassword";
  static const String viewEVVehicles = "$_baseUrl/ViewVehicle";
  static const String addEVVehicles = "$_baseUrl/AddVehicle";
  static const String updateEVVehicles = "$_baseUrl/UpdateVehicle";
  static const String deleteEVVehicles = "$_baseUrl/DeleteVehicle";
  static const String viewStation = "$_baseUrl/ViewStation";
  static const String viewSlot = "$_baseUrl/ViewSlots";
  static const String bookSlot = "$_baseUrl/BookSlot";
  static const String viewBookings = "$_baseUrl/ViewBookings";
  static const String cancelBookings = "$_baseUrl/CancelBooking";
  static const String roadMap = "$_baseUrl/getRoadmap";
}
