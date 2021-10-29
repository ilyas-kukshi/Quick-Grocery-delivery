import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickgrocerydelivery/models/categoryModel.dart';
import 'package:quickgrocerydelivery/screens/shops/selectproducts/products.dart';
import 'package:quickgrocerydelivery/shared/AppThemeShared.dart';
import 'package:shimmer/shimmer.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppThemeShared.appBar(
          title: "Categories",
          context: context,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios, color: Colors.white))),
      body: Column(
        children: [
          SizedBox(height: 30),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Categories")
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                      itemCount: snapshot.data?.docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, "/selectProductsProducts",
                                arguments: CategoryModel(
                                    snapshot.data?.docs[index].id,
                                    snapshot.data?.docs[index]["name"],
                                    snapshot.data?.docs[index]["imageUrl"]));
                          },
                          child: Column(
                            children: [
                              CachedNetworkImage(
                                height: 150,
                                width: 150,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        SizedBox(
                                  height: 80,
                                  width: 80,
                                  child: CircularProgressIndicator(
                                      value: downloadProgress.progress),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                imageUrl: snapshot.data?.docs[index]
                                    ["imageUrl"],
                                fit: BoxFit.fill,
                              ),
                              Text(
                                snapshot.data?.docs[index]["name"],
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    ?.copyWith(fontSize: 18),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Text("No Categories Found");
                  }
                } else {
                  return Shimmer(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 150,
                          width: 150,
                        )
                      ],
                    ),
                    gradient:
                        LinearGradient(colors: [Colors.grey, Colors.grey]),
                  );
                }
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.85,
            child: AppThemeShared.argonButtonShared(
                context: context,
                height: 50,
                width: MediaQuery.of(context).size.width * 0.85,
                borderRadius: 12,
                color: AppThemeShared.buttonColor,
                buttonText: "Done",
                onTap: (p1, p2, p3) {
                  Navigator.pushNamed(context, "/dashboardMain");
                })),
      ),
    );
  }
}
