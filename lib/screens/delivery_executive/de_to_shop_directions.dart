import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as locationPackage;
import 'package:quickgrocerydelivery/shared/AppThemeShared.dart';
import 'package:quickgrocerydelivery/shared/constants.dart';

class DeToShopDirections extends StatefulWidget {
  DocumentSnapshot deliveryDetails;

  DeToShopDirections({Key? key, required this.deliveryDetails})
      : super(key: key);

  @override
  State<DeToShopDirections> createState() => _DeToShopDirectionsState();
}

class _DeToShopDirectionsState extends State<DeToShopDirections> {
  double currentLatitude = 0.0;
  double currentLongitude = 0.0;

  GoogleMapController? googleMapController;
  late CameraPosition cameraPosition;

  Set<Marker> markers = Set<Marker>();
  Set<Polyline> polyLines = Set<Polyline>();
  List<LatLng> polyLineCoordinates = [];
  late PolylinePoints polylinePoints;

  late StreamSubscription<locationPackage.LocationData> subscription;
  locationPackage.Location location = locationPackage.Location();
  locationPackage.LocationData? currentPosition;
  locationPackage.LocationData? destinationPosition;

  @override
  void initState() {
    super.initState();

    polylinePoints = PolylinePoints();

    subscription = location.onLocationChanged.listen((cLocation) {
      currentPosition = cLocation;
    });
    setInitialLocation();
  }

  void setInitialLocation() async {
    currentPosition = await location.getLocation();

    cameraPosition = CameraPosition(
        target: LatLng(currentPosition!.latitude!, currentPosition!.longitude!),
        zoom: 15);
    setState(() {});

    var doc = widget.deliveryDetails["shopLocation"];
    GeoPoint shoplocation = doc['geopoint'];
    destinationPosition = locationPackage.LocationData.fromMap({
      'latitude': shoplocation.latitude,
      "longitude": shoplocation.longitude,
    });

    showLocationPins();
  }

  void showLocationPins() {
    var source = LatLng(
        currentPosition!.latitude ?? 0.0, currentPosition!.longitude ?? 0.0);
    var destination =
        LatLng(destinationPosition!.latitude!, currentPosition!.longitude!);

    markers.add(Marker(markerId: MarkerId('source'), position: source));

    markers.add(
        Marker(markerId: MarkerId('Shop Location'), position: destination));

    setPoylinesInMap();
  }

  void setPoylinesInMap() async {
    var result = await polylinePoints.getRouteBetweenCoordinates(
        Constants.mapApiKey,
        PointLatLng(
            currentPosition!.latitude ?? 0.0, currentPosition!.latitude ?? 0.0),
        PointLatLng(
            destinationPosition!.latitude!, destinationPosition!.longitude!));

    if (result.points.isNotEmpty) {
      result.points.forEach((pointLatLng) {
        polyLineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });

      setState(() {
        polyLines.add(Polyline(
            polylineId: PolylineId('directions'),
            color: AppThemeShared.buttonColor,
            points: polyLineCoordinates));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
            target:
                LatLng(currentPosition!.latitude!, currentPosition!.longitude!),
            zoom: 15),
        onMapCreated: (controller) => googleMapController = controller,
        myLocationButtonEnabled: true,
        markers: markers,
        polylines: polyLines,
      ),
    );
  }

  // void getCurrentLocation() async {
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied ||
  //       permission == LocationPermission.deniedForever) {
  //     Fluttertoast.showToast(msg: "QGD needs to know your location");
  //     LocationPermission permissionAsked = await Geolocator.requestPermission();
  //     if (permissionAsked == LocationPermission.always ||
  //         permissionAsked == LocationPermission.whileInUse) {
  //       getCurrentLocation();
  //     }
  //   } else if (permission == LocationPermission.always ||
  //       permission == LocationPermission.whileInUse) {
  //     currentPosition = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.best);

  //     cameraPosition = CameraPosition(
  //         target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
  //         zoom: 15);

  //     currentLatitude = currentPosition!.latitude;
  //     currentLongitude = currentPosition!.longitude;
  //     setState(() {});
  //   }
  // }
}
