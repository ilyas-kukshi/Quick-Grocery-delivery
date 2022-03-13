import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickgrocerydelivery/shared/AppThemeShared.dart';

class SetLocationShop extends StatefulWidget {
  const SetLocationShop({Key? key}) : super(key: key);

  @override
  _SetLocationShopState createState() => _SetLocationShopState();
}

class _SetLocationShopState extends State<SetLocationShop> {
  Position? currentPosition;
  CameraPosition cameraPosition = CameraPosition(target: LatLng(0.0, 0.0));
  double latitude = 0.0;
  double longitude = 0.0;

  GoogleMapController? googleMapController;
  // List<MapSearchModel>? searchResults;
  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppThemeShared.appBar(
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          title: "Set Location",
          context: context,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  GeoFirePoint location = Geoflutterfire()
                      .point(latitude: latitude, longitude: longitude);
                  Navigator.pop(context, location);
                },
                child: Icon(
                  Icons.save,
                  color: Colors.white,
                ),
              ),
            )
          ]),
      body: Center(
          child: GoogleMap(
        circles: {
          Circle(
              circleId: CircleId("10km area"),
              center: LatLng(latitude, longitude),
              radius: 3000,
              fillColor: Colors.blue.withOpacity(0.2),
              strokeColor: Colors.blue.withOpacity(0.2))
        },
        initialCameraPosition: cameraPosition,
        onMapCreated: (controller) => googleMapController = controller,
        myLocationButtonEnabled: true,
        onTap: (tappedLocation) {
          setState(() {
            latitude = tappedLocation.latitude;
            longitude = tappedLocation.longitude;
          });
        },
        markers: {
          Marker(
            draggable: true,
            onDrag: (draggedLocation) {
              setState(() {
                latitude = draggedLocation.latitude;
                longitude = draggedLocation.longitude;
              });
            },
            markerId: MarkerId("Your Location"),
            position: LatLng(latitude, longitude),
          ),
        },
      )),
    );
  }

  void getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: "QGD needs to know your location");
      LocationPermission permissionAsked = await Geolocator.requestPermission();
      if (permissionAsked == LocationPermission.always ||
          permissionAsked == LocationPermission.whileInUse) {
        getCurrentLocation();
      }
    } else if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      setState(() {});
      currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      latitude = currentPosition!.latitude;
      longitude = currentPosition!.longitude;
      googleMapController!.moveCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(latitude, longitude), zoom: 15)));
      setState(() {});
    }
  }

  currentLocation() async {}

  @override
  void dispose() {
    googleMapController?.dispose();
    super.dispose();
  }
}
