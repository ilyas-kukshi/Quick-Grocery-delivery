import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:quickgrocerydelivery/shared/AppThemeShared.dart';
import 'package:quickgrocerydelivery/shared/utility.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String accountType = 'Customer';
  bool obscureText = true;
  String verificationIdLocal = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  GlobalKey<FormState> createAccountForm = GlobalKey<FormState>();

  Future<FirebaseApp> firebaseApp = Firebase.initializeApp();
  bool otpSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppThemeShared.appBar(title: 'Create Account', context: context),
      body: SingleChildScrollView(
          child: Form(
        key: createAccountForm,
        child: Column(
          children: [
            SizedBox(height: 30),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(12)),
                child: DropdownButton<String>(
                  value: accountType,
                  isExpanded: true,
                  iconSize: 24,
                  elevation: 16,
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      ?.copyWith(fontSize: 16),
                  underline: Offstage(),
                  onChanged: (String? newValue) {
                    setState(() {
                      accountType = newValue!;
                    });
                  },
                  items: <String>['Customer', 'Shop Owner']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: AppThemeShared.textFormField(
                    context: context,
                    labelText: 'Enter name \*',
                    hintText: 'Ilyas Kukshiwala',
                    controller: nameController,
                    validator: Utility.nameValidator,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: AppThemeShared.textFormField(
                    context: context,
                    labelText: 'Enter phone number \*',
                    hintText: '9987655052',
                    controller: phoneNumberController,
                    validator: Utility.phoneNumberValidator,
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    buttonText: "Get Otp",
                    onTap: (startLoading, stopLoading, btnState) {
                      if (btnState == ButtonState.Idle) {
                        final valid =
                            createAccountForm.currentState!.validate();
                        if (valid) {
                          startLoading();
                          FirebaseFirestore.instance
                              .collection('Users')
                              .doc(phoneNumberController.text)
                              .get()
                              .then((DocumentSnapshot documentSnapshot) {
                            if (documentSnapshot.exists) {
                              Fluttertoast.showToast(
                                  msg: "Phone number already exists");
                              stopLoading();
                            } else {
                              sendOtp();
                            }
                          });
                        }
                      }
                    })),
          ],
        ),
      )),
    );
  }

  void sendOtp() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91" + phoneNumberController.text,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void codeAutoRetrievalTimeout(String verificationId) {}
  void codeSent(String verificationId, [int? smsCode]) async {
    setState(() {
      otpSent = true;
    });
    verificationIdLocal = verificationId;
    Get.toNamed("/createAccountOtp", arguments: verificationIdLocal);
  }

  void verificationFailed(FirebaseAuthException exception) {
    print(exception.message);
    Fluttertoast.showToast(msg: exception.message.toString());
  }

  void verificationCompleted(PhoneAuthCredential credential) async {
    // await FirebaseAuth.instance.signInWithCredential(credential);
    // if (FirebaseAuth.instance.currentUser != null) {
    //   setState(() {});
    // } else {
    //   Fluttertoast.showToast(msg: 'Failed');
    // }
  }

  // void verifyOtp() async {
  //   final credential = PhoneAuthProvider.credential(
  //       verificationId: verificationIdLocal, smsCode: otpController.text);
  //   await FirebaseAuth.instance
  //       .signInWithCredential(credential)
  //       .catchError((e) {
  //     Fluttertoast.showToast(msg: e.toString());
  //     print(e);
  //   });
  // }
}
