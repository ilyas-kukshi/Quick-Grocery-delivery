import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:quickgrocerydelivery/shared/AppThemeShared.dart';

class DEDashboard extends StatefulWidget {
  const DEDashboard({Key? key}) : super(key: key);

  @override
  State<DEDashboard> createState() => _DEDashboardState();
}

class _DEDashboardState extends State<DEDashboard> {
  List<DocumentSnapshot> deliveryData = [];
  GeoPoint? savedLocation;

  String userLocation = "Your Location";

  @override
  void initState() {
    getDeliveryData();
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
                        Navigator.pushNamed(context, "/setDELocation",
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
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('DeliveryExecutives')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("Deliveries")
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData && snapshot.data.size > 0) {
                return ListView.builder(
                  itemCount: snapshot.data.size,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          decoration: BoxDecoration(),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        'Delivery id: ' +
                                            snapshot.data.docs[index].id,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1!
                                            .copyWith(fontSize: 14)),
                                    snapshot.data.docs[index]['ongoing']
                                        ? Text('Ongoing',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1!
                                                .copyWith(
                                                    fontSize: 18,
                                                    color: Colors.green))
                                        : Offstage()
                                  ],
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Divider(color: Colors.grey)),
                                SizedBox(height: 8),
                                Text('Shop Details:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(fontSize: 16)),
                                SizedBox(height: 8),
                                Text(
                                    'Name: ' +
                                        snapshot.data.docs[index]['shopName'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(fontSize: 16)),
                                SizedBox(height: 8),
                                Text(
                                    'Phone Number: ' +
                                        snapshot.data.docs[index]
                                            ['shopPhoneNumber'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(fontSize: 16)),
                                SizedBox(height: 8),
                                Text(
                                    'Address: ' +
                                        snapshot.data.docs[index]
                                            ['shopAddress'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(fontSize: 16)),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text('Location: ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1!
                                            .copyWith(fontSize: 16)),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, "/DeToShopDirections",
                                            arguments:
                                                snapshot.data.docs[index]);
                                      },
                                      child: Text('Show Directions',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline1!
                                              .copyWith(
                                                  fontSize: 18,
                                                  color: AppThemeShared
                                                      .buttonColor)),
                                    )
                                  ],
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Divider(color: Colors.grey)),
                                SizedBox(height: 8),
                                Text('User Details:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(fontSize: 16)),
                                SizedBox(height: 8),
                                Text(
                                    'Name: ' +
                                        snapshot.data.docs[index]['userName'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(fontSize: 16)),
                                SizedBox(height: 8),
                                Text(
                                    'Phone Number: ' +
                                        snapshot.data.docs[index]
                                            ['userPhoneNumber'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(fontSize: 16)),
                                SizedBox(height: 8),
                                Text(
                                    'Address: ' +
                                        snapshot.data.docs[index]
                                            ['userAddress'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(fontSize: 16)),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text('Location: ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1!
                                            .copyWith(fontSize: 16)),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, '/ShopToUserDirections',
                                            arguments:
                                                snapshot.data.docs[index]);
                                      },
                                      child: Text('Show Directions',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline1!
                                              .copyWith(
                                                  fontSize: 18,
                                                  color: AppThemeShared
                                                      .buttonColor)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.data.size <= 0) {
                return Center(child: Text('No Delivery Data Available'));
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return Text('Unidentified Error');
              }
            } else {
              return Center(child: Text('Loading Data'));
            }
          }),
    );
  }

  getDeliveryData() async {
    await FirebaseFirestore.instance
        .collection("DeliveryExecutives")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Deliveries")
        .orderBy("timeStamp", descending: true)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        deliveryData.add(element);
      });
      setState(() {});
    });
  }

  Future<DocumentSnapshot> getShopDetails(
      DocumentSnapshot deliveryDetails) async {
    late DocumentSnapshot shopDetails;

    await FirebaseFirestore.instance
        .collection("Shops")
        .doc(deliveryDetails.get('shopId'))
        .get()
        .then((value) => shopDetails = value);
    return shopDetails;
  }

  Widget customerDetails(DocumentSnapshot customerDetails) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Customer Details",
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 200, child: Divider(color: Colors.grey)),
                  Text(
                    "Name: " + customerDetails.get("userName"),
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(fontSize: 14),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Phone Number: " + customerDetails.get("userPhnNumber"),
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(fontSize: 14),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Address: " + customerDetails.get("userAddress"),
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
            Column(
              children: [],
            )
          ],
        ),
      ],
    );
  }

  Widget productDetails(DocumentSnapshot productDetails) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Product Details",
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(width: 200, child: Divider(color: Colors.grey)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Date: " +
                  productDetails.get("orderDate").toString().substring(0, 10),
              style: Theme.of(context).textTheme.headline3!.copyWith(
                    fontSize: 16,
                  ),
            ),
          ],
        ),
        SizedBox(height: 8),
      ],
    );
  }

  void getSelectedLocation() async {
    FirebaseFirestore.instance
        .collection("DeliveryExecutives")
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
