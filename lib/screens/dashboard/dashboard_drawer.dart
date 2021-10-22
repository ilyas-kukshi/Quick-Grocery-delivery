import 'package:flutter/material.dart';
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
                // GestureDetector(
                //   child: Row(
                //     children: [
                //       SizedBox(width: 10),
                //       Icon(
                //         Icons.home_outlined,
                //       ),
                //       SizedBox(width: 10),
                //       Text(
                //         "Home",
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
                userType == "Shop"
                    ? Column(
                        children: [
                          GestureDetector(
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

                //
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
      userType = prefs.getString("type");
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
    Navigator.pushNamed(context, "/signIn");
  }

  getStringValuesSF() async {
    return phoneNumber;
  }

  static String getInitials(String fullName) => fullName.isNotEmpty
      ? fullName.trim().split(' ').map((l) => l[0]).take(2).join().toUpperCase()
      : '';
}
