import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickgrocerydelivery/shared/AppThemeShared.dart';

class SetDELocation extends StatefulWidget {
  final GeoPoint? initialPosition;
  const SetDELocation({Key? key, this.initialPosition}) : super(key: key);

  @override
  State<SetDELocation> createState() => _SetDELocationState();
}

class _SetDELocationState extends State<SetDELocation> {
  double latitude = 0.0;
  double longitude = 0.0;
  bool locationChanged = false;

  GoogleMapController? googleMapController;

  @override
  void initState() {
    super.initState();
    latitude = widget.initialPosition!.latitude;
    longitude = widget.initialPosition!.longitude;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppThemeShared.appBar(
          title: "Set Your Location",
          context: context,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  GeoFirePoint location = Geoflutterfire()
                      .point(latitude: latitude, longitude: longitude);
                  FirebaseFirestore.instance
                      .collection("DeliveryExecutives")
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .update({"location": location.data}).whenComplete(() {
                    Navigator.popAndPushNamed(context, "/DEDashboard");
                  });
                },
                child: Visibility(
                  visible: locationChanged,
                  child: Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ]),
      body: Center(
        child: GoogleMap(
          circles: {
            Circle(
                circleId: CircleId("5km area"),
                center: LatLng(latitude, longitude),
                radius: 5000,
                fillColor: Colors.blue.withOpacity(0.2),
                strokeColor: Colors.blue.withOpacity(0.2))
          },
          initialCameraPosition:
              CameraPosition(target: LatLng(latitude, longitude), zoom: 15),
          onMapCreated: (controller) => googleMapController = controller,
          myLocationButtonEnabled: true,
          onTap: (tappedLocation) {
            setState(() {
              latitude = tappedLocation.latitude;
              longitude = tappedLocation.longitude;
              locationChanged = true;
            });
          },
          markers: {
            Marker(
              draggable: true,
              onDrag: (draggedLocation) {
                setState(() {
                  latitude = draggedLocation.latitude;
                  longitude = draggedLocation.longitude;
                  locationChanged = true;
                });
              },
              markerId: MarkerId("Your Location"),
              position: LatLng(latitude, longitude),
            ),
          },
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: AppThemeShared.buttonColor,
      //   onPressed: () {
      //     CameraUpdate.newLatLng(LatLng(19.240330, 73.130539));
      //   },
      // ),
    );
  }
}
