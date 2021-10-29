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
      appBar: AppThemeShared.appBar(title: "Dashboard", context: context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, "/manageProducts"),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 200,
                  width: 200,
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
            )
          ],
        ),
      ),
    );
  }
}
