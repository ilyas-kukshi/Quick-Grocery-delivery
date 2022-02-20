import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quickgrocerydelivery/shared/AppThemeShared.dart';
import 'package:quickgrocerydelivery/shared/utility.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BecomeShopOwner extends StatefulWidget {
  const BecomeShopOwner({Key? key}) : super(key: key);

  @override
  _BecomeShopOwnerState createState() => _BecomeShopOwnerState();
}

class _BecomeShopOwnerState extends State<BecomeShopOwner> {
  Position? currentPosition;
  GlobalKey<FormState> becomeShopOwnerForm = GlobalKey<FormState>();
  TextEditingController shopNameController = TextEditingController();

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController shopAddressController = TextEditingController();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    setPhoneNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppThemeShared.appBar(
        title: "Become Shop Owner",
        context: context,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: becomeShopOwnerForm,
            child: Column(
              children: [
                SizedBox(height: 30),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: AppThemeShared.textFormField(
                      context: context,
                      validator: Utility.shopNameValidator,
                      labelText: 'Shop name \*',
                      controller: shopNameController,
                      // validator: Utility.phoneNumberValidator,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: AppThemeShared.textFormField(
                        context: context,
                        labelText: 'Shop phone number \*',
                        controller: phoneNumberController,
                        validator: Utility.phoneNumberValidator,
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.next,
                        readonly: true,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10)
                        ]),
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: AppThemeShared.textFormField(
                        context: context,
                        labelText: "Shop location",
                        hintText: 'Set shop location \*',
                        controller: locationController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        readonly: true,
                        onTap: () {
                          showLocationDialog();
                        },
                        suffixIcon: Icon(
                          Icons.pin_drop_outlined,
                          color: Colors.black,
                        ),
                        validator: Utility.shopLocationValidator,
                        textInputAction: TextInputAction.next,
                      )),
                ),
                SizedBox(height: 30),
                Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: AppThemeShared.textFormField(
                        context: context,
                        minLines: null,
                        maxLines: 5,
                        labelText: 'Enter shop address \*',
                        controller: shopAddressController,
                        validator: Utility.shopAddressValidator,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        // keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                      )),
                ),
                SizedBox(height: 50),
                AppThemeShared.argonButtonShared(
                  context: context,
                  height: 50,
                  borderRadius: 12,
                  width: MediaQuery.of(context).size.width * 0.85,
                  color: AppThemeShared.buttonColor,
                  buttonText: "Next",
                  onTap: (p0, p1, p2) {
                    final valid = becomeShopOwnerForm.currentState!.validate();

                    if (valid) {
                      addShop();
                    }
                  },
                )
              ],
            )),
      ),
    );
  }

  addShop() {
    GeoFirePoint location = Geoflutterfire().point(
        latitude: currentPosition!.latitude,
        longitude: currentPosition!.longitude);
    try {
      FirebaseFirestore.instance
          .collection("Shops")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set({
        "name": shopNameController.text,
        "phoneNumber": phoneNumberController.text,
        "location": location.data,
        "address": shopAddressController.text,
        "enabled": true
      }).whenComplete(() {
        try {
          FirebaseFirestore.instance
              .collection("Users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({"type": "Shop"}).whenComplete(() {
            Navigator.pushNamed(context, "/selectProductsCategories");
          });
        } on FirebaseException catch (e) {
          Fluttertoast.showToast(msg: e.toString());
        }
      });
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  showLocationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Column(
            children: [
              GestureDetector(
                onTap: () => getCurrentLocation(),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select current location",
                        style: Theme.of(context)
                            .textTheme
                            .headline3!
                            .copyWith(fontSize: 16),
                      ),
                      Icon(
                        Icons.gps_fixed_outlined,
                      ),
                    ]),
              ),
              SizedBox(height: 10),
              Divider(
                color: Colors.grey,
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  _navigateAndDisplaySelection(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Select location on map",
                      style: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(fontSize: 16),
                    ),
                    Icon(
                      Icons.location_on_outlined,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  setPhoneNumber() async {
    SharedPreferences userData = await SharedPreferences.getInstance();
    phoneNumberController.text = userData.getString("phoneNumber")!;
  }

  void getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: "QGD needs to know your location");
      LocationPermission permissionAsked = await Geolocator.requestPermission();
      if (permissionAsked == LocationPermission.always ||
          permissionAsked == LocationPermission.whileInUse) {
        getCurrentLocation();
      }
    } else if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      // GeoFirePoint location = Geoflutterfire().point(
      //     latitude: currentPosition!.latitude,
      //     longitude: currentPosition!.longitude);
      // FirebaseFirestore.instance
      //     .collection("Shops")
      //     .doc(FirebaseAuth.instance.currentUser?.uid)
      //     .update({"location": location.data});
      getAddressFromLatLong(
          currentPosition!.latitude, currentPosition!.longitude);
      Navigator.pop(context);
    }
  }

  Future<void> getAddressFromLatLong(double latitude, double longitude) async {  
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);

    Placemark place = placemarks[0];
    setState(() {
      locationController.text = '${place.subLocality}, ${place.locality}';
    });
    // print(Address);
  }

  setUserDataSP() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("type", "Shop");
  }

  void _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: "QGD needs to know your location");
      LocationPermission permissionAsked = await Geolocator.requestPermission();
      if (permissionAsked == LocationPermission.always ||
          permissionAsked == LocationPermission.whileInUse) {
        GeoFirePoint result =
            await Navigator.pushNamed(context, "/setLocationShop")
                as GeoFirePoint;
        getAddressFromLatLong(result.latitude, result.longitude);

        Navigator.pop(context);
      }
    } else if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      GeoFirePoint result =
          await Navigator.pushNamed(context, "/setLocationShop")
              as GeoFirePoint;
      getAddressFromLatLong(result.latitude, result.longitude);

      Navigator.pop(context);
    }
  }
}
