import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/add_update_ev_vehicle_controller.dart';
import '../../utils/constants/dimens_constants.dart';
import '../../utils/custom_widgets/common_scaffold.dart';
import '../../utils/custom_widgets/custom_button.dart';
import '../../utils/custom_widgets/custom_text_field.dart';
import '../../utils/helpers/common_helper.dart';

class AddUpdateEVVehicles extends StatelessWidget {
  AddUpdateEVVehicles({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final AddUpdateEVVehicleController _controller =
      Get.put(AddUpdateEVVehicleController());

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: AppBar(
        title: const Text('ADD EV VEHICLE'),
        centerTitle: true,
        actions: [_actionWidget()],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _textFields(),
              _submitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionWidget() {
    return Obx(
      () {
        try {
          if (_controller.evVehicleId.value != '') {
            return IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                _controller.onTapDelete(
                  formKey: _formKey,
                );
              },
            );
          } else {
            return Container();
          }
        } catch (e) {
          CommonHelper.printDebugError(e);
          return Container();
        }
      },
    );
  }

  Widget _textFields() {
    return Padding(
      padding: const EdgeInsets.all(DimenConstants.contentPadding),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              hintText: "Vehicle Number",
              prefixIcon: Icons.credit_card_outlined,
              currentFocusNode: _controller.etVehicleNumberFocusNode,
              nextFocusNode: _controller.etVehicleNameFocusNode,
              textEditingController: _controller.etVehicleNumber,
              validatorFunction: (value) {
                if (value!.isEmpty) {
                  return 'Vehicle Number Cannot Be Empty';
                }
                return null;
              },
            ),
            CustomTextField(
              hintText: "Vehicle Name",
              prefixIcon: Icons.drive_file_rename_outline,
              currentFocusNode: _controller.etVehicleNameFocusNode,
              nextFocusNode: _controller.btnSubmitFocusNode,
              textEditingController: _controller.etVehicleName,
              validatorFunction: (value) {
                if (value!.isEmpty) {
                  return 'Vehicle Name Cannot Be Empty';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _submitButton() {
    return CustomButton(
      buttonText: "Submit",
      currentFocusNode: _controller.btnSubmitFocusNode,
      onButtonPressed: () {
        _controller.onPressSubmit(
          formKey: _formKey,
        );
      },
    );
  }
}
