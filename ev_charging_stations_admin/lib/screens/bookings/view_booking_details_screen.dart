import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/view_booking_details_controller.dart';
import '../../utils/constants/dimens_constants.dart';
import '../../utils/custom_widgets/common_scaffold.dart';
import '../../utils/custom_widgets/custom_button.dart';

class ViewBookingDetails extends StatelessWidget {
  ViewBookingDetails({Key? key}) : super(key: key);

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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                margin: const EdgeInsets.all(DimenConstants.layoutPadding),
                elevation: DimenConstants.cardElevation,
                child: Container(
                  margin: const EdgeInsets.all(DimenConstants.contentPadding),
                  padding: const EdgeInsets.all(DimenConstants.contentPadding),
                  child: Obx(
                    () {
                      return Wrap(
                        spacing: DimenConstants.contentPadding,
                        runSpacing: DimenConstants.contentPadding,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.center,
                        children: [
                          _textAndData(
                            text: "Booking Date",
                            data: _controller.bookingsArg.value!.bookingDate
                                .toString(),
                          ),
                          _textAndData(
                            text: "Status",
                            data: _controller.bookingsArg.value!.bookingStatus
                                .toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: getColor(
                                _controller.bookingsArg.value!.bookingStatus
                                    .toString(),
                              ),
                            ),
                          ),
                          _textAndData(
                            text: "Station Name",
                            data: _controller.bookingsArg.value!.stationName
                                .toString(),
                          ),
                          _textAndData(
                            text: "User Name",
                            data: _controller.bookingsArg.value!.userName
                                .toString(),
                          ),
                          _textAndData(
                            text: "Vehicle Name",
                            data: _controller.bookingsArg.value!.vehicleName
                                .toString(),
                          ),
                          _textAndData(
                            text: "Vehicle Number",
                            data: _controller.bookingsArg.value!.vehicleNumber
                                .toString(),
                          ),
                          _textAndData(
                            text: "Time In",
                            data: _controller.bookingsArg.value!.timeIn
                                .toString(),
                          ),
                          _textAndData(
                            text: "Time Out",
                            data: _controller.bookingsArg.value!.timeOut
                                .toString(),
                          ),
                          _textAndData(
                            text: "Amount",
                            data: _controller.bookingsArg.value!.amount
                                .toString(),
                          ),
                          _textAndData(
                            text: "Date Time",
                            data: _controller.bookingsArg.value!.dateTime
                                .toString(),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Visibility(
                visible: _controller.bookingsArg.value!.bookingStatus
                        .toString()
                        .toLowerCase()
                        .contains("cancel")
                    ? false
                    : true,
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

  Color? getColor(text) {
    if (text != null) {
      if (text.contains("Book")) return Colors.green;
      if (text.contains("Cancel")) return Colors.red;
    }
    return null;
  }

  Widget _textAndData({
    required String text,
    required String data,
    style,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: SizedBox(
            width: Get.size.width * 0.5,
            child: Align(
              alignment: Alignment.topLeft,
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
        Container(
          margin: const EdgeInsets.only(
            left: DimenConstants.layoutPadding,
            right: DimenConstants.layoutPadding,
          ),
          child: const Text(
            ":",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            width: Get.size.width * 0.5,
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                data,
                textAlign: TextAlign.left,
                style: style,
              ),
            ),
          ),
        )
      ],
    );
  }
}
