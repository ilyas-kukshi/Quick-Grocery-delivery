import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickgrocerydelivery/shared/AppThemeShared.dart';
import 'package:quickgrocerydelivery/shared/dialogs.dart';

class DEDashboard extends StatefulWidget {
  const DEDashboard({Key? key}) : super(key: key);

  @override
  State<DEDashboard> createState() => _DEDashboardState();
}

class _DEDashboardState extends State<DEDashboard> {
  List<DocumentSnapshot> deliveryData = [];

  @override
  void initState() {
    getDeliveryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppThemeShared.appBar(title: "Delivery Executive", context: context),
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
                                      onTap: () {},
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
                                      onTap: () {},
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
              } else {
                return Text('Error');
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
}
