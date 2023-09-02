import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/fade_transition_controller.dart';
import '../../controller/find_stations_controller.dart';
import '../../models/stations.dart';
import '../../utils/constants/dimens_constants.dart';
import '../../utils/constants/string_constants.dart';
import '../../utils/custom_widgets/card_rich_text.dart';
import '../../utils/custom_widgets/common_data_holder.dart';
import '../../utils/custom_widgets/common_scaffold.dart';
import '../../utils/custom_widgets/custom_button.dart';
import '../../utils/custom_widgets/custom_drop_down.dart';
import '../../utils/custom_widgets/custom_text_field.dart';

class FindStationsScreen extends StatelessWidget {
  FindStationsScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final FindStationsController _controller = Get.put(FindStationsController());
  final FadeTransitionController _animationController =
      Get.put(FadeTransitionController());

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showBottomSheet();
    });

    return CommonScaffold(
      appBar: AppBar(
        title: const Text("Find Stations"),
        centerTitle: true,
        actions: [_actionWidget()],
      ),
      body: _body(),
    );
  }

  Widget _actionWidget() {
    return FadeTransition(
      opacity: _animationController.fadeInFadeOut,
      alwaysIncludeSemantics: true,
      child: Transform.scale(
        scale: 1,
        child: IconButton(
          onPressed: () => _showBottomSheet(),
          icon: const Icon(Icons.filter_alt_outlined),
        ),
      ),
    );
  }

  Widget _body() {
    return Obx(() {
      if (_controller.isDataTableVisible.value == true) {
        return CommonDataHolder(
          controller: _controller,
          widget: _dataHolderWidget,
          dataList: _controller.dataList,
        );
      } else {
        return const Center(child: Text("Select Filter"));
      }
    });
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
        _controller.onTapStationCard(station: station);
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
                        child: Icon(Icons.ev_station_outlined),
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

  void _showBottomSheet() {
    if (Get.isBottomSheetOpen == true) {
      Get.back();
    }
    Future<void> bottomSheet = showModalBottomSheet<void>(
      enableDrag: true,
      isScrollControlled: true,
      elevation: DimenConstants.cardElevation,
      backgroundColor: Colors.white,
      context: Get.overlayContext as BuildContext,
      builder: (BuildContext buildContext) {
        return SafeArea(
          child: _filterValues(),
        );
      },
    );

    bottomSheet.then((value) => _controller.onBottomSheetClose());
  }

  Widget _filterValues() {
    return Container(
      padding: EdgeInsets.only(bottom: Get.mediaQuery.viewInsets.bottom),
      margin: const EdgeInsets.all(DimenConstants.layoutPadding),
      child: Obx(
        () {
          return Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dropDown(),
                _filterByValueTextField(),
                _submitButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _dropDown() {
    return CustomDropDown(
      labelText: 'Select Filter',
      displayList: StringConstants.filterList,
      selected: _controller.filterBy,
      validatorFunction: (value) {
        return _controller.dropDownValidation(value);
      },
      onChanged: (value) {
        _controller.onChanged(value);
      },
    );
  }

  Widget _filterByValueTextField() {
    return Visibility(
      visible: _controller.isFilterValueTextFieldVisible.value,
      child: CustomTextField(
        hintText: "Select ${_controller.filterBy.value}",
        textEditingController: _controller.etFilterValue,
        currentFocusNode: _controller.etFilterValueFocusNode,
        keyboardType: _controller.filterBy.value == "Kilometer"
            ? TextInputType.number
            : null,
        validatorFunction: (value) {
          if (value!.isEmpty) {
            return 'Cannot Be Empty';
          }
          return null;
        },
      ),
    );
  }

  Widget _submitButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: CustomButton(
        buttonText: "Submit",
        onButtonPressed: () {
          _controller.onButtonPressSubmit(
            formKey: _formKey,
          );
        },
      ),
    );
  }
}
