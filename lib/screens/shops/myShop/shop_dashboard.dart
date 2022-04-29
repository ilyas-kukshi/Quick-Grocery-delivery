import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:quickgrocerydelivery/shared/AppThemeShared.dart';

class ShopDashboard extends StatefulWidget {
  const ShopDashboard({Key? key}) : super(key: key);

  @override
  _ShopDashboardState createState() => _ShopDashboardState();
}

class _ShopDashboardState extends State<ShopDashboard> {
  GeoPoint? savedLocation;

  String userLocation = "Your Location";
  @override
  void initState() {
    getSelectedLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.white)),
        centerTitle: true,
        title: Column(
          // crossAxisAlignment: CrossAxisAlignment.start
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
                        Navigator.pushNamed(context, "/changeShopLocation",
                            arguments: GeoPoint(savedLocation!.latitude,
                                savedLocation!.longitude));
                      },
                      child: Icon(Icons.edit, color: Colors.white)),
                ],
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, "/manageProducts"),
                      child: Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: AppThemeShared.buttonColor, width: 3)),
                        child: Center(
                          child: Text("Manage \nProducts",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(fontSize: 24, letterSpacing: 1.5)),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, "/selectProductsCategories"),
                      child: Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: AppThemeShared.buttonColor, width: 3)),
                        child: Center(
                          child: Text("Select \nProducts",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(fontSize: 24, letterSpacing: 1.5)),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, "/manageOrders"),
                      child: Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: AppThemeShared.buttonColor, width: 3)),
                        child: Center(
                          child: Text("Manage \nOrders",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(fontSize: 24, letterSpacing: 1.5)),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, "/myShopProfile"),
                      child: Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: AppThemeShared.buttonColor, width: 3)),
                        child: Center(
                          child: Text("Shop \nProfile",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(fontSize: 24, letterSpacing: 1.5)),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void getSelectedLocation() async {
    FirebaseFirestore.instance
        .collection("Shops")
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

  Future<void> getAddressFromLatLong(double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);

    Placemark place = placemarks[0];
    setState(() {
      userLocation = '${place.subLocality}, ${place.locality}';
    });
    // print(Address);
  }
}
