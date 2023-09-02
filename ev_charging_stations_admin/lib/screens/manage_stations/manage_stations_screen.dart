import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/manage_stations_controller.dart';
import '../../models/stations.dart';
import '../../utils/constants/dimens_constants.dart';
import '../../utils/custom_widgets/card_rich_text.dart';
import '../../utils/custom_widgets/common_data_holder.dart';
import '../../utils/custom_widgets/common_scaffold.dart';

class ManageStationsScreen extends StatelessWidget {
  ManageStationsScreen({Key? key}) : super(key: key);

  final ManageStationsController _controller =
      Get.put(ManageStationsController());

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: AppBar(
        title: const Text("Manage Stations"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _controller.addStation(),
        backgroundColor: Theme.of(context).primaryColor,
        label: const Text("Add Station"),
        icon: const Icon(Icons.add),
        foregroundColor: Colors.white,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return CommonDataHolder(
      controller: _controller,
      widget: _dataHolderWidget,
      dataList: _controller.dataList,
    );
  }

  Widget _dataHolderWidget(List<Stations>? stationList) {
    try {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: stationList?.length ?? 0,
        itemBuilder: (context, index) {
          return _stationCards(stationList![index]);
        },
      );
    } catch (e) {
      return const CustomNoResultScreen();
    }
  }

  Widget _stationCards(Stations station) {
    return InkWell(
      onTap: () {
        _controller.onTapStationCard(station: station); //addUpdateStation
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
                        child: Icon(Icons.electric_car_outlined),
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
                            boldText: "Name : ",
                            normalText: station.stationName ?? "",
                          ),
                          const SizedBox(height: DimenConstants.contentPadding),
                          CardRichText(
                            boldText: "City : ",
                            normalText: station.city ?? "",
                          ),
                          const SizedBox(height: DimenConstants.contentPadding),
                          CardRichText(
                            boldText: "Status : ",
                            normalText: station.city ?? "",
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

  Color? getColor(text) {
    if (text != null) {
      if (text.contains("Enable")) return Colors.green;
      if (text.contains("Disable")) return Colors.red;
    }
    return null;
  }
}
