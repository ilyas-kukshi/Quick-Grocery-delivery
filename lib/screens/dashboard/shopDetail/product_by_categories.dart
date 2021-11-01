import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickgrocerydelivery/models/categoryModel.dart';
import 'package:quickgrocerydelivery/models/productModel.dart';
import 'package:quickgrocerydelivery/shared/AppThemeShared.dart';

// ignore: must_be_immutable
class ProductByCategory extends StatefulWidget {
  CategoryModel? categoryModel;
  ProductByCategory({Key? key, this.categoryModel}) : super(key: key);

  @override
  _ProductByCategoryState createState() => _ProductByCategoryState();
}

class _ProductByCategoryState extends State<ProductByCategory> {
  List<UserProductModel> allProducts = [];
  List<String> myCartProductIds = [];
  @override
  void initState() {
    super.initState();
    getMyCartData();
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
          title: widget.categoryModel!.name,
          context: context),
      body: Column(
        children: [
          SizedBox(height: 20),
          allProducts.isNotEmpty
              ? Expanded(
                  child: GridView.builder(
                  itemCount: allProducts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 310,
                      mainAxisSpacing: 12),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                  child: CachedNetworkImage(
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    height: 150,
                                    progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    "₹" +
                                        allProducts[index].price +
                                        " " +
                                        allProducts[index].type,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(fontSize: 22),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    allProducts[index].shopName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3!
                                        .copyWith(fontSize: 18),
                                  ),
                                ),
                                SizedBox(height: 12),
                                Center(
                                  child: AppThemeShared.argonButtonShared(
                                    context: context,
                                    height: 40,
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    borderRadius: 12,
                                    color: AppThemeShared.buttonColor,
                                    buttonText: allProducts[index].addedToCart
                                        ? "Go to Cart"
                                        : "Add to Cart",
                                    onTap: (p0, p1, p2) {
                                      if (allProducts[index].addedToCart) {
                                        Navigator.pushNamed(context, "/myCart");
                                      } else {
                                        addProductToCart(
                                            allProducts[index], index);
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                            !allProducts[index].available!
                                ? Container(
                                    height: 310,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color:
                                            Colors.grey[200]!.withOpacity(0.8)),
                                    child: Center(
                                      child: Text(
                                        "Out of stock",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1!
                                            .copyWith(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )
                                : Offstage()
                          ],
                        ),
                      ),
                    );
                  },
                ))
              : Center(
                  child: Text(
                    "No Products in this Category in your area",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(fontSize: 32),
                  ),
                )
        ],
      ),
    );
  }

  addProductToCart(UserProductModel userProductModel, int index) {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("My Cart")
        .doc(userProductModel.id)
        .set({
      "imageUrl": userProductModel.imageUrl,
      "name": userProductModel.name,
      "category": userProductModel.category,
      "categoryId": widget.categoryModel!.id,
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
  }

  getMyCartData() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("My Cart")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        myCartProductIds.add(element.id);
      });
    }).whenComplete(() => getProductByCategory());
  }

  getProductByCategory() async {
    try {
      await FirebaseFirestore.instance
          .collection("Shops")
          .doc(widget.categoryModel?.shopId)
          .collection("Categories")
          .doc(widget.categoryModel!.id)
          .collection("Products")
          .get()
          .then((value) => {
                if (value.size > 0)
                  {
                    value.docs.forEach((element) {
                      allProducts.add(UserProductModel(
                        element.id,
                        element.get("imageUrl"),
                        element.get("name"),
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
