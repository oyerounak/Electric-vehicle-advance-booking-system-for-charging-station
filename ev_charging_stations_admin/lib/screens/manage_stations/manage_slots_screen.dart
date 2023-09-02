import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/manage_slots_controller.dart';
import '../../models/slots.dart';
import '../../utils/constants/dimens_constants.dart';
import '../../utils/custom_widgets/card_rich_text.dart';
import '../../utils/custom_widgets/common_data_holder.dart';
import '../../utils/custom_widgets/common_scaffold.dart';

class ManageSlotsScreen extends StatelessWidget {
  ManageSlotsScreen({Key? key}) : super(key: key);

  final ManageSlotsController _controller = Get.put(ManageSlotsController());

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: AppBar(
        title: const Text("Manage Slots"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _controller.addSlots(),
        backgroundColor: Theme.of(context).primaryColor,
        label: const Text("Add Slots"),
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

  Widget _dataHolderWidget(List<Slots>? slotList) {
    try {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: slotList?.length ?? 0,
        itemBuilder: (context, index) {
          return _slotCards(slotList![index]);
        },
      );
    } catch (e) {
      return const CustomNoResultScreen();
    }
  }

  Widget _slotCards(Slots slot) {
    return InkWell(
      onTap: () {
        _controller.onTapSlotCard(slot: slot); //addUpdateStation
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
                            boldText: "Voltage : ",
                            normalText: slot.voltage ?? "",
                          ),
                          const SizedBox(height: DimenConstants.contentPadding),
                          CardRichText(
                            boldText: "Price : ",
                            normalText: slot.price ?? "",
                          ),
                          const SizedBox(height: DimenConstants.contentPadding),
                          CardRichText(
                            boldText: "Status : ",
                            normalText: slot.status ?? "",
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
