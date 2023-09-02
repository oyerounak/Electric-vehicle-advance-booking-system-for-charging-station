import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/dashboard_controller.dart';
import '../../utils/constants/dimens_constants.dart';
import '../../utils/constants/string_constants.dart';
import '../../utils/custom_widgets/common_scaffold.dart';

class DashBoardScreen extends StatelessWidget {
  DashBoardScreen({Key? key}) : super(key: key);

  final DashboardController _controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: AppBar(
        title: const Text("DASHBOARD"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _controller.onPressLogout(),
            icon: const Icon(Icons.logout_outlined),
          )
        ],
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(DimenConstants.contentPadding),
          padding: const EdgeInsets.all(DimenConstants.contentPadding),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: _cardView(
                  stringText: "Manage Station",
                  stringImagePath: StringConstants.manageStations,
                  onTap: () => _controller.onTapManageStation(),
                ),
              ),
              Expanded(
                flex: 1,
                child: _cardView(
                  stringText: "View Booking",
                  stringImagePath: StringConstants.bookings,
                  onTap: () => _controller.onTapViewBooking(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardView({stringText, stringImagePath, onTap}) {
    return Card(
      elevation: DimenConstants.textFieldCardElevation,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(DimenConstants.buttonCornerRadius),
        ),
      ),
      margin: const EdgeInsets.all(DimenConstants.layoutPadding),
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(
          Radius.circular(DimenConstants.buttonCornerRadius),
        ),
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(DimenConstants.contentPadding),
          padding: const EdgeInsets.all(DimenConstants.contentPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Image(
                  image: AssetImage(stringImagePath),
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
              ),
              const Flexible(
                child: SizedBox(height: DimenConstants.contentPadding),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  stringText.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
