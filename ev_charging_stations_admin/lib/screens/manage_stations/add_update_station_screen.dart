import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/add_update_station_controller.dart';
import '../../utils/constants/dimens_constants.dart';
import '../../utils/custom_widgets/common_scaffold.dart';
import '../../utils/custom_widgets/custom_button.dart';
import '../../utils/custom_widgets/custom_text_field.dart';

class AddUpdateStationScreen extends StatelessWidget {
  AddUpdateStationScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final AddUpdateStationController _controller =
      Get.put(AddUpdateStationController());

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: AppBar(
        title: const Text('ADD STATION'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _textFields(),
            _switch(),
            _submitButton(),
            _viewSlots(),
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
            CustomTextField(
              hintText: "Name",
              prefixIcon: Icons.ev_station_outlined,
              currentFocusNode: _controller.etNameFocusNode,
              nextFocusNode: _controller.etLocationFocusNode,
              textEditingController: _controller.etName,
              validatorFunction: (value) {
                if (value!.isEmpty) {
                  return 'Name Cannot Be Empty';
                }
                return null;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: CustomTextField(
                    hintText: "Location",
                    prefixIcon: Icons.add_location_alt_outlined,
                    currentFocusNode: _controller.etLocationFocusNode,
                    nextFocusNode: _controller.etCityFocusNode,
                    textEditingController: _controller.etLocation,
                    validatorFunction: (value) {
                      if (value!.isEmpty) {
                        return 'Location Cannot Be Empty';
                      }
                      return null;
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: CustomTextField(
                    hintText: "City",
                    prefixIcon: Icons.location_city_outlined,
                    currentFocusNode: _controller.etCityFocusNode,
                    nextFocusNode: _controller.etLatLngFocusNode,
                    textEditingController: _controller.etCity,
                    validatorFunction: (value) {
                      if (value!.isEmpty) {
                        return 'City Cannot Be Empty';
                      }
                      return null;
                    },
                  ),
                )
              ],
            ),
            CustomTextField(
              hintText: "Latitude , Longitude",
              suffixIcon: Icons.map_outlined,
              readOnly: true,
              currentFocusNode: _controller.etLatLngFocusNode,
              nextFocusNode: _controller.etLatLngFocusNode,
              textEditingController: _controller.etLatLng,
              validatorFunction: (value) {
                if (value!.isEmpty) {
                  return 'City Cannot Be Empty';
                }
                return null;
              },
              onTapField: () {
                _controller.onTapLatLngField();
              },
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
                style: Get.textTheme.subtitle1?.copyWith(color: Colors.black38),
              ),
              Switch(
                value: _controller.isStationEnabled.value,
                onChanged: (val) => _controller.toggleSwitch(val),
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
        _controller.onPressSubmit(formKey: _formKey),
      },
    );
  }

  Widget _viewSlots() {
    if (_controller.stationId != null) {
      return CustomButton(
        buttonText: "View Slots",
        onButtonPressed: () => {
          _controller.onPressViewSlots(),
        },
      );
    } else {
      return Container();
    }
  }
}
