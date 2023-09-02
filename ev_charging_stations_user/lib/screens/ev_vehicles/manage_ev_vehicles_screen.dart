import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/manage_ev_vehicles_controller.dart';
import '../../models/ev_vehicles.dart';
import '../../utils/constants/dimens_constants.dart';
import '../../utils/custom_widgets/card_rich_text.dart';
import '../../utils/custom_widgets/common_data_holder.dart';
import '../../utils/custom_widgets/common_scaffold.dart';

class ManageEVVehicles extends StatelessWidget {
  ManageEVVehicles({Key? key}) : super(key: key);

  final ManageEVVehicleController _controller =
      Get.put(ManageEVVehicleController());

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: AppBar(
        title: const Text("Manage EV Vehicle"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _controller.addEVVehicles(),
        backgroundColor: Theme.of(context).primaryColor,
        label: const Text("Add EV Vehicles"),
        icon: const Icon(Icons.electric_car_outlined),
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
      onRefresh: () async {
        _controller.fetchEVVehicles();
      },
    );
  }

  Widget _dataHolderWidget(List<EvVehicles>? evVehiclesList) {
    if (evVehiclesList != null) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: evVehiclesList.length,
        itemBuilder: (context, index) {
          return _vehicleCards(evVehiclesList[index]);
        },
      );
    } else {
      return const CustomNoResultScreen();
    }
  }

  Widget _vehicleCards(EvVehicles evVehicle) {
    return InkWell(
      onTap: () {
        _controller.onTapVehicleCard(evVehicle: evVehicle);
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
                            boldText: "Vehicle Name : ",
                            normalText: evVehicle.vehicleName ?? "",
                          ),
                          const SizedBox(height: DimenConstants.contentPadding),
                          CardRichText(
                            boldText: "Vehicle Number : ",
                            normalText: evVehicle.vehicleNumber ?? "",
                          ),
                        ],
                      ),
                    )
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
