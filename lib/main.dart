import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quickgrocerydelivery/models/categoryModel.dart';
import 'package:quickgrocerydelivery/models/usermodel.dart';
import 'package:quickgrocerydelivery/screens/auth/create_account.dart';
import 'package:quickgrocerydelivery/screens/auth/create_account_otp.dart';
import 'package:quickgrocerydelivery/screens/auth/otp.dart';
import 'package:quickgrocerydelivery/screens/auth/signin.dart';
import 'package:quickgrocerydelivery/screens/dashboard/dashboard_main.dart';
import 'package:quickgrocerydelivery/screens/dashboard/dashboard_product_by_category.dart';
import 'package:quickgrocerydelivery/screens/dashboard/shopDetail/product_by_categories.dart';
import 'package:quickgrocerydelivery/screens/dashboard/shopDetail/shopDetailed.dart';
import 'package:quickgrocerydelivery/screens/delivery_executive/become_delivery_executive.dart';
import 'package:quickgrocerydelivery/screens/delivery_executive/de_dashboard.dart';
import 'package:quickgrocerydelivery/screens/delivery_executive/de_to_shop_directions.dart';
import 'package:quickgrocerydelivery/screens/delivery_executive/set_de_location.dart';
import 'package:quickgrocerydelivery/screens/delivery_executive/shop_to_user_directions.dart';
import 'package:quickgrocerydelivery/screens/shops/become_shop_owner.dart';
import 'package:quickgrocerydelivery/screens/shops/myShop/change_shop_location.dart';
import 'package:quickgrocerydelivery/screens/shops/myShop/manage_shop_orders.dart';
import 'package:quickgrocerydelivery/screens/shops/myShop/manage_shop_products.dart';
import 'package:quickgrocerydelivery/screens/shops/myShop/shop_dashboard.dart';
import 'package:quickgrocerydelivery/screens/shops/myShop/shop_profile.dart';
import 'package:quickgrocerydelivery/screens/shops/selectproducts/categories.dart';
import 'package:quickgrocerydelivery/screens/shops/selectproducts/products.dart';
import 'package:quickgrocerydelivery/screens/shops/setLocationShop.dart';
import 'package:quickgrocerydelivery/screens/user/myCart.dart';
import 'package:quickgrocerydelivery/screens/user/myOrders.dart';
import 'package:quickgrocerydelivery/screens/user/setLocation.dart';
import 'package:quickgrocerydelivery/screens/user/shops_near_me.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      locale: Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.white,
        buttonTheme: ButtonThemeData(buttonColor: Color(0xff33D1DB)),
        textTheme: TextTheme(
            headline1:
                TextStyle(color: Colors.black, fontFamily: 'Times New Roman'),
            headline2:
                TextStyle(color: Colors.white, fontFamily: 'Times New Roman'),
            headline3:
                TextStyle(color: Colors.black, fontFamily: 'Source Sans Pro'),
            headline4:
                TextStyle(color: Colors.white, fontFamily: 'Source Sans Pro')),
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: routing,
      home: DashboardMain(),
    );
  }

  Route routing(RouteSettings settings) {
    switch (settings.name) {

      //user
      case '/signIn':
        return PageTransition(
            child: SignIn(), type: PageTransitionType.leftToRight);
      case '/createAccount':
        return PageTransition(
            child: CreateAccount(
              phoneNumber: settings.arguments as String,
            ),
            type: PageTransitionType.leftToRight);
      case '/otp':
        return PageTransition(
          child: Otp(
            data: settings.arguments as String,
          ),
          type: PageTransitionType.leftToRight,
        );

      case '/createAccountOtp':
        return PageTransition(
            child: CreateAccountOtp(
              userModel: settings.arguments as UserModel,
            ),
            type: PageTransitionType.leftToRight);

      case '/createAccountOtp':
        return PageTransition(
            child: CreateAccountOtp(), type: PageTransitionType.leftToRight);

      //user
      case '/dashboardMain':
        return PageTransition(
            child: DashboardMain(), type: PageTransitionType.leftToRight);

      case '/setLocation':
        return PageTransition(
            child: SetLocation(
              initialPosition: settings.arguments as GeoPoint,
            ),
            type: PageTransitionType.leftToRight);
      // case '/myAddresses':
      //   return PageTransition(
      //       child: MyAdresses(), type: PageTransitionType.leftToRight);
      case '/becomeShopOwner':
        return PageTransition(
            child: BecomeShopOwner(), type: PageTransitionType.leftToRight);

      //folder name with file name
      case '/selectProductsCategories':
        return PageTransition(
            child: Categories(), type: PageTransitionType.leftToRight);
      case '/selectProductsProducts':
        return PageTransition(
            child: Products(category: settings.arguments as CategoryModel),
            type: PageTransitionType.leftToRight);
      case '/shopDetailed':
        return PageTransition(
            child: ShopDetailed(
              shopDoc: settings.arguments as DocumentSnapshot,
            ),
            type: PageTransitionType.leftToRight);

      case '/productByCategory':
        return PageTransition(
            child: ProductByCategory(
              categoryModel: settings.arguments as CategoryModel,
            ),
            type: PageTransitionType.leftToRight);
      case '/myCart':
        return PageTransition(
            child: MyCart(), type: PageTransitionType.leftToRight);
      case '/shopsNearMe':
        return PageTransition(
            child: ShopsNearMe(), type: PageTransitionType.leftToRight);
      case '/shopDashboard':
        return PageTransition(
            child: ShopDashboard(), type: PageTransitionType.leftToRight);
      case '/changeShopLocation':
        return PageTransition(
            child: ChangeShopLocation(
              initialPosition: settings.arguments as GeoPoint,
            ),
            type: PageTransitionType.leftToRight);
      
      case '/manageProducts':
        return PageTransition(
            child: ManageProducts(), type: PageTransitionType.leftToRight);
      case '/manageOrders':
        return PageTransition(
            child: ManageOrders(), type: PageTransitionType.leftToRight);
      case '/myOrders':
        return PageTransition(
            child: MyOrders(), type: PageTransitionType.leftToRight);
      case '/dashboardProductByCategory':
        return PageTransition(
            child: DashboardProductByCategory(
                categoryModel: settings.arguments as CategoryModel),
            type: PageTransitionType.leftToRight);
      case '/setLocationShop':
        return PageTransition(
            child: SetLocationShop(), type: PageTransitionType.leftToRight);
      case '/myShopProfile':
        return PageTransition(
            child: ShopProfile(), type: PageTransitionType.leftToRight);

      //delivery executive
      case '/becomeDeliveryExecutive':
        return PageTransition(
            child: BecomeDeliveryExecutive(),
            type: PageTransitionType.leftToRight);
      case '/DEDashboard':
        return PageTransition(
            child: DEDashboard(), type: PageTransitionType.leftToRight);
      case '/setDELocation':
        return PageTransition(
            child: SetDELocation(
              initialPosition: settings.arguments as GeoPoint,
            ),
            type: PageTransitionType.leftToRight);
      case '/DeToShopDirections':
        return PageTransition(
            child: DeToShopDirections(
              deliveryDetails: settings.arguments as DocumentSnapshot,
            ),
            type: PageTransitionType.leftToRight);
      case '/ShopToUserDirections':
        return PageTransition(
            child: ShopToUserDirection(
              deliveryDetails: settings.arguments as DocumentSnapshot,
            ),
            type: PageTransitionType.leftToRight);

      default:
        return PageTransition(
            child: SignIn(), type: PageTransitionType.leftToRight);
    }
  }
}
