import 'package:ev_charging_stations_user/utils/custom_widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/view_booking_details_controller.dart';
import '../../utils/constants/dimens_constants.dart';
import '../../utils/custom_widgets/common_scaffold.dart';

class ViewBookingDetailsScreen extends StatelessWidget {
  ViewBookingDetailsScreen({Key? key}) : super(key: key);

  final ViewBookingDetailsController _controller =
      Get.put(ViewBookingDetailsController());

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: AppBar(
        title: const Text("Booking Details"),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          child: Column(
            children: [
              Card(
                margin: const EdgeInsets.all(DimenConstants.layoutPadding),
                elevation: DimenConstants.cardElevation,
                child: Container(
                  margin: const EdgeInsets.all(DimenConstants.layoutPadding),
                  padding: const EdgeInsets.all(DimenConstants.layoutPadding),
                  child: Wrap(
                    spacing: DimenConstants.contentPadding,
                    runSpacing: DimenConstants.contentPadding,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _textAndData(
                        "Booking Date",
                        _controller.bookingArg.bookingDate.toString(),
                      ),
                      _textAndData(
                        "Station Name",
                        _controller.bookingArg.stationName.toString(),
                      ),
                      _textAndData(
                        "Vehicle Name",
                        _controller.bookingArg.vehicleName.toString(),
                      ),
                      _textAndData(
                        "Vehicle Number",
                        _controller.bookingArg.vehicleNumber.toString(),
                      ),
                      _textAndData(
                        "Status",
                        _controller.bookingArg.bookingStatus.toString(),
                      ),
                      _textAndData(
                        "Time In",
                        _controller.bookingArg.timeIn.toString(),
                      ),
                      _textAndData(
                        "Time Out",
                        _controller.bookingArg.timeOut.toString(),
                      ),
                      _textAndData(
                        "Amount",
                        _controller.bookingArg.amount.toString(),
                      ),
                      _textAndData(
                        "Date Time",
                        _controller.bookingArg.dateTime.toString(),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: _controller.isCancelButtonVisible,
                child: CustomButton(
                  buttonText: "Cancel Booking",
                  onButtonPressed: () {
                    _controller.onTapCancelBooking();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textAndData(String text, String data) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: SizedBox(
            width: Get.width * 0.5,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            width: Get.width * 0.5,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                data,
                textAlign: TextAlign.end,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
