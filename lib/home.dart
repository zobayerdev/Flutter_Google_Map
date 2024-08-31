import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'location_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _Assignment10State();
}

class _Assignment10State extends State<HomePage> {
  GoogleMapController? _mapController;

  Future<void> _getLocation() async {
    await Get.find<LocationController>().listenCurrentLocation();
  }

  @override
  void initState() {
    _getLocation();
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    Get.find<LocationController>().addListener(() {
      _animateToUser();
    });
  }

  void _animateToUser() {
    final locationController = Get.find<LocationController>();
    if (locationController.currentLocation != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              locationController.currentLocation!.latitude,
              locationController.currentLocation!.longitude,
            ),
            zoom: 14.0,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map'),
      ),
      body: Center(
        child: GetBuilder<LocationController>(
          builder: (lController) {
            if (!lController.locationCheck ||
                lController.currentLocation == null) {
              return const CircularProgressIndicator();
            }
            return GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(lController.currentLocation!.latitude,
                    lController.currentLocation!.longitude),
                zoom: 16,
              ),
              polylines: {
                Polyline(
                  polylineId: const PolylineId('line'),
                  width: 8,
                  color: Colors.pinkAccent,
                  visible: true,
                  points: lController.coOrdinates,
                ),
              },
              markers: {
                Marker(
                  markerId: const MarkerId('trying'),
                  visible: true,
                  position: LatLng(lController.currentLocation!.latitude,
                      lController.currentLocation!.longitude),
                  infoWindow: InfoWindow(
                    title: 'My current location',
                    snippet:
                        'Latitude: ${lController.currentLocation!.latitude}, Longitude: ${lController.currentLocation!.longitude}',
                  ),
                ),
              },
            );
          },
        ),
      ),
    );
  }
}
