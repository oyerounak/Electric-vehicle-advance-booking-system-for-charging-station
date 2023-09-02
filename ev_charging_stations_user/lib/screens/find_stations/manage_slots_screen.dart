import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';

import '../../controller/fade_transition_controller.dart';
import '../../controller/manage_slots_controller.dart';
import '../../models/slots.dart';
import '../../utils/constants/dimens_constants.dart';
import '../../utils/constants/string_constants.dart';
import '../../utils/custom_widgets/card_rich_text.dart';
import '../../utils/custom_widgets/common_data_holder.dart';
import '../../utils/custom_widgets/common_scaffold.dart';
import '../../utils/custom_widgets/custom_button.dart';
import '../../utils/custom_widgets/custom_drop_down.dart';
import '../../utils/custom_widgets/custom_text_field.dart';

class ManageSlotsScreen extends StatelessWidget {
  ManageSlotsScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ManageSlotsController _controller = Get.put(ManageSlotsController());
  final FadeTransitionController _animationController =
      Get.put(FadeTransitionController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showBottomSheet();
    });

    return CommonScaffold(
      appBar: AppBar(
        title: const Text("Manage Slots"),
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
        scale: 1.4,
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

  Widget _dataHolderWidget(List<Slots>? slotsList) {
    try {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: slotsList?.length ?? 0,
        itemBuilder: (context, index) {
          return _slotCards(slotsList![index]);
        },
      );
    } catch (e) {
      return const CustomNoResultScreen();
    }
  }

  Widget _slotCards(Slots slot) {
    return InkWell(
      onTap: () {
        _controller.onTapSlotCard(slot: slot);
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
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          flex: 1,
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Icon(Icons.alarm_sharp),
                          ),
                        ),
                        const Expanded(
                          child:
                              SizedBox(height: DimenConstants.contentPadding),
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
                              const SizedBox(
                                  height: DimenConstants.contentPadding),
                              CardRichText(
                                boldText: "Price : ",
                                normalText: slot.price ?? "",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      margin: const EdgeInsets.only(
                        top: DimenConstants.contentPadding,
                      ),
                      child: CustomButton(
                        buttonText: "Book Slot",
                        isWrapContent: true,
                        onButtonPressed: () {
                          _controller.onTapBookSlot(slot: slot);
                        },
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
      context: Get.context as BuildContext,
      builder: (BuildContext buildContext) {
        return SafeArea(
          child: _filterValues(),
        );
      },
    );

    bottomSheet.then((value) => _controller.loadSlots());
  }

  Widget _filterValues() {
    return Container(
      padding: EdgeInsets.only(bottom: Get.mediaQuery.viewInsets.bottom),
      margin: const EdgeInsets.all(DimenConstants.layoutPadding),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _selectDate(),
            _filterByValueFields(),
            _submitButton(),
          ],
        ),
      ),
    );
  }

  Widget _selectDate() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(DimenConstants.contentPadding),
        padding: const EdgeInsets.all(DimenConstants.contentPadding),
        child: CustomTextField(
          hintText: "Tap to open date picker",
          readOnly: true,
          textEditingController: _controller.etDatePicker,
          validatorFunction: (value) {
            if (value!.isEmpty) {
              return 'Date Cannot Be Empty';
            }
            return null;
          },
          onTapField: () {
            _controller.onTapDatePickerField();
          },
        ),
      ),
    );
  }

  Widget _filterByValueFields() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(
          left: DimenConstants.contentPadding,
          right: DimenConstants.contentPadding,
        ),
        padding: const EdgeInsets.only(
          left: DimenConstants.contentPadding,
          right: DimenConstants.contentPadding,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: CustomTextField(
                hintText: "Tap to open time picker",
                readOnly: true,
                textEditingController: _controller.etSelectTime,
                currentFocusNode: _controller.etSelectDurationFocusNode,
                nextFocusNode: _controller.etSelectDurationFocusNode,
                validatorFunction: (value) {
                  if (value!.isEmpty) {
                    return 'Time Cannot Be Empty';
                  }
                  return null;
                },
                onTapField: () {
                  _controller.onTapTimePickerField();
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: _dropDown(),
            )
          ],
        ),
      ),
    );
  }

  Widget _dropDown() {
    return CustomDropDown(
      labelText: 'Select Duration',
      displayList: StringConstants.durationList,
      selected: _controller.duration,
      validatorFunction: (value) {
        return _controller.dropDownValidation(value);
      },
      onChanged: (value) {
        _controller.onChanged(value);
      },
    );
  }

  Widget _submitButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: CustomButton(
        buttonText: "Get Slots",
        onButtonPressed: () {
          _controller.onClickGetSlots(formKey: _formKey);
        },
      ),
    );
  }
}
