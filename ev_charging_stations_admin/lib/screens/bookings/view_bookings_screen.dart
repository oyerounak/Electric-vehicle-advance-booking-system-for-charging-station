import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/view_booking_controller.dart';
import '../../models/bookings.dart';
import '../../utils/constants/dimens_constants.dart';
import '../../utils/custom_widgets/card_rich_text.dart';
import '../../utils/custom_widgets/common_data_holder.dart';
import '../../utils/custom_widgets/common_scaffold.dart';

class ViewBookingsScreen extends StatelessWidget {
  ViewBookingsScreen({Key? key}) : super(key: key);

  final ViewBookingController _controller = Get.put(ViewBookingController());

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: AppBar(
        title: const Text("Bookings"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _controller.viewAllUsers(),
        backgroundColor: Theme.of(context).primaryColor,
        label: const Text("View All Users"),
        icon: const Icon(Icons.supervised_user_circle_outlined),
        foregroundColor: Colors.white,
      ),
      body: _body(context, _controller),
    );
  }

  Widget _body(BuildContext context, ViewBookingController _controller) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Obx(
            () {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: constraints.maxWidth,
                    margin: const EdgeInsets.all(DimenConstants.contentPadding),
                    child: Card(
                      elevation: DimenConstants.cardElevation,
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.all(
                            DimenConstants.contentPadding,
                          ),
                          padding: const EdgeInsets.all(
                            DimenConstants.contentPadding,
                          ),
                          child: InkWell(
                            onTap: () => _controller.selectDate(context),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _controller.selectedDate.value,
                                  textAlign: TextAlign.center,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.calendar_today),
                                  tooltip: 'Tap to open date picker',
                                  onPressed: () {
                                    _controller.selectDate(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Visibility(
                      visible: _controller.isDataTableVisible.value,
                      child: CommonDataHolder(
                        controller: _controller,
                        widget: _dataHolderWidget,
                        dataList: _controller.dataList,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _dataHolderWidget(List<Bookings>? bookingList) {
    try {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: bookingList?.length ?? 0,
        itemBuilder: (context, index) {
          return _bookingCards(bookingList![index]);
        },
      );
    } catch (e) {
      return const CustomNoResultScreen();
    }
  }

  Widget _bookingCards(Bookings booking) {
    return InkWell(
      onTap: () {
        _controller.onTapBookingCard(booking: booking); //addUpdateStation
      },
      child: Container(
        margin: const EdgeInsets.all(DimenConstants.contentPadding),
        child: Card(
          elevation: DimenConstants.cardElevation,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(DimenConstants.buttonCornerRadius),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(DimenConstants.contentPadding),
                padding: const EdgeInsets.all(DimenConstants.contentPadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(
                      flex: 1,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Icon(Icons.list_alt_outlined),
                      ),
                    ),
                    const Expanded(
                      child: SizedBox(height: DimenConstants.contentPadding),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CardRichText(
                            boldText: "Date : ",
                            normalText: booking.bookingDate ?? "",
                          ),
                          const SizedBox(height: DimenConstants.contentPadding),
                          CardRichText(
                            boldText: "Name : ",
                            normalText: booking.userName ?? "",
                          ),
                          const SizedBox(height: DimenConstants.contentPadding),
                          CardRichText(
                            boldText: "Station : ",
                            normalText: booking.stationName ?? "",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
