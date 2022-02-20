import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickgrocerydelivery/shared/AppThemeShared.dart';
import 'package:quickgrocerydelivery/shared/dialogs.dart';
import 'package:quickgrocerydelivery/shared/utility.dart';

class ShopProfile extends StatefulWidget {
  const ShopProfile({Key? key}) : super(key: key);

  @override
  _ShopProfileState createState() => _ShopProfileState();
}

class _ShopProfileState extends State<ShopProfile> {
  final String firebaseUId = FirebaseAuth.instance.currentUser!.uid;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController shopNameController = TextEditingController();
  TextEditingController shopNumberController = TextEditingController();
  TextEditingController shopLocationController = TextEditingController();
  TextEditingController shopAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getShopDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppThemeShared.appBar(
        title: "Shop Profile",
        context: context,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          onChanged: () {},
          child: Column(
            children: [
              SizedBox(height: 30),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: AppThemeShared.textFormField(
                    context: context,
                    controller: shopNameController,
                    labelText: "Shop Name",
                    validator: Utility.shopNameValidator,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // keyboardType: TextInputType.number,
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
                    labelText: "Shop Phone Number",
                    readonly: true,
                    validator: Utility.phoneNumberValidator,
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [LengthLimitingTextInputFormatter(10)],
                    suffixIcon: Icon(
                      Icons.lock_outlined,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: AppThemeShared.textFormField(
                      context: context,
                      labelText: "Shop Location",
                      controller: shopLocationController),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: AppThemeShared.textFormField(
                    context: context,
                    labelText: "Shop Address",
                    controller: shopAddressController,
                    validator: Utility.shopAddressValidator,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                  ),
                ),
              ),
              SizedBox(height: 30),
              AppThemeShared.argonButtonShared(
                context: context,
                height: 50,
                width: MediaQuery.of(context).size.width * 0.85,
                color: AppThemeShared.buttonColor,
                borderRadius: 12,
                buttonText: "Save",
                onTap: (p0, p1, p2) {
                  final valid = formKey.currentState!.validate();
                  if (valid) {
                    DialogShared.loadingDialog(context, "Saving Profile");
                    saveShopDetails();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  getShopDetails() async {
    await FirebaseFirestore.instance
        .collection("Shops")
        .doc(firebaseUId)
        .get()
        .then((value) {
      shopNameController.text = value.get("name");
      shopNumberController.text = value.get("phoneNumber");
      shopAddressController.text = value.get("address");
    });
  }

  saveShopDetails() async {
    await FirebaseFirestore.instance
        .collection("Shops")
        .doc(firebaseUId)
        .update({
          
        }).whenComplete(() {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Profile Updated");
    });
  }
}
