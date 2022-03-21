import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as locationPackage;
import 'package:quickgrocerydelivery/shared/AppThemeShared.dart';
import 'package:quickgrocerydelivery/shared/constants.dart';

class ShopToUserDirection extends StatefulWidget {
  DocumentSnapshot deliveryDetails;
  ShopToUserDirection({Key? key, required this.deliveryDetails})
      : super(key: key);

  @override
  State<ShopToUserDirection> createState() => _ShopToUserDirectionState();
}

class _ShopToUserDirectionState extends State<ShopToUserDirection> {
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
  locationPackage.LocationData? shopLocation;
  locationPackage.LocationData? destinationLocation;

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

    var forShopLocation = widget.deliveryDetails["shopLocation"];
    GeoPoint shoplocation = forShopLocation['geopoint'];
    shopLocation = locationPackage.LocationData.fromMap({
      'latitude': shoplocation.latitude,
      "longitude": shoplocation.longitude,
    });

    var userLocation = widget.deliveryDetails['userAddressLocation'];

    destinationLocation = locationPackage.LocationData.fromMap({
      'latitude': userLocation.latitude,
      "longitude": userLocation.longitude,
    });

    showLocationPins();
  }

  void showLocationPins() {
    var source =
        LatLng(shopLocation!.latitude ?? 0.0, shopLocation!.longitude ?? 0.0);
    var destination =
        LatLng(destinationLocation!.latitude!, destinationLocation!.longitude!);

    markers.add(Marker(markerId: MarkerId('Shop Location'), position: source));

    markers.add(Marker(
        markerId: MarkerId('Destination Location'), position: destination));

    setPoylinesInMap();
  }

  void setPoylinesInMap() async {
    var result = await polylinePoints.getRouteBetweenCoordinates(
        Constants.onlyMapApiKey,
        PointLatLng(
            shopLocation!.latitude ?? 0.0, shopLocation!.latitude ?? 0.0),
        PointLatLng(
            destinationLocation!.latitude!, destinationLocation!.longitude!));

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
}
