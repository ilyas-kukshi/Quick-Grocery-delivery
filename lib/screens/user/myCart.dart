import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickgrocerydelivery/models/productModel.dart';
import 'package:quickgrocerydelivery/shared/AppThemeShared.dart';
import 'package:quickgrocerydelivery/shared/dialogs.dart';
import 'package:quickgrocerydelivery/shared/utility.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCart extends StatefulWidget {
  const MyCart({Key? key}) : super(key: key);

  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<ProductModel> myCartProducts = [];
  int totalPrice = 0;
  String address = '';
  var _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    getMyCartProducts();
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
          title: "My Cart",
          context: context),
      body: myCartProducts.isNotEmpty
          ? Column(
              children: [
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: myCartProducts.length,
                    itemExtent: 200,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Stack(
                            children: [
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                    ),
                                    child: CachedNetworkImage(
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      height: 200,
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      imageUrl: myCartProducts[index].imageUrl,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        myCartProducts[index].name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3!
                                            .copyWith(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        myCartProducts[index].category,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3!
                                            .copyWith(fontSize: 18),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        myCartProducts[index].shopName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3!
                                            .copyWith(fontSize: 18),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "₹" +
                                            myCartProducts[index].price +
                                            " " +
                                            myCartProducts[index].type,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1!
                                            .copyWith(fontSize: 22),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () =>
                                                subtractFromQuantity(index),
                                            child: Container(
                                                height: 35,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: AppThemeShared
                                                            .buttonColor),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(8),
                                                      bottomLeft:
                                                          Radius.circular(8),
                                                    )),
                                                child: Icon(
                                                  Icons.remove_outlined,
                                                  color: Colors.black,
                                                )),
                                          ),
                                          GestureDetector(
                                            child: Container(
                                              height: 35,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: AppThemeShared
                                                        .buttonColor),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  myCartProducts[index]
                                                      .quantity
                                                      .toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline1!
                                                      .copyWith(fontSize: 20),
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () => addIntoQuantity(index),
                                            child: Container(
                                                height: 35,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: AppThemeShared
                                                            .buttonColor),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(8),
                                                      bottomRight:
                                                          Radius.circular(8),
                                                    )),
                                                child: Icon(
                                                  Icons.add_outlined,
                                                  color: Colors.black,
                                                )),
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                              !myCartProducts[index].available!
                                  ? Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Colors.grey[200]!
                                              .withOpacity(0.8)),
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
                                  : Offstage(),
                              GestureDetector(
                                onTap: () {
                                  removeProductFromCart(index);
                                },
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(right: 8, top: 8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: Icon(
                                        Icons.close_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
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
            )
          : Column(
              children: [
                SizedBox(height: 30),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Image.asset("assets/images/myCartEmpty.jpg",
                        fit: BoxFit.fill)),
                SizedBox(height: 20),
                Text(
                  "Cart is empty",
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: 30),
                ),
                SizedBox(height: 20),
                ArgonButton(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.85,
                  color: AppThemeShared.buttonColor,
                  borderRadius: 12,
                  child: Text(
                    "Lets do some shopping!",
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        ?.copyWith(fontSize: 25),
                  ),
                  loader: Container(
                    padding: EdgeInsets.all(10),
                    child: SpinKitRotatingCircle(
                      color: Colors.white,
                      // size: loaderWidth ,
                    ),
                  ),
                  onTap: (startLoading, stopLoading, btnState) {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
      bottomNavigationBar: myCartProducts.isNotEmpty
          ? Container(
              height: 80,
              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Text(
                          "Total Price: ",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(fontSize: 20),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "₹" + totalPrice.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  AppThemeShared.argonButtonShared(
                      context: context,
                      height: 50,
                      width: 150,
                      borderRadius: 12,
                      color: AppThemeShared.buttonColor,
                      buttonText: "Checkout",
                      onTap: (p1, p2, p3) {
                        addressDialog();
                      })
                ],
              ),
            )
          : Offstage(),
    );
  }

  getMyCartProducts() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("My Cart")
        .get()
        .then((value) {
      if (value.size > 0) {
        value.docs.forEach((element) {
          FirebaseFirestore.instance
              .collection("Shops")
              .doc(element.get("shopId"))
              .collection("All Products")
              .doc(element.id)
              .get()
              .then((value) {
            myCartProducts.add(ProductModel(
              element.id,
              element.get("imageUrl"),
              element.get("name"),
              element.get("category"),
              element.get("price"),
              element.get("type"),
              element.get("shopName"),
              element.get("shopId"),
              true,
              element.get("quantity"),
              value.get("available"),
              element.get("dbProductId"),
            ));
            setState(() {});
          }).whenComplete(() => totalOrderPrice());
        });
      }
    }).whenComplete(() => {});
  }

  subtractFromQuantity(int index) {
    if (myCartProducts[index].quantity != 1) {
      DialogShared.loadingDialog(context, "");

      FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("My Cart")
          .doc(myCartProducts[index].id)
          .update({"quantity": --myCartProducts[index].quantity}).whenComplete(
              () {
        myCartProducts.clear();
        getMyCartProducts();
        Navigator.pop(context);
      });
    }
  }

  addIntoQuantity(int index) {
    if (myCartProducts[index].quantity < 10) {
      DialogShared.loadingDialog(context, "");

      FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("My Cart")
          .doc(myCartProducts[index].id)
          .update({"quantity": ++myCartProducts[index].quantity}).whenComplete(
              () {
        myCartProducts.clear();
        getMyCartProducts();
        Navigator.pop(context);
      });
    }
  }

  totalOrderPrice() {
    totalPrice = 0;
    int productPrice = 0;
    if (myCartProducts.isNotEmpty) {
      myCartProducts.forEach((element) {
        if (element.available!) {
          productPrice = 0;
          productPrice = element.quantity * int.parse(element.price);
          totalPrice += productPrice;
        }
      });
      setState(() {});
    }
  }

  removeProductFromCart(int index) {
    DialogShared.loadingDialog(context, "Removing...");
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("My Cart")
        .doc(myCartProducts[index].id)
        .delete()
        .whenComplete(() {
      myCartProducts.clear();
      getMyCartProducts();
      Navigator.pop(context);
      setState(() {});
    });
  }

  razorpayInitialization() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    var options = {
      'key': 'rzp_test_Cp2zDxiSmm432f',
      'amount': totalPrice * 100,
      'name': 'Quick Grocery Delivery',
      // 'description': 'Fine T-Shirt',
      'prefill': {'contact': '9987655052'}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    DialogShared.loadingDialog(context, "Placing your order");
    SharedPreferences userData = await _prefs;

    myCartProducts.forEach((product) {
      if (product.available!) {
        FirebaseFirestore.instance
            .collection("Shops")
            .doc(product.shopId)
            .collection("Orders")
            .add({
          "imageUrl": product.imageUrl,
          "name": product.name,
          "price": product.price,
          "quantity": product.quantity,
          "category": product.category,
          "status": "Requested",
          "timeStamp": FieldValue.serverTimestamp(),
          "orderDate": DateTime.now().toString(),
          "type": product.type,
          "shopName": product.shopName,
          "shopId": product.shopId,
          "dbProductId": product.dbProductId,
          "userName": userData.getString("name"),
          "userPhnNumber": userData.getString("phoneNumber"),
          "userId": userData.getString("userId"),
          "userAddress": address,
          "paymentId": response.paymentId
        }).then((doc) {
          FirebaseFirestore.instance
              .collection("Users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("Orders")
              .doc(doc.id)
              .set({
            "imageUrl": product.imageUrl,
            "name": product.name,
            "price": product.price,
            "quantity": product.quantity,
            "category": product.category,
            "status": "Requested",
            "timeStamp": FieldValue.serverTimestamp(),
            "orderDate": DateTime.now().toString(),
            "type": product.type,
            "shopName": product.shopName,
            "shopId": product.shopId,
            "dbProductId": product.dbProductId,
            "userName": userData.getString("name"),
            "userPhnNumber": userData.getString("phoneNumber"),
            "userId": userData.getString("userId"),
            "userAddress": address,
            "paymentId": response.paymentId
          }).whenComplete(() {
            myCartProducts.forEach((element) {
              FirebaseFirestore.instance
                  .collection("Users")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection("My Cart")
                  .doc(element.id)
                  .delete();
            });

            myCartProducts.clear();
            Navigator.pop(context);
            Navigator.pop(context);
            setState(() {});
          });
        });
      }
    });
    Fluttertoast.showToast(msg: "Successful");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails

    if (response.code == 2) {
      Fluttertoast.showToast(msg: "Payment Cancelled");
    } else
      Fluttertoast.showToast(msg: response.message.toString());
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  addressDialog() {
    TextEditingController addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            height: 260,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.all(12),
                    child: AppThemeShared.textFormField(
                        context: context,
                        hintText: 'Please enter your full address',
                        maxLines: 5,
                        controller: addressController,
                        validator: Utility.addressValidator,
                        textInputAction: TextInputAction.done)),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: AppThemeShared.argonButtonShared(
                      context: context,
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      borderRadius: 12,
                      color: AppThemeShared.buttonColor,
                      buttonText: "Checkout",
                      onTap: (p0, p1, p2) {
                        if (addressController.text.isNotEmpty) {
                          if (totalPrice > 0) {
                            address = addressController.text;
                            razorpayInitialization();
                          } else
                            Fluttertoast.showToast(
                                msg: "Please do some shopping first");
                        } else {
                          Fluttertoast.showToast(
                              msg: "Please enter your address");
                        }
                      }),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
}
