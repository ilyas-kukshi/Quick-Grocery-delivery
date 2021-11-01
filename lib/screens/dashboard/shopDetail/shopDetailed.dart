import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickgrocerydelivery/models/categoryModel.dart';
import 'package:quickgrocerydelivery/shared/AppThemeShared.dart';

// ignore: must_be_immutable
class ShopDetailed extends StatefulWidget {
  DocumentSnapshot? shopDoc;
  ShopDetailed({Key? key, this.shopDoc}) : super(key: key);

  @override
  _ShopDetailedState createState() => _ShopDetailedState();
}

class _ShopDetailedState extends State<ShopDetailed> {
  List<DocumentSnapshot> categoryDetails = [];
  List<DocumentSnapshot> allProducts = [];
  @override
  void initState() {
    super.initState();
    getCategories();
    getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppThemeShared.appBar(
          title: widget.shopDoc?.get("name"),
          context: context,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              "Categories",
              style:
                  Theme.of(context).textTheme.headline1!.copyWith(fontSize: 32),
            ),
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: categoryDetails.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/productByCategory",
                        arguments: CategoryModel(
                            categoryDetails[index].id,
                            categoryDetails[index].get("name"),
                            categoryDetails[index].get("imageUrl"),
                            widget.shopDoc?.id));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: CachedNetworkImage(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: 150,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                          value: downloadProgress.progress),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              imageUrl: categoryDetails[index].get("imageUrl"),
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            categoryDetails[index].get("name"),
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              "All Products",
              style:
                  Theme.of(context).textTheme.headline1!.copyWith(fontSize: 32),
            ),
          ),
          SizedBox(height: 8),
          Expanded(
              child: GridView.builder(
            itemCount: allProducts.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisExtent: 300, mainAxisSpacing: 12),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: CachedNetworkImage(
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: 150,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          imageUrl: allProducts[index].get("imageUrl"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          allProducts[index].get("name"),
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(fontSize: 18),
                        ),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "₹" + allProducts[index].get("price"),
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(fontSize: 22),
                        ),
                      ),
                      SizedBox(height: 12),
                      Center(
                        child: AppThemeShared.argonButtonShared(
                          context: context,
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.35,
                          borderRadius: 12,
                          color: AppThemeShared.buttonColor,
                          buttonText: "Add to Cart",
                          onTap: (p0, p1, p2) {},
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ))
        ],
      ),
    );
  }

  getCategories() async {
    //caegories Id available at the shop
    // /Shops/85yZygsrqfYnExdAC17E53cRnnX2/Categories
    try {
      await FirebaseFirestore.instance
          .collection("Shops")
          .doc(widget.shopDoc?.id)
          .collection("Categories")
          .get()
          .then((value) => {
                value.docs.forEach((element) {
                  categoryDetails.add(element);
                })
              });
      setState(() {});
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  getAllProducts() async {
    await FirebaseFirestore.instance
        .collection("Shops")
        .doc(widget.shopDoc?.id)
        .collection("All Products")
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                allProducts.add(element);
              })
            });
    setState(() {});
  }
}
