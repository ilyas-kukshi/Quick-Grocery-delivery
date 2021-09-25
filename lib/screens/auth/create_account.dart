import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  String verificationId = '';
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  Future<FirebaseApp> firebaseApp = Firebase.initializeApp();
  bool otpSent = false;

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
      verificationId = verificationId;
    });
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

  void verifyOtp() async {
    final credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otpController.text);

    FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppThemeShared.appBar(title: 'Create Account', context: context),
      body: SingleChildScrollView(
        child: !otpSent
            ? Column(
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
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: AppThemeShared.textFormField(
                          context: context,
                          labelText: 'Set password \*',
                          hintText: '******',
                          validator: Utility.passwordLengthValidator,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          suffixIcon: obscureText
                              ? IconButton(
                                  icon: Icon(Icons.visibility_off_outlined,
                                      color: Colors.black),
                                  onPressed: () {
                                    setState(() {
                                      obscureText = false;
                                    });
                                  },
                                )
                              : IconButton(
                                  icon: Icon(Icons.visibility_outlined,
                                      color: Colors.black),
                                  onPressed: () {
                                    setState(() {
                                      obscureText = true;
                                    });
                                  },
                                )),
                    ),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: AppThemeShared.textFormField(
                          context: context,
                          labelText: 'Confirm password \*',
                          hintText: '******',
                          validator: Utility.passwordLengthValidator,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          suffixIcon: obscureText
                              ? IconButton(
                                  icon: Icon(Icons.visibility_off_outlined,
                                      color: Colors.black),
                                  onPressed: () {
                                    setState(() {
                                      obscureText = false;
                                    });
                                  },
                                )
                              : IconButton(
                                  icon: Icon(Icons.visibility_outlined,
                                      color: Colors.black),
                                  onPressed: () {
                                    setState(() {
                                      obscureText = true;
                                    });
                                  },
                                )),
                    ),
                  ),
                  SizedBox(height: 30),
                  Center(
                      child: AppThemeShared.buttonShared(
                          context: context,
                          height: 50,
                          borderRadius: 12,
                          width: MediaQuery.of(context).size.width * 0.85,
                          color: Theme.of(context).buttonColor,
                          buttonText: "Get Otp",
                          onTap: (startLoading, stopLoading, btnState) {
                            if (btnState == ButtonState.Idle) {
                              startLoading();
                              sendOtp();
                              stopLoading();
                            }
                          })),
                ],
              )
            : Column(
                children: [
                  SizedBox(height: 30),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: AppThemeShared.textFormField(
                          context: context,
                          labelText: 'Enter Otp \*',
                          hintText: '9987655052',
                          controller: otpController,
                          validator: Utility.phoneNumberValidator,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10)
                          ]),
                    ),
                  ),
                  Center(
                      child: AppThemeShared.buttonShared(
                          context: context,
                          height: 50,
                          borderRadius: 12,
                          width: MediaQuery.of(context).size.width * 0.85,
                          color: Theme.of(context).buttonColor,
                          buttonText: "Verify",
                          onTap: (startLoading, stopLoading, btnState) {
                            if (btnState == ButtonState.Idle) {
                              startLoading();
                              verifyOtp();
                              stopLoading();
                            }
                          })),
                ],
              ),
      ),
    );
  }
}
