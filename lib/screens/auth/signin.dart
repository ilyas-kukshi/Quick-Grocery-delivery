import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:quickgrocerydelivery/shared/AppThemeShared.dart';
import 'package:quickgrocerydelivery/shared/utility.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool otpSent = false;
  Future<FirebaseApp> firebaseApp = Firebase.initializeApp();
  String verificationIdLocal = '';

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
      body: WillPopScope(
        onWillPop: () {
          if (otpSent) {
            setState(() {
              otpSent = false;
            });
          } else {
            Get.back();
          }
          return Future.value(false);
        },
        child: SingleChildScrollView(
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
                !otpSent
                    ? Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: AppThemeShared.textFormField(
                              context: context,
                              labelText: 'Enter phone number \*',
                              hintText: '9987655052',
                              controller: phoneNumberController,
                              validator: Utility.phoneNumberValidator,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10)
                              ]),
                        ),
                      )
                    : Center(
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
                !otpSent
                    ? Center(
                        child: AppThemeShared.buttonShared(
                            context: context,
                            height: 50,
                            borderRadius: 12,
                            width: MediaQuery.of(context).size.width * 0.85,
                            color: Theme.of(context).buttonColor,
                            buttonText: "Get OTP",
                            onTap: (startLoading, stopLoading, btnState) {
                              if (btnState == ButtonState.Idle) {
                                startLoading();
                                sendOtp(startLoading, stopLoading, btnState);
                                stopLoading();
                              }
                            }))
                    : Center(
                        child: AppThemeShared.buttonShared(
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
      ),
    );
  }

  void sendOtp(Function startLoading, Function stopLoading,
      ButtonState buttonState) async {
    final validate = loginFormKey.currentState!.validate();
    if (validate) {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: "+91" + phoneNumberController.text,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    }
  }

  void codeAutoRetrievalTimeout(String verificationId) {}
  void codeSent(String verificationId, [int? smsCode]) async {
    setState(() {
      otpSent = true;
    });
    verificationIdLocal = verificationId;
  }

  void verificationFailed(FirebaseAuthException exception) {
    print(exception.message);
    Fluttertoast.showToast(msg: exception.message.toString());
  }

  void verificationCompleted(PhoneAuthCredential credential) async {}

  void verifyOtp() async {
    final credential = PhoneAuthProvider.credential(
        verificationId: verificationIdLocal, smsCode: otpController.text);

    await FirebaseAuth.instance
        .signInWithCredential(credential)
        .catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
      print(e);
    });
  }
}
