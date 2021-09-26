import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:quickgrocerydelivery/screens/auth/otp.dart';
import 'package:quickgrocerydelivery/shared/AppThemeShared.dart';
import 'package:quickgrocerydelivery/shared/dialogs.dart';
import 'package:quickgrocerydelivery/shared/utility.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

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
                  child: AppThemeShared.textFormField(
                      context: context,
                      labelText: 'Enter phone number \*',
                      hintText: '9987655052',
                      controller: phoneNumberController,
                      validator: Utility.phoneNumberValidator,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [LengthLimitingTextInputFormatter(10)]),
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
                      buttonText: "Get OTP",
                      onTap: (startLoading, stopLoading, btnState) {
                        sendOtp(startLoading, stopLoading, btnState);
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
                      Navigator.pushNamed(context, '/createAccount');
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

  void sendOtp(Function startLoading, Function stopLoading,
      ButtonState buttonState) async {
    final validate = loginFormKey.currentState!.validate();
    if (buttonState == ButtonState.Idle) {
      if (validate) {
        DialogShared.loadingDialog(context, "Loading...");

        await FirebaseAuth.instance
            .verifyPhoneNumber(
                phoneNumber: "+91" + phoneNumberController.text,
                verificationCompleted: verificationCompleted,
                verificationFailed: verificationFailed,
                codeSent: codeSent,
                codeAutoRetrievalTimeout: codeAutoRetrievalTimeout)
            .onError((error, stackTrace) {
          Fluttertoast.showToast(msg: error.toString());
          Get.back();
        });
      }
    }
  }

  void codeAutoRetrievalTimeout(String verificationId) {}

  void codeSent(String verificationId, [int? smsCode]) async {
    verificationIdLocal = verificationId;
    Navigator.pop(context);
    Navigator.pushNamed("/otp", arguments: verificationIdLocal);
  }

  void verificationFailed(FirebaseAuthException exception) {
    print(exception.message);
    Fluttertoast.showToast(msg: exception.message.toString());
    Get.back();
  }

  void verificationCompleted(PhoneAuthCredential credential) async {}
}
