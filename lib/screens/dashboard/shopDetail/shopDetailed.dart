import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickgrocerydelivery/models/categoryModel.dart';
import 'package:quickgrocerydelivery/shared/AppThemeShared.dart';

import '../../../models/productModel.dart';
import '../../../shared/dialogs.dart';

// ignore: must_be_immutable
class ShopDetailed extends StatefulWidget {
  DocumentSnapshot? shopDoc;
  ShopDetailed({Key? key, this.shopDoc}) : super(key: key);

  @override
  _ShopDetailedState createState() => _ShopDetailedState();
}

class _ShopDetailedState extends State<ShopDetailed> {
  List<DocumentSnapshot> categoryDetails = [];
  List<UserProductModel> allProducts = [];
  List<String> myCartProductIds = [];
  String shopIdInShop = 'No Products';

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
                            widget.shopDoc?.id, []));
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
                          imageUrl: allProducts[index].imageUrl,
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          allProducts[index].name,
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
                          "₹" + allProducts[index].price,
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
                          buttonText: allProducts[index].addedToCart
                              ? "Go to Cart"
                              : "Add to Cart",
                          onTap: (p0, p1, p2) {
                            if (allProducts[index].addedToCart) {
                              Navigator.pushNamed(context, "/myCart");
                            } else {
                              addProductToCart(allProducts[index], index);
                            }
                          },
                        ),
                      ),
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

  addProductToCart(UserProductModel userProductModel, int index) {
    if (userProductModel.shopId == shopIdInShop ||
        shopIdInShop == 'No Products') {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("My Cart")
          .doc(userProductModel.id)
          .set({
        "imageUrl": userProductModel.imageUrl,
        "name": userProductModel.name,
        "category": userProductModel.category,
        "categoryId": userProductModel.categoryId,
        "price": userProductModel.price,
        "type": userProductModel.type,
        "shopName": userProductModel.shopName,
        "shopId": userProductModel.shopId,
        "dbProductId": userProductModel.dbProductId,
        "quantity": 1,
      }).whenComplete(() {
        allProducts[index].addedToCart = true;
        setState(() {});

        Fluttertoast.showToast(msg: "Product Added to Cart");
      });
    } else {
      DialogShared.doubleButtonDialog(context,
          "You already have products in cart of another shop. do you want to remove those products?",
          () {
        myCartProductIds.forEach((element) {
          FirebaseFirestore.instance
              .collection("Users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("My Cart")
              .doc(element)
              .delete()
              .whenComplete(() => FirebaseFirestore.instance
                      .collection("Users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("My Cart")
                      .doc(userProductModel.id)
                      .set({
                    "imageUrl": userProductModel.imageUrl,
                    "name": userProductModel.name,
                    "category": userProductModel.category,
                    "categoryId": userProductModel.categoryId,
                    "price": userProductModel.price,
                    "type": userProductModel.type,
                    "shopName": userProductModel.shopName,
                    "shopId": userProductModel.shopId,
                    "dbProductId": userProductModel.dbProductId,
                    "quantity": 1,
                  }).whenComplete(() {
                    allProducts[index].addedToCart = true;
                    shopIdInShop = userProductModel.shopId;
                    setState(() {});

                    Fluttertoast.showToast(msg: "Product Added to Cart");
                  }));
        });
        Navigator.pop(context);
      }, () {
        Navigator.pop(context);
      });
    }
  }

  getMyCartData() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("My Cart")
        .get()
        .then((value) {
      if (value.docs.length > 0) {
        shopIdInShop = value.docs[0].get("shopId");
        value.docs.forEach((element) {
          myCartProductIds.add(element.id);
        });
      }
    }).whenComplete(() => getAllProducts());
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
    try {
      await FirebaseFirestore.instance
          .collection("Shops")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("All Products")
          .get()
          .then((value) => {
                if (value.size > 0)
                  {
                    value.docs.forEach((element) {
                      allProducts.add(UserProductModel(
                        element.id,
                        element.get("imageUrl"),
                        element.get("name"),
                        element.get("categoryId"),
                        element.get("category"),
                        element.get("price"),
                        element.get("type"),
                        element.get("shopName"),
                        element.get("shopId"),
                        myCartProductIds.contains(element.id) ? true : false,
                        element.get("available"),
                        element.get("dbProductId"),
                      ));
                    })
                  }
              });
      setState(() {});
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
