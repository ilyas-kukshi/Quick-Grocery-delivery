 import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickgrocerydelivery/models/categoryModel.dart';
import 'package:quickgrocerydelivery/models/productModel.dart';
import 'package:quickgrocerydelivery/shared/AppThemeShared.dart';
import 'package:quickgrocerydelivery/shared/dialogs.dart';

// ignore: must_be_immutable
class Products extends StatefulWidget {
  CategoryModel? category;
  Products({Key? key, this.category}) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List<String> productsAddedDocIds = [];
  List<ProductModel> products = [];
  String shopName = "";
  @override
  void initState() {
    super.initState();
    getAddedData();
    getShopName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppThemeShared.appBar(
          title: widget.category!.name,
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
            child: GridView.builder(
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 300,
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12)),
                          child: CachedNetworkImage(
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: 150,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            imageUrl: products[index].imageUrl,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            products[index].name,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                ?.copyWith(fontSize: 18),
                          ),
                        ),
                        SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "₹" +
                                products[index].price.toString() +
                                products[index].type,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                ?.copyWith(fontSize: 16),
                          ),
                        ),
                        SizedBox(height: 16),
                        Center(
                          child: AppThemeShared.argonButtonShared(
                            context: context,
                            height: 40,
                            width: MediaQuery.of(context).size.width * 0.35,
                            borderRadius: 16,
                            color: products[index].addedToShop
                                ? Colors.red
                                : AppThemeShared.buttonColor,
                            buttonText: products[index].addedToShop
                                ? "Remove from shop"
                                : 'Add to shop',
                            onTap: (p0, p1, p2) {
                              if (products[index].addedToShop) {
                                DialogShared.loadingDialog(
                                    context, "Removing...");
                                removeProductFromShop(products[index]);
                              } else {
                                DialogShared.loadingDialog(
                                    context, "Adding...");
                                addProductToShop(products[index]);
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  addProductToShop(ProductModel productModel) async {
    try {
      //Adding to Catgeories/Products
      await FirebaseFirestore.instance
          .collection("Shops")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Categories")
          .doc(widget.category?.id)
          .set({
        "imageUrl": widget.category?.imageUrl,
        "name": widget.category?.name
      }).whenComplete(() => {
                FirebaseFirestore.instance
                    .collection("Shops")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection("Categories")
                    .doc(widget.category?.id)
                    .collection("Products")
                    .add({
                  "imageUrl": productModel.imageUrl,
                  "name": productModel.name,
                  "price": productModel.price,
                  "category": productModel.category,
                  "categoryId": widget.category!.id,
                  "type": productModel.type,
                  "addedToShop": true,
                  "available": true,
                  "dbProductId": productModel.id,
                  "shopId": FirebaseAuth.instance.currentUser!.uid,
                  "shopName": shopName
                }).then((DocumentReference value) {
                  try {
                    //adding to All Products
                    FirebaseFirestore.instance
                        .collection("Shops")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection("All Products")
                        .doc(value.id)
                        .set({
                      "imageUrl": productModel.imageUrl,
                      "name": productModel.name,
                      "price": productModel.price,
                      "category": productModel.category,
                      "categoryId": widget.category!.id,
                      "type": productModel.type,
                      "addedToShop": true,
                      "available": true,
                      "dbProductId": productModel.id,
                      "shopId": FirebaseAuth.instance.currentUser!.uid,
                      "shopName": shopName
                    }).whenComplete(() {
                      //refreshing page
                      products.clear();
                      productsAddedDocIds.clear();
                      getAddedData();

                      setState(() {});
                      Navigator.pop(context);
                    });
                  } on FirebaseException catch (e) {
                    Fluttertoast.showToast(msg: e.toString());
                    Navigator.pop(context);
                  }
                })
              });
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      Navigator.pop(context);
    }
  }

  removeProductFromShop(ProductModel productModel) async {
    await FirebaseFirestore.instance
        .collection("Shops")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Categories")
        .doc(widget.category?.id)
        .collection("Products")
        .where("dbProductId", isEqualTo: productModel.id)
        .get()
        .then((value) {
      value.docs.first.reference.delete().whenComplete(() {
        FirebaseFirestore.instance
            .collection("Shops")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("All Products")
            .where("dbProductId", isEqualTo: productModel.id)
            .get()
            .then((value) {
          value.docs.first.reference.delete();
        });
      }).whenComplete(() {
        //refreshing page
        products.clear();
        productsAddedDocIds.clear();
        getAddedData();

        setState(() {});
        Navigator.pop(context);
      });
    });
  }

  getAddedData() async {
    await FirebaseFirestore.instance
        .collection("Shops")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Categories")
        .doc(widget.category!.id)
        .collection("Products")
        .get()
        .then((value) => {
              if (value.size != 0)
                {
                  value.docs.forEach((element) {
                    productsAddedDocIds.add(element.get("dbProductId"));
                  })
                }
              else
                {},
              getAllCategoryProducts()
            });
  }

  getAllCategoryProducts() async {

    //fetching products from global for shop owner to add products
    await FirebaseFirestore.instance
        .collection("Categories")
        .doc(widget.category!.id)
        .collection("Products")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        if (productsAddedDocIds.isNotEmpty) {
          if (productsAddedDocIds.contains(element.id)) {
            products.add(ProductModel(
              element.id,
              element.get("imageUrl").toString(),
              element.get("name").toString(),
              element.get("category").toString(),
              element.get("price"),
              element.get("type"),
              "",
              "",
              true,
              0,
              false,
              element.id,
            ));
            setState(() {});
          } else {
            products.add(ProductModel(
              element.id,
              element.get("imageUrl").toString(),
              element.get("name").toString(),
              element.get("category").toString(),
              element.get("price"),
              element.get("type"),
              "",
              "",
              false,
              0,
              false,
              "",
            ));
            setState(() {});
          }
        } else {
          products.add(ProductModel(
            element.id,
            element.get("imageUrl").toString(),
            element.get("name").toString(),
            element.get("category").toString(),
            element.get("price"),
            element.get("type"),
            "",
            "",
            false,
            0,
            false,
            "",
          ));
          setState(() {});
        }
      });
    });
  }

  getShopName() {
    FirebaseFirestore.instance
        .collection("Shops")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      shopName = value.get("name");
    });
  }
}
