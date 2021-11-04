import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickgrocerydelivery/shared/AppThemeShared.dart';
import 'package:quickgrocerydelivery/shared/dialogs.dart';

class ManageOrders extends StatefulWidget {
  const ManageOrders({Key? key}) : super(key: key);

  @override
  _ManageOrdersState createState() => _ManageOrdersState();
}

class _ManageOrdersState extends State<ManageOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppThemeShared.appBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios, color: Colors.white)),
          title: "Manage Orders",
          context: context),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Shops")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection("Orders")
                  .orderBy("timeStamp", descending: true)   
                  .snapshots(),
              // initialData: initialData,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    if (snapshot.data.size > 0) {
                      return ListView.builder(
                        itemCount: snapshot.data.size,
                        itemBuilder: (BuildContext context, int index) {
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customerDetails(
                                          snapshot.data.docs[index]),
                                      SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Divider(color: Colors.grey)),
                                      SizedBox(height: 8),
                                      productDetails(snapshot.data.docs[index])
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text(
                          "No orders data available.",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(fontSize: 24),
                        ),
                      );
                    }
                  } else {
                    return Center(
                      child: Text(
                        "There is some problem.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline1!
                            .copyWith(fontSize: 24),
                      ),
                    );
                  }
                } else {
                  return Center(
                    child: Text(
                      "Loading Data...",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headline1!
                          .copyWith(fontSize: 24),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              width: 180,
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(12)),
              child: DropdownButton<String>(
                value: productDetails.get("status"),
                isExpanded: true,
                iconSize: 24,
                elevation: 16,
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    ?.copyWith(fontSize: 16),
                underline: Offstage(),
                onChanged: (String? newValue) {
                  DialogShared.loadingDialog(context, "Updating status");
                  setState(() {
                    FirebaseFirestore.instance
                        .collection("Shops")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection("Orders")
                        .doc(productDetails.id)
                        .update({"status": newValue}).whenComplete(() {
                      FirebaseFirestore.instance
                          .collection("Users")
                          .doc(productDetails.get("shopId"))
                          .collection("Orders")
                          .doc(productDetails.id)
                          .update({"status": newValue}).whenComplete(() {
                        Navigator.pop(context);
                      });
                    });
                  });
                },
                items: <String>['Requested', 'Out for delivery', "Delivered"]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12)),
              child: CachedNetworkImage(
                height: 110,
                width: 110,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    SizedBox(
                  height: 80,
                  width: 80,
                  child: CircularProgressIndicator(
                      value: downloadProgress.progress),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                imageUrl: productDetails.get("imageUrl"),
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productDetails.get("name"),
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(productDetails.get("category"),
                    style: Theme.of(context).textTheme.headline3?.copyWith(
                          fontSize: 16,
                        )),
                SizedBox(height: 8),
                Text(
                    "₹" +
                        productDetails.get("price") +
                        " per " +
                        productDetails.get("type"),
                    style: Theme.of(context).textTheme.headline3?.copyWith(
                          fontSize: 16,
                        )),
                SizedBox(height: 8),
                Text(
                    "Quantity: " +
                        productDetails.get("quantity").toString() +
                        " " +
                        productDetails.get("type"),
                    style: Theme.of(context).textTheme.headline3?.copyWith(
                          fontSize: 16,
                        )),
              ],
            )
          ],
        )
      ],
    );
  }
}
