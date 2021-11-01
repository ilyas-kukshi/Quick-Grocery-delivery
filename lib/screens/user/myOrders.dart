import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickgrocerydelivery/shared/AppThemeShared.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppThemeShared.appBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios, color: Colors.white)),
          title: "My Orders",
          context: context),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Orders")
            .orderBy("timeStamp")
            .snapshots(),
        // initialData: initialData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.size,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          decoration: BoxDecoration(),
                          child: productDetails(snapshot.data.docs[index])),
                    ),
                  );
                },
              );
            } else {
              return Text("No orders data available");
            }
          } else {
            return Text("Loading Data...");
          }
        },
      ),
    );
  }

  Widget productDetails(DocumentSnapshot productDetails) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            productDetails.get("status"),
            style: Theme.of(context).textTheme.headline1!.copyWith(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          SizedBox(height: 6),
          Text(
            "Order Date: " +
                productDetails.get("orderDate").toString().substring(0, 10),
            style: Theme.of(context).textTheme.headline3!.copyWith(
                  fontSize: 16,
                ),
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
                  Text(productDetails.get("shopName"),
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
      ),
    );
  }
}
