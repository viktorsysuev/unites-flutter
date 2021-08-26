import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unites_flutter/ui/main.dart';
import 'package:unites_flutter/ui/bloc/event_bloc.dart';
import 'package:unites_flutter/domain/models/event_model.dart';
import 'package:unites_flutter/ui/events/event_info_screen.dart';
import 'package:unites_flutter/ui/widgets/little_widgets_collection.dart';
import 'package:unites_flutter/ui/util/theme_controller.dart';

class EventsOnMapScreen extends StatefulWidget {
  @override
  _EventsOnMapScreenState createState() => _EventsOnMapScreenState();
}

class _EventsOnMapScreenState extends State<EventsOnMapScreen> {
  final eventBloc = getIt<EventsBloc>();

  late String _darkMapStyle;
  late String _normalMapStyle;

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map_style/dark_map_style.json').then((string) {
      _darkMapStyle = string;
    });
    rootBundle.loadString('assets/map_style/normal_map_style.json').then((string) {
      _normalMapStyle = string;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _getCurrentLocation();
    eventBloc.getEvents();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
//    eventBloc.dispose();
    super.dispose();
  }

  Completer<GoogleMapController> _controller = Completer();

  var latitude = 0.0;
  var longitude = 0.0;
  final Geolocator _geolocator = Geolocator();
  Position? _currentPosition;

  GoogleMapController? mapController;

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  final Map<String, Marker> _markers = {};

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
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
  Widget build(BuildContext context) {

    if (mapController != null ) {
      if (ThemeController.of(context).currentTheme == 'dark') {
        mapController?.setMapStyle(_darkMapStyle);
      }
      else {
        mapController?.setMapStyle(_normalMapStyle);
      }
    }
    return Scaffold(
      body: StreamBuilder<List<EventModel>>(
        stream: eventBloc.events,
        builder:
            (BuildContext context, AsyncSnapshot<List<EventModel>> snapshot) {
          Widget child;
          if (snapshot.hasData) {
            snapshot.data?.forEach((element) {
              if (element.coordinates != null && element.id != null) {
                final marker = Marker(
                  markerId: MarkerId(element.id),
                  position: LatLng(element.coordinates!.latitude,
                      element.coordinates!.longitude),
                  infoWindow: InfoWindow(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EventInfoScreen(eventId: element.id)));
                    },
                    title: element.name,
                    snippet: element.description,
                  ),
                );
                _markers[element.id] = marker;
              }
            });
            child = GoogleMap(
              myLocationEnabled: true,
              mapToolbarEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              markers: _markers.values.toSet(),
            );
          } else if (snapshot.hasError) {
            child = Center(child: WidgetErrorLoad());
          } else {
            child = Center(child: WidgetDataLoad());
          }
          return child;
        },
      ),
    );
  }
}
