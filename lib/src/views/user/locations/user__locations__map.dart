import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserLocationsMap extends StatefulWidget {
  const UserLocationsMap({Key? key}) : super(key: key);

  static const routeName = '/user/locations/map';

  @override
  _UserLocationsMapState createState() => _UserLocationsMapState();
}

class _UserLocationsMapState extends State<UserLocationsMap> {
  // on below line we are initializing our controller for google maps.
  final Completer<GoogleMapController> _controller = Completer();

  // on below line we are specifying our camera position
  static const CameraPosition _kGoogle = CameraPosition(
    target: LatLng(51.43856076432791, 5.4786534769341495),
    zoom: 13,
  );

  // Get all locations from database
  Future<List<Marker>> getLocations() async {
    final ref = FirebaseDatabase.instance.ref('Locations');
    DataSnapshot snapshot = await ref.get();

    Map<dynamic, dynamic> values = snapshot.value as Map;
    values.forEach((key, values) {
      final lat = values['Lat'];
      final long = values['Long'];
      final locationName = values['LocationName'];
      final marker = Marker(
        markerId: MarkerId(key),
        position: LatLng(double.parse(lat), double.parse(long)),
        infoWindow: InfoWindow(title: locationName),
      );
      _marker.add(marker);
    });

    return _marker;
  }

  final List<Marker> _marker = [];

  @override
  void initState() {
    super.initState();
    getLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Locations"),
        ),
        body: Container(
          // on below line creating google maps.
          child: FutureBuilder(
              future: getLocations(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GoogleMap(
                    // on below line setting camera position
                    initialCameraPosition: _kGoogle,
                    // on below line specifying map type.
                    mapType: MapType.normal,
                    // on below line setting user location enabled.
                    myLocationEnabled: true,
                    // on below line setting compass enabled.
                    compassEnabled: true,
                    markers: Set.from(_marker),
                    // on below line specifying controller on map complete.
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  );
                } else if (snapshot.hasError) {
                  print(
                      'Error fetching credit transactions: ${snapshot.error}');
                  return Text('Error fetching data ${snapshot.error}');
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ));
  }
}
