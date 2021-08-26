import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectAddressScreen extends StatefulWidget {
  @override
  _SelectAddressScreenState createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends State<SelectAddressScreen> {
  Completer<GoogleMapController> _controller = Completer();
  var latitude = 0.0;
  var longitude = 0.0;
  final Geolocator _geolocator = Geolocator();
  Position? _currentPosition;

  GoogleMapController? mapController;

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  final Map<String, Marker> _markers = {};
  final Map<LatLng, String> address = {};
  late String _selectAddress;

  _getAddress() async {
    try {
      // Places are retrieved using the coordinates
      var p = await GeocodingPlatform.instance
          .placemarkFromCoordinates(latitude, longitude);

      // Taking the most probable result
      var place = p[0];

      setState(() {
        _selectAddress =
            '${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}';
        _markers.clear();
        final marker = Marker(
          markerId: MarkerId(_selectAddress),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            onTap: () {
              Navigator.pop(context, "$_selectAddress $latitude $longitude");
            },
            title: _selectAddress,
            snippet: _selectAddress,
          ),
        );
        _markers[_selectAddress] = marker;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;

    setState(() {
      _markers.clear();
      final marker = Marker(
        markerId: MarkerId(_selectAddress),
        position: LatLng(latitude, longitude),
        infoWindow: InfoWindow(
          onTap: () {
            Navigator.pop(context, _selectAddress);
          },
          title: _selectAddress,
          snippet: _selectAddress,
        ),
      );
      _markers[_selectAddress] = marker;
    });
  }

  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;

        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Выберите адрес'),
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        mapToolbarEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        onTap: (LatLng latLng) {
          latitude = latLng.latitude;
          longitude = latLng.longitude;
          _getAddress();
        },
        markers: _markers.values.toSet(),
      ),
    );
  }
}
