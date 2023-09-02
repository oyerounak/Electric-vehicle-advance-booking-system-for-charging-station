import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../controllers/google_map_view_controller.dart';
import '../../utils/custom_widgets/common_scaffold.dart';
import '../../utils/custom_widgets/custom_button.dart';
import '../../utils/custom_widgets/custom_text_field.dart';

class GoogleMapViewScreen extends StatelessWidget {
  GoogleMapViewScreen({Key? key}) : super(key: key);

  final GoogleMapViewController _controller =
      Get.put(GoogleMapViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Location"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(
          () {
            return Stack(
              alignment: Alignment.center,
              textDirection: TextDirection.rtl,
              fit: StackFit.loose,
              clipBehavior: Clip.hardEdge,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: _googleMap(),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: _searchLocationField(context),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _submitButton(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _searchLocationField(BuildContext context) {
    return SizedBox(
      child: CustomTextField(
        backgroundColor: Colors.white,
        hintText: "Search Location",
        textEditingController: _controller.etSearchLocation,
        currentFocusNode: _controller.etSearchLocationFocusNode,
        onTapField: () {
          _controller.onTapSearchLocation(context);
        },
      ),
    );
  }

  Widget _submitButton() {
    return CustomButton(
      buttonText: "Submit",
      onButtonPressed: () {
        _controller.onTapSubmit();
      },
    );
  }

  Widget _googleMap() {
    return GoogleMap(
      myLocationButtonEnabled: true,
      mapType: MapType.normal,
      markers: Set<Marker>.of(_controller.markers),
      initialCameraPosition: const CameraPosition(
        target: LatLng(0, 0),
      ),
      onMapCreated: (GoogleMapController googleMapController) {
        _controller.onMapCreated(googleMapController);
      },
      onTap: (value) {
        _controller.onTapGoogleMap(value);
      },
    );
  }
}
