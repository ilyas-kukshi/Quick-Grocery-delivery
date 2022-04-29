import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:quickgrocerydelivery/shared/AppThemeShared.dart';

class ShopsNearMe extends StatefulWidget {
  const ShopsNearMe({Key? key}) : super(key: key);

  @override
  _ShopsNearMeState createState() => _ShopsNearMeState();
}

class _ShopsNearMeState extends State<ShopsNearMe> {
  List<DocumentSnapshot> shops = [];
  GeoPoint? savedLocation;

  @override
  void initState() {
    super.initState();
    getSelectedLocation();
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
            title: "Shops Near Me",
            context: context),
        body: shops.length > 0
            ? Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: shops.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return shopsWidget(index);
                      },
                    ),
                  ),
                ],
              )
            : Center(
                child: Text(
                  "No shops near you. Please inform your nearby general stores about us.😊",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: 22),
                ),
              ));
  }

  Widget shopsWidget(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/shopDetailed", arguments: shops[index]);
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(
              child: SizedBox(
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
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                shops[index]["name"],
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                shops[index]["address"],
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(fontSize: 18),
              ),
            ),
            SizedBox(
              height: 12,
            )
          ]),
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

        loadData(savedLocation!.latitude, savedLocation!.longitude);
      }
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
      shops = documentList;
      setState(() {});
    });
  }
}
