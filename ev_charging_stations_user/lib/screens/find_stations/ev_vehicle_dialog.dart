import 'package:flutter/material.dart';

import '../../controller/manage_slots_controller.dart';
import '../../models/ev_vehicles.dart';
import '../../models/slots.dart';
import '../../utils/constants/dimens_constants.dart';
import '../../utils/custom_widgets/card_rich_text.dart';
import '../../utils/custom_widgets/common_data_holder.dart';

class EvVehicleDialog extends StatelessWidget {
  final ManageSlotsController controller;
  final Slots slot;

  const EvVehicleDialog({
    Key? key,
    required this.controller,
    required this.slot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonDataHolder(
      onRefresh: () async {
        controller.fetchEVVehicles();
      },
      controller: controller,
      widget: _dataHolderWidget,
      dataList: controller.evVehicleList,
    );
  }

  Widget _dataHolderWidget(List<EvVehicles>? evVehicleList) {
    try {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: evVehicleList?.length ?? 0,
        itemBuilder: (context, index) {
          return _vehicleCards(evVehicleList![index]);
        },
      );
    } catch (e) {
      return const CustomNoResultScreen();
    }
  }

  Widget _vehicleCards(EvVehicles evVehicles) {
    return GestureDetector(
      onTap: () => controller.onTapVehicle(
        evVehicles: evVehicles,
        slot: slot,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            DimenConstants.textFieldCornerRadius,
          ),
          side: const BorderSide(
            color: Colors.black,
            width: 0.5,
          ),
        ),
        elevation: DimenConstants.cardElevation,
        child: Column(
          children: [
            const SizedBox(height: DimenConstants.contentPadding),
            CardRichText(
              boldText: evVehicles.vehicleNumber ?? "",
              normalText: "",
            ),
            const SizedBox(height: DimenConstants.contentPadding),
            CardRichText(
              boldText: "",
              normalText: evVehicles.vehicleName ?? "",
            ),
            const SizedBox(height: DimenConstants.contentPadding),
          ],
        ),
      ),
    );
  }
}
