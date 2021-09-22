import 'package:flutter/material.dart';
import 'package:quickgrocerydelivery/shared/appBarShared.dart';
import 'package:quickgrocerydelivery/shared/textFormFieldShared.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarShared.appBar(
          title: 'Login',
          context: context,
          backgroundColor: Colors.black,
          centerTitle: true),
      body: SingleChildScrollView(
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
                child: TextFormFieldShared.textFormField(
                    context: context,
                    labelText: 'Enter phone number \*',
                    hintText: '9987655052'),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: TextFormFieldShared.textFormField(
                    context: context,
                    labelText: 'Enter password \*',
                    hintText: '***',
                    obscureText: obscureText,
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
            
          ],
        ),
      ),
    );
  }
}
