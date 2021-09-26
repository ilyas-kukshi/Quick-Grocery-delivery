import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:quickgrocerydelivery/screens/dashboard/dashboard_main.dart';
import 'package:quickgrocerydelivery/shared/AppThemeShared.dart';
import 'package:quickgrocerydelivery/shared/dialogs.dart';
import 'package:quickgrocerydelivery/shared/utility.dart';

class Otp extends StatefulWidget {
  const Otp({Key? key}) : super(key: key);

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  Future<FirebaseApp> firebaseApp = Firebase.initializeApp();
  String verificationIdLocal = Get.arguments;

  GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();
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
          key: otpFormKey,
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
                  child: Column(
                    children: [
                      Text(
                        'Enter Otp',
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            ?.copyWith(fontSize: 16),
                      ),
                      PinCodeTextField(
                        appContext: context,
                        length: 6,
                        controller: otpController,
                        validator: Utility.otpValidator,
                        animationType: AnimationType.scale,
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
                    ],
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
                        verifyOtp(startLoading, stopLoading, btnState);
                      })),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        child: Text(
                          'Create account',
                          style: Theme.of(context)
                              .textTheme
                              .headline3
                              ?.copyWith(
                                  fontSize: 18,
                                  decoration: TextDecoration.underline),
                        ),
                        onPressed: () {
                          Get.toNamed('/createAccount');
                        },
                      ),
                      TextButton(
                        child: Text(
                          'Forgot password',
                          style: Theme.of(context)
                              .textTheme
                              .headline3
                              ?.copyWith(
                                  fontSize: 18,
                                  decoration: TextDecoration.underline),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void verifyOtp(
      Function startLoading, Function stopLoading, ButtonState btnState) async {
    if (btnState == ButtonState.Idle) {
      final valid = otpFormKey.currentState!.validate();
      if (valid) {
        DialogShared.loadingDialog(context, "Loading...");
        final credential = PhoneAuthProvider.credential(
            verificationId: verificationIdLocal, smsCode: otpController.text);

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .catchError((e) {
          Fluttertoast.showToast(msg: e.toString());
          print(e);
        });
        Get.back();
        Get.to(DashboardMain());
      }
    }
  }
}
