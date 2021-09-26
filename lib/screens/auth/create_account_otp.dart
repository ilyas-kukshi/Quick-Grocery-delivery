import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:quickgrocerydelivery/shared/AppThemeShared.dart';

class CreateAccountOtp extends StatefulWidget {
  const CreateAccountOtp({Key? key}) : super(key: key);

  @override
  _CreateAccountOtpState createState() => _CreateAccountOtpState();
}

class _CreateAccountOtpState extends State<CreateAccountOtp> {
  Future<FirebaseApp> firebaseApp = Firebase.initializeApp();
  String verificationIdLocal = Get.arguments;

  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
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
          key: loginFormKey,
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
                    keyboardType: TextInputType.number,
                    onChanged: (otp) {
                      // verifyOtp(otp);
                    },
                    pinTheme: PinTheme(
                        borderRadius: BorderRadius.circular(12),
                        activeColor: Colors.black,
                        inactiveColor: Colors.black,
                        selectedColor: Theme.of(context).buttonColor),
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
                      color: Theme.of(context).buttonColor,
                      buttonText: "Login",
                      onTap: (startLoading, stopLoading, btnState) {
                        startLoading();
                       
                            verifyOtp();

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

  void verifyOtp() async {
    final credential = PhoneAuthProvider.credential(
        verificationId: verificationIdLocal, smsCode: otpController.text);

    FirebaseAuth.instance.signInWithCredential(credential).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
      print(e);
    });
  }
}
