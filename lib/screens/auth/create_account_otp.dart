import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:quickgrocerydelivery/models/usermodel.dart';
import 'package:quickgrocerydelivery/shared/AppThemeShared.dart';
import 'package:quickgrocerydelivery/shared/dialogs.dart';
import 'package:quickgrocerydelivery/shared/utility.dart';

class CreateAccountOtp extends StatefulWidget {
  final UserModel? userModel;
  const CreateAccountOtp({Key? key, this.userModel}) : super(key: key);

  @override
  _CreateAccountOtpState createState() => _CreateAccountOtpState();
}

class _CreateAccountOtpState extends State<CreateAccountOtp> {
  Future<FirebaseApp> firebaseApp = Firebase.initializeApp();

  GlobalKey<FormState> createAccountOtpFormKey = GlobalKey<FormState>();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppThemeShared.appBar(
          title: 'Login',
          context: context,
          backgroundColor: Colors.black,
          centerTitle: true),
      body: SingleChildScrollView(
        child: Form(
          key: createAccountOtpFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Center(
                child: Text(
                  'Welcome to\n Quick Grocery Delivery',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      ?.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 50),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: PinCodeTextField(
                    appContext: context,
                    length: 6,
                    controller: otpController,
                    animationType: AnimationType.scale,
                    validator: Utility.otpValidator,
                    keyboardType: TextInputType.number,
                    onChanged: (otp) {
                      // verifyOtp(otp);
                    },
                    pinTheme: PinTheme(
                        borderRadius: BorderRadius.circular(12),
                        activeColor: Colors.black,
                        inactiveColor: Colors.black,
                        selectedColor: AppThemeShared.buttonColor),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Center(
                  child: AppThemeShared.argonButtonShared(
                      context: context,
                      height: 50,
                      borderRadius: 12,
                      width: MediaQuery.of(context).size.width * 0.85,
                      color: AppThemeShared.buttonColor,
                      buttonText: "Login",
                      onTap: (startLoading, stopLoading, btnState) {
                        if (otpController.text.length == 6) {
                          verifyOtp();
                        } else {
                          Fluttertoast.showToast(msg: "Please enter valid OTP");
                        }
                      })),
            ],
          ),
        ),
      ),
    );
  }

  void verifyOtp() async {
    final valid = createAccountOtpFormKey.currentState!.validate();
    if (valid) {
      DialogShared.loadingDialog(context, "Loading...");

      final credential = PhoneAuthProvider.credential(
          verificationId: widget.userModel!.verificationId,
          smsCode: otpController.text);

      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .catchError((e) {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: e.toString());
        print(e);
      });
      if (FirebaseAuth.instance.currentUser != null) {
        FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .set({
          'name': widget.userModel!.name,
          'phoneNumber': widget.userModel!.phoneNumber,
          'type': "Customer",
          'enabled': true
        }).whenComplete(() {
          Navigator.pop(context);
          Navigator.pushNamed(context, "/dashboardMain");
        });
      }
    }
  }
}
