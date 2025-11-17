import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShopMapWidget extends StatefulWidget {
  final double latitude;
  final double longitude;

  const ShopMapWidget({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<ShopMapWidget> createState() => _ShopMapWidgetState();
}

class _ShopMapWidgetState extends State<ShopMapWidget> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _markers.add(
      Marker(
        markerId: const MarkerId('shop_location'),
        position: LatLng(widget.latitude, widget.longitude),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(widget.latitude, widget.longitude),
        zoom: 15.0,
      ),
      markers: _markers,
    );
  }
}