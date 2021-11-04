import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quickgrocerydelivery/models/categoryModel.dart';
import 'package:quickgrocerydelivery/screens/dashboard/dashboard_drawer.dart';
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
  List<DocumentSnapshot> shops = [];
  List<DocumentSnapshot> categories = [];
  GlobalKey<ScaffoldState> scaffolKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    getSelectedLocation();
    allCategories();
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 12),
              //   child: Text(
              //     "Nearby Shops",
              //     style: Theme.of(context)
              //         .textTheme
              //         .headline1!
              //         .copyWith(fontSize: 24),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  "Nearby Shops",
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: 24),
                ),
              ),
              // SizedBox(height: 20),
              shops.length > 0
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: SizedBox(
                        height: 200,
                        child: ListView.builder(
                          itemCount: shops.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return shopsWidget(index);
                          },
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          "No shops near you. Please inform your nearby general stores about us.😊",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(fontSize: 20),
                        ),
                      ),
                    ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  "Categories",
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: 24),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisExtent: 230),
                  itemCount: categories.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return categoryWidget(index);
                  },
                ),
              ),

              // Expanded(child: GridView.builder(
              // //  itemCount: allProducts.length,
              //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //             crossAxisCount: 2,
              //             mainAxisExtent: 300,
              //             mainAxisSpacing: 12),
              //   itemBuilder: (context, index) {
              //     return Container();
              //   },))
            ],
          ),
        ),
      ),
    );
  }

  Widget shopsWidget(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/shopDetailed", arguments: shops[index]);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Stack(children: [
          Column(children: [
            SizedBox(
                height: 150,
                width: 250,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
                  child: Image.asset(
                    "assets/images/shopBg.jpg",
                    fit: BoxFit.fill,
                  ),
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                shops[index]["name"],
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(fontSize: 20),
              ),
            )
          ])
        ]),
      ),
    );
  }

  Widget categoryWidget(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          "/dashboardProductByCategory",
          arguments: CategoryModel(
              categories[index].id,
              categories[index]["name"],
              categories[index]["imageUrl"],
              "",
              shops),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Stack(children: [
            Column(children: [
              SizedBox(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12)),
                    child: CachedNetworkImage(
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      imageUrl: categories[index].get("imageUrl"),
                      fit: BoxFit.fill,
                    ),
                  )),
              SizedBox(height: 12),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  categories[index]["name"],
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(fontSize: 20),
                ),
              )
            ])
          ]),
        ),
      ),
    );
  }

  allCategories() async {
    FirebaseFirestore.instance.collection("Categories").get().then((value) {
      value.docs.forEach((element) {
        categories.add(element);
      });
      setState(() {});
    });
  }

  loadData(double latitude, double longitude) {
    // Create a geoFirePoint
    GeoFirePoint center =
        Geoflutterfire().point(latitude: latitude, longitude: longitude);
    Stream<List<DocumentSnapshot>> stream = Geoflutterfire()
        .collection(
            collectionRef: FirebaseFirestore.instance.collection("Shops"))
        .within(
            center: center, radius: 10, field: "location", strictMode: true);
    stream.listen((List<DocumentSnapshot> documentList) {
      shops.clear();
      documentList.forEach((element) {
        if (element.get("enabled")) {
          shops.add(element);
        }
      });
      // shops = documentList;
      setState(() {});
    });
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
        loadData(savedLocation!.latitude, savedLocation!.longitude);
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

    Placemark place = placemarks[0];
    setState(() {
      userLocation = '${place.subLocality}, ${place.locality}';
      askCurrentLocation = false;
    });
    // print(Address);
  }
}
