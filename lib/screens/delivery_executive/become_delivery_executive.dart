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

class BecomeDeliveryExecutive extends StatefulWidget {
  const BecomeDeliveryExecutive({Key? key}) : super(key: key);

  @override
  State<BecomeDeliveryExecutive> createState() =>
      _BecomeDeliveryExecutiveState();
}

class _BecomeDeliveryExecutiveState extends State<BecomeDeliveryExecutive> {
  Position? currentPosition;
  GlobalKey<FormState> becomeDeliveryExecutiveForm = GlobalKey<FormState>();
  TextEditingController executiveNameController = TextEditingController();

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController locationController = TextEditingController();

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
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          title: "Become Delivery Executive",
          context: context),
      body: SingleChildScrollView(
        child: Form(
          key: becomeDeliveryExecutiveForm,
          child: Column(
            children: [
              SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: AppThemeShared.textFormField(
                    context: context,
                    validator: Utility.shopNameValidator,
                    labelText: 'Your name \*',
                    controller: executiveNameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: AppThemeShared.textFormField(
                      context: context,
                      labelText: 'Your phone number \*',
                      controller: phoneNumberController,
                      validator: Utility.phoneNumberValidator,
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                      readonly: true,
                      inputFormatters: [LengthLimitingTextInputFormatter(10)]),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Column(
                    children: [
                      AppThemeShared.textFormField(
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
                      ),
                      const SizedBox(height: 4),
                      Text(
                          'You will receive delivery request from the shops inside 3km of your set location.')
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              AppThemeShared.argonButtonShared(
                context: context,
                height: 50,
                borderRadius: 12,
                width: MediaQuery.of(context).size.width * 0.85,
                color: AppThemeShared.buttonColor,
                buttonText: "Next",
                onTap: (p0, p1, p2) {
                  final valid =
                      becomeDeliveryExecutiveForm.currentState!.validate();

                  if (valid) {
                    addDeliveryExecutive();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  addDeliveryExecutive() {
    GeoFirePoint location = Geoflutterfire().point(
        latitude: currentPosition!.latitude,
        longitude: currentPosition!.longitude);
    try {
      FirebaseFirestore.instance
          .collection("DeliveryExecutives")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set({
        "name": executiveNameController.text,
        "phoneNumber": phoneNumberController.text,
        "location": location.data,
        "enabled": true
      }).whenComplete(() {
        try {
          FirebaseFirestore.instance
              .collection("Users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({"type": "DeliveryExecutive"}).whenComplete(() {
            Navigator.pushNamed(context, "/dashboardMain");
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
