import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickgrocerydelivery/shared/AppThemeShared.dart';
import 'package:quickgrocerydelivery/shared/utility.dart';

class ManageProducts extends StatefulWidget {
  const ManageProducts({Key? key}) : super(key: key);

  @override
  _ManageProductsState createState() => _ManageProductsState();
}

class _ManageProductsState extends State<ManageProducts> {
  String selectedCategory = 'All Products';
  List<String> categoryId = [];
  List<String> categoryName = ['All Products'];

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppThemeShared.appBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios, color: Colors.white)),
          actions: [
            GestureDetector(
              onTap: () => showRequestProductDialog(),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10),
          ],
          title: "Manage Products",
          context: context),
      body: Column(
        children: [
          SizedBox(height: 30),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(12)),
              child: DropdownButton<String>(
                value: selectedCategory,
                items:
                    categoryName.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                isExpanded: true,
                iconSize: 24,
                elevation: 16,
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    ?.copyWith(fontSize: 16),
                underline: Offstage(),
                onChanged: (String? newValue) {
                  selectedCategory = newValue!;

                  setState(() {});
                },
              ),
            ),
          ),
          SizedBox(height: 30),
          Expanded(
            child: StreamBuilder(
              stream: selectedCategory == "All Products"
                  ? FirebaseFirestore.instance
                      .collection("Shops")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("All Products")
                      .snapshots(includeMetadataChanges: true)
                  : FirebaseFirestore.instance
                      .collection("Shops")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("All Products")
                      .where("category", isEqualTo: selectedCategory)
                      .snapshots(includeMetadataChanges: true),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.data?.docs.length > 0) {
                    return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Stack(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(12),
                                              bottomLeft: Radius.circular(12)),
                                          child: CachedNetworkImage(
                                            height: 150,
                                            width: 150,
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                SizedBox(
                                              height: 80,
                                              width: 80,
                                              child: CircularProgressIndicator(
                                                  value: downloadProgress
                                                      .progress),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                            imageUrl: snapshot.data?.docs[index]
                                                ["imageUrl"],
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data?.docs[index]
                                                  ["name"],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline1
                                                  ?.copyWith(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                                snapshot.data?.docs[index]
                                                    ["category"],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline3
                                                    ?.copyWith(
                                                      fontSize: 16,
                                                    )),
                                            SizedBox(height: 8),
                                            Text(
                                                "₹" +
                                                    snapshot.data?.docs[index]
                                                        ["price"] +
                                                    " per " +
                                                    snapshot.data?.docs[index]
                                                        ["type"],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline3
                                                    ?.copyWith(
                                                      fontSize: 16,
                                                    )),
                                            SizedBox(height: 8),
                                            FlutterSwitch(
                                              width: 150.0,
                                              height: 35.0,
                                              toggleSize: 45.0,
                                              activeColor:
                                                  AppThemeShared.buttonColor,
                                              inactiveColor: Colors.red,
                                              value: snapshot.data?.docs[index]
                                                  ["available"],
                                              borderRadius: 12.0,
                                              padding: 6.0,
                                              showOnOff: true,
                                              activeText: "In Stock",
                                              inactiveText: "Out of stock",
                                              activeTextColor: Colors.white,
                                              inactiveTextColor: Colors.white,
                                              valueFontSize: 16,
                                              onToggle: (val) {
                                                setAvaillability(
                                                    snapshot.data?.docs[index],
                                                    index);
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                              ),
                              popupMenu(snapshot.data?.docs[index], index)
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text(
                        "No Products Available in this category.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline1
                            ?.copyWith(fontSize: 24),
                      ),
                    );
                  }
                } else {
                  return Container();
                }
              },
            ),
          ),
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
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Categories")
          .get()
          .then((value) => {
                value.docs.forEach((element) {
                  categoryId.add(element.id);
                  categoryName.add(element["name"]);
                })
              });
      setState(() {});
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Widget popupMenu(DocumentSnapshot snapshot, int index) {
    TextEditingController changePriceController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Align(
        alignment: Alignment.topRight,
        child: PopupMenuButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: Container(
                                height: 120,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: AppThemeShared.textFormField(
                                      context: context,
                                      labelText: 'Change Price',
                                      hintText: snapshot.get("price"),
                                      controller: changePriceController,
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.number,
                                      onFieldSubmitted: (price) {
                                        int categoryIndex =
                                            categoryName.indexOf(
                                          snapshot["category"],
                                        );
                                        try {
                                          FirebaseFirestore.instance
                                              .collection("Shops")
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .collection("All Products")
                                              .doc(snapshot.id)
                                              .update({"price": price});
                                          FirebaseFirestore.instance
                                              .collection("Shops")
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .collection("Categories")
                                              .doc(
                                                  categoryId[categoryIndex - 1])
                                              .collection("Products")
                                              .doc(snapshot.id)
                                            ..update({"price": price})
                                                .whenComplete(() {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            });
                                        } on FirebaseException catch (e) {
                                          Fluttertoast.showToast(
                                              msg: e.toString());
                                        }
                                      },
                                    )),
                              ),
                            );
                          },
                        );
                      },
                      child: Text("Change Price",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(fontSize: 16)),
                    ),
                    SizedBox(height: 8),
                    Divider(
                      color: Colors.grey,
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        int categoryIndex = categoryName.indexOf(
                          snapshot["category"],
                        );
                        try {
                          FirebaseFirestore.instance
                              .collection("Shops")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection("All Products")
                              .doc(snapshot.id)
                              .delete();
                          FirebaseFirestore.instance
                              .collection("Shops")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection("Categories")
                              .doc(categoryId[categoryIndex - 1])
                              .collection("Products")
                              .doc(snapshot.id)
                              .delete()
                              .whenComplete(() => Navigator.pop(context));
                        } on FirebaseException catch (e) {
                          Fluttertoast.showToast(msg: e.toString());
                        }
                      },
                      child: Text("Delete",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(fontSize: 16)),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              )
            ];
          },
        ),
      ),
    );
  }

  setAvaillability(DocumentSnapshot snapshot, int index) {
    setState(() {
      int categoryIndex = categoryName.indexOf(
        snapshot["category"],
      );
      try {
        FirebaseFirestore.instance
            .collection("Shops")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("All Products")
            .doc(snapshot.id)
            .update({
          "available": !snapshot["available"],
        });
        FirebaseFirestore.instance
            .collection("Shops")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Categories")
            .doc(categoryId[categoryIndex - 1])
            .collection("Products")
            .doc(snapshot.id)
            .update({
          "available": !snapshot["available"],
        });
      } on FirebaseException catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
    });
  }

  showRequestProductDialog() {
    TextEditingController requestedProductNameController =
        new TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    "Request the name of the product",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(fontSize: 24),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: AppThemeShared.textFormField(
                      context: context,
                      hintText: 'Enter product name',
                      controller: requestedProductNameController,
                      autoFocus: true,
                      validator: Utility.requestedProducNameValidator,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onFieldSubmitted: (p0) {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppThemeShared.sharedRaisedButton(
                          context: context,
                          height: 50,
                          width: 100,
                          borderRadius: 12,
                          color: Colors.red,
                          buttonText: "Cancel",
                          onPressed: () => Navigator.pop(context),
                        ),
                        SizedBox(width: 8),
                        AppThemeShared.sharedRaisedButton(
                          context: context,
                          height: 50,
                          width: 100,
                          borderRadius: 12,
                          color: Colors.green,
                          buttonText: "Request",
                          onPressed: () {
                            if (requestedProductNameController
                                .text.isNotEmpty) {
                              FirebaseFirestore.instance
                                  .collection("Product Requests")
                                  .add({
                                "productName":
                                    requestedProductNameController.text,
                                "shopId":
                                    FirebaseAuth.instance.currentUser!.uid,
                              }).whenComplete(() {
                                Fluttertoast.showToast(
                                    msg:
                                        "Thank you for your patience. We will add this product soon.",
                                    toastLength: Toast.LENGTH_LONG);
                                Navigator.pop(context);
                              });
                            }
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
