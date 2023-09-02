import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../controller/fade_transition_controller.dart';
import '../../controller/google_map_view_controller.dart';
import '../../utils/constants/dimens_constants.dart';
import '../../utils/custom_widgets/common_scaffold.dart';
import '../../utils/custom_widgets/custom_text_field.dart';

class GoogleMapViewGoogleMap extends StatelessWidget {
  GoogleMapViewGoogleMap({Key? key}) : super(key: key);

  final GoogleMapViewController _controller =
      Get.put(GoogleMapViewController());

  final FadeTransitionController _animationController =
      Get.put(FadeTransitionController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.destinationLatLng.value == _controller.emptyLocation) {
        _showBottomSheet();
        _controller.onTapActionWidget();
      }
    });

    return CommonScaffold(
      appBar: AppBar(
        title: const Text("Location"),
        centerTitle: true,
        actions: [_actionWidget()],
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
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _actionWidget() {
    return Container(
      margin: const EdgeInsets.only(right: DimenConstants.contentPadding),
      child: Obx(
        () {
          if (_controller.isBottomSheetVisible.value == true) {
            return const Icon(Icons.keyboard_arrow_down_outlined);
          } else {
            return FadeTransition(
              opacity: _animationController.fadeInFadeOut,
              alwaysIncludeSemantics: true,
              child: Transform.scale(
                scale: 1,
                child: _iconButton(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _iconButton() {
    return Transform.scale(
      scale: 1.4,
      child: IconButton(
        onPressed: () {
          _showBottomSheet();
          _controller.onTapActionWidget();
        },
        icon: const Icon(Icons.location_searching_outlined),
      ),
    );
  }

  Widget _googleMap() {
    return GoogleMap(
      myLocationButtonEnabled: true,
      mapType: MapType.normal,
      mapToolbarEnabled: true,
      trafficEnabled: true,
      compassEnabled: true,
      myLocationEnabled: true,
      markers: Set<Marker>.of(_controller.markerList),
      polylines: Set<Polyline>.of(_controller.polylineList),
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

  Widget _searchLocationField() {
    return SizedBox(
      child: Container(
        margin: const EdgeInsets.all(DimenConstants.contentPadding),
        decoration: const BoxDecoration(
          color: Colors.white54,
          borderRadius: BorderRadius.all(
            Radius.circular(DimenConstants.textFieldCornerRadius),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              hintText: "Choose start location",
              prefixIcon: Icons.location_searching_outlined,
              textEditingController: _controller.etStartLocation,
              currentFocusNode: _controller.etStartLocationFocusNode,
              onTapField: () {
                _controller.onTapSearchLocation(
                  searchType: "StartLocation",
                );
              },
            ),
            CustomTextField(
              prefixIcon: Icons.location_on_outlined,
              hintText: "Choose destination",
              textEditingController: _controller.etDestination,
              currentFocusNode: _controller.etDestinationFocusNode,
              onTapField: () {
                _controller.onTapSearchLocation(
                  searchType: "DestinationLocation",
                );
              },
            )
          ],
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      enableDrag: true,
      elevation: DimenConstants.cardElevation,
      backgroundColor: Colors.white,
      context: Get.context as BuildContext,
      builder: (BuildContext buildContext) {
        return SafeArea(
          child: _searchLocationField(),
        );
      },
    ).then((value) {
      _controller.onTapActionWidget();
    });
  }
}
