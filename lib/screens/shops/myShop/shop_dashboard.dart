import 'package:flutter/material.dart';
import 'package:quickgrocerydelivery/shared/AppThemeShared.dart';

class ShopDashboard extends StatefulWidget {
  const ShopDashboard({Key? key}) : super(key: key);

  @override
  _ShopDashboardState createState() => _ShopDashboardState();
}

class _ShopDashboardState extends State<ShopDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppThemeShared.appBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios, color: Colors.white)),
          title: "Dashboard",
          context: context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, "/manageProducts"),
                      child: Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: AppThemeShared.buttonColor, width: 3)),
                        child: Center(
                          child: Text("Manage \nProducts",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(fontSize: 24, letterSpacing: 1.5)),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, "/selectProductsCategories"),
                      child: Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: AppThemeShared.buttonColor, width: 3)),
                        child: Center(
                          child: Text("Select \nProducts",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(fontSize: 24, letterSpacing: 1.5)),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, "/manageOrders"),
                      child: Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: AppThemeShared.buttonColor, width: 3)),
                        child: Center(
                          child: Text("Manage \nOrders",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(fontSize: 24, letterSpacing: 1.5)),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, "/myShopProfile"),
                      child: Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: AppThemeShared.buttonColor, width: 3)),
                        child: Center(
                          child: Text("Shop \nProfile",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(fontSize: 24, letterSpacing: 1.5)),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
