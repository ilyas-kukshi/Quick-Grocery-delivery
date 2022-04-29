import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:quickgrocerydelivery/shared/dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardDrawer extends StatefulWidget {
  const DashboardDrawer({Key? key}) : super(key: key);

  @override
  _DashboardDrawerState createState() => _DashboardDrawerState();
}

class _DashboardDrawerState extends State<DashboardDrawer> {
  String? phoneNumber;
  String? name;
  String? userType;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: SafeArea(
        child: Drawer(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Row(
                  children: [
                    SizedBox(width: 20),
                    CircleAvatar(
                      child: Text(getInitials(name.toString())),
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .headline3
                              ?.copyWith(fontSize: 18),
                        ),
                        Text(
                          phoneNumber.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .headline3
                              ?.copyWith(fontSize: 18),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(height: 20),
                Divider(color: Colors.grey),
                SizedBox(height: 10),
                userType == "DeliveryExecutive"
                    ? Column(
                        children: [
                          GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, '/DEDashboard'),
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Icon(
                                  Icons.home_outlined,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "My Deliveries",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      ?.copyWith(fontSize: 18),
                                ),
                                Spacer(),
                                FutureBuilder(
                                  future: deliveryExecutiveStatus(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.hasData) {
                                        return FlutterSwitch(
                                          value: snapshot.data,
                                          onToggle: (value) {
                                            changeDeliveryExecutiveStatus(
                                                value);
                                          },
                                        );
                                      } else
                                        return Container();
                                    } else
                                      return Container();
                                  },
                                ),
                                SizedBox(width: 10),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Divider(color: Colors.grey),
                          SizedBox(height: 10),
                        ],
                      )
                    : Offstage(),
                userType == "Shop"
                    ? Column(
                        children: [
                          GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, "/shopDashboard"),
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Icon(
                                  Icons.home_outlined,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "My Shop",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      ?.copyWith(fontSize: 18),
                                ),
                                Spacer(),
                                FutureBuilder(
                                  future: shopStatus(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.hasData) {
                                        return FlutterSwitch(
                                          value: snapshot.data,
                                          onToggle: (value) {
                                            changeShopStatus(value);
                                          },
                                        );
                                      } else
                                        return Container();
                                    } else
                                      return Container();
                                  },
                                ),
                                SizedBox(width: 10),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Divider(color: Colors.grey),
                          SizedBox(height: 10),
                        ],
                      )
                    : Offstage(),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/shopsNearMe");
                  },
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Icon(
                        Icons.store_outlined,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Shops Near Me",
                        style: Theme.of(context)
                            .textTheme
                            .headline1
                            ?.copyWith(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Divider(color: Colors.grey),
                SizedBox(height: 10),

                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, "/myCart"),
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Icon(
                        Icons.shopping_cart_outlined,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "My Cart",
                        style: Theme.of(context)
                            .textTheme
                            .headline1
                            ?.copyWith(fontSize: 18),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10),
                Divider(color: Colors.grey),
                SizedBox(height: 10),
                // GestureDetector(
                //   onTap: () => Navigator.pushNamed(context, "/myAddresses"),
                //   child: Row(
                //     children: [
                //       SizedBox(width: 10),
                //       Icon(
                //         Icons.map_outlined,
                //       ),
                //       SizedBox(width: 10),
                //       Text(
                //         "My Addresses",
                //         style: Theme.of(context)
                //             .textTheme
                //             .headline1
                //             ?.copyWith(fontSize: 18),
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(height: 10),
                // Divider(color: Colors.grey),
                // SizedBox(height: 10),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, "/myOrders"),
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Icon(
                        Icons.shopping_bag_outlined,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "My Orders",
                        style: Theme.of(context)
                            .textTheme
                            .headline1
                            ?.copyWith(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Divider(color: Colors.grey),
                SizedBox(height: 10),
                userType == "Customer"
                    ? Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, "/becomeShopOwner");
                            },
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Icon(
                                  Icons.storefront_outlined,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Become a shop owner",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      ?.copyWith(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Divider(color: Colors.grey),
                          SizedBox(height: 10),
                        ],
                      )
                    : Offstage(),

                userType == "Customer"
                    ? Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, "/becomeDeliveryExecutive");
                            },
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Icon(
                                  Icons.delivery_dining_outlined,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Become a delivery executive",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      ?.copyWith(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Divider(color: Colors.grey),
                          SizedBox(height: 10),
                        ],
                      )
                    : Offstage(),
                GestureDetector(
                  onTap: () {
                    DialogShared.doubleButtonDialog(
                        context, "Are you sure you want to logout.", () {
                      clearSharedPreference();
                    }, () {
                      Navigator.pop(context);
                    });
                  },
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Icon(
                        Icons.logout_outlined,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Logout",
                        style: Theme.of(context)
                            .textTheme
                            .headline1
                            ?.copyWith(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getUserInfo() async {
    final SharedPreferences prefs = await _prefs;

    setState(() {
      name = prefs.getString('name');
      phoneNumber = prefs.getString("phoneNumber");
      userType = "DeliveryExecutive";
      // prefs.getString("type");
    });
  }

  // Future<void> getName() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   //Return String

  //   setState(() {});
  // }

  clearSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    await FirebaseAuth.instance
        .signOut()
        .whenComplete(() => Navigator.pushNamed(context, "/signIn"));
  }

  getStringValuesSF() async {
    return phoneNumber;
  }

  static String getInitials(String fullName) => fullName.isNotEmpty
      ? fullName.trim().split(' ').map((l) => l[0]).take(2).join().toUpperCase()
      : '';

  Future<bool>? shopStatus() async {
    bool enabled = false;
    await FirebaseFirestore.instance
        .collection("Shops")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      enabled = value.get("enabled");
    });
    return enabled;
  }

  Future<bool>? deliveryExecutiveStatus() async {
    bool enabled = false;
    await FirebaseFirestore.instance
        .collection("DeliveryExecutives")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      enabled = value.get("enabled");
    });
    return enabled;
  }

  void changeShopStatus(bool value) async {
    await FirebaseFirestore.instance
        .collection("Shops")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "enabled": value,
    });
  }

  void changeDeliveryExecutiveStatus(bool value) async {
    await FirebaseFirestore.instance
        .collection("DeliveryExecutives")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "enabled": value,
    });
  }
}
