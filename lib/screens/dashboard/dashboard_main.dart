import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quickgrocerydelivery/screens/dashboard/dashboard_dawer.dart';
import 'package:quickgrocerydelivery/shared/AppThemeShared.dart';
import 'package:quickgrocerydelivery/shared/dialogs.dart';

class DashboardMain extends StatefulWidget {
  const DashboardMain({Key? key}) : super(key: key);

  @override
  _DashboardMainState createState() => _DashboardMainState();
}

class _DashboardMainState extends State<DashboardMain> {
  Position? currentPosition;
  GeoPoint? savedLocation;
  bool askCurrentLocation = true;
  String userLocation = "Your Location";
  GlobalKey<ScaffoldState> scaffolKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    getSelectedLocation();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        DialogShared.doubleButtonDialog(context, "Are your want to exit?", () {
          SystemNavigator.pop();
        }, () {
          Navigator.pop(context);
        });

        return Future.value(false);
      },
      child: Scaffold(
        key: scaffolKey,
        drawer: DashboardDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: GestureDetector(
              onTap: () {
                scaffolKey.currentState?.openDrawer();
              },
              child: Icon(Icons.menu_outlined, color: Colors.white)),
          centerTitle: true,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.local_shipping_outlined,
                      color: Colors.white,
                    ),
                    Text(userLocation,
                        style: TextStyle(
                          color: Colors.white,
                        )),
                    GestureDetector(
                        onTap: () {
                          if (askCurrentLocation) {
                            getCurrentLocation();
                          } else {
                            Navigator.pushNamed(context, "/setLocation",
                                arguments: GeoPoint(savedLocation!.latitude,
                                    savedLocation!.longitude));
                          }
                        },
                        child: Icon(Icons.edit, color: Colors.white)),
                  ],
                ),
              )
            ],
          ),
        ),
        body: Column(
          children: [],
        ),
      ),
    );
  }

  void getSelectedLocation() async {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((doc) {
      if (doc.data()?["location"] != null) {
        savedLocation = doc.data()?["location"]["geopoint"];
        getAddressFromLatLong(
            savedLocation!.latitude, savedLocation!.longitude);
      }
    });
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
      currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      GeoFirePoint location = Geoflutterfire().point(
          latitude: currentPosition!.latitude,
          longitude: currentPosition!.longitude);
      FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({"location": location.data});
      Navigator.pushNamed(context, "/setLocation",
          arguments:
              GeoPoint(currentPosition!.latitude, currentPosition!.longitude));
    }
  }

  Future<void> getAddressFromLatLong(double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    setState(() {
      userLocation = '${place.subLocality}, ${place.locality}';
      askCurrentLocation = false;
    });
    // print(Address);
  }
}
