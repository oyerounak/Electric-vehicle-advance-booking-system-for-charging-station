import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/add_update_slot_controller.dart';
import '../../utils/constants/dimens_constants.dart';
import '../../utils/custom_widgets/common_scaffold.dart';
import '../../utils/custom_widgets/custom_button.dart';
import '../../utils/custom_widgets/custom_text_field.dart';

class AddUpdateSlotsScreen extends StatelessWidget {
  AddUpdateSlotsScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  final AddUpdateSlotController _controller =
      Get.put(AddUpdateSlotController());

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: AppBar(
        title: const Text('ADD Slots'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _textFields(),
            _switch(),
            _submitButton(),
          ],
        ),
      ),
    );
  }

  Widget _textFields() {
    return Padding(
      padding: const EdgeInsets.all(DimenConstants.contentPadding),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: CustomTextField(
                    textEditingController: _controller.etVoltage,
                    hintText: "Voltage",
                    prefixIcon: Icons.electrical_services_outlined,
                    currentFocusNode: _controller.etVoltageFocusNode,
                    nextFocusNode: _controller.etPriceFocusNode,
                    allowedRegex: "[+-]?\\d*\\.?\\d+",
                    validatorFunction: (value) {
                      if (value!.isEmpty) {
                        return 'Voltage Cannot Be Empty';
                      }
                      return null;
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: CustomTextField(
                    textEditingController: _controller.etPrice,
                    hintText: "Price",
                    prefixIcon: Icons.location_city_outlined,
                    currentFocusNode: _controller.etPriceFocusNode,
                    nextFocusNode: _controller.etPriceFocusNode,
                    allowedRegex: "[+-]?\\d*\\.?\\d+",
                    validatorFunction: (value) {
                      if (value!.isEmpty) {
                        return 'Voltage Cannot Be Empty';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _switch() {
    return Obx(
      () => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                _controller.switchText.value,
                style: Get.textTheme.subtitle1?.copyWith(
                  color: Colors.black38,
                ),
              ),
              Switch(
                value: _controller.isSlotEnabled.value,
                onChanged: (val) {
                  _controller.setSelected(val);
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return CustomButton(
      buttonText: "Submit",
      onButtonPressed: () => {
        _controller.onPressSubmit(
          formKey: _formKey,
        ),
      },
    );
  }
}
