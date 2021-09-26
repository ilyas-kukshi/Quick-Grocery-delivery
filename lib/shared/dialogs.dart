import 'package:flutter/material.dart';
import 'package:quickgrocerydelivery/shared/AppThemeShared.dart';

class DialogShared {
  static loadingDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: AlertDialog(
            contentPadding: EdgeInsets.symmetric(horizontal: 32),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Column(
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    color: Theme.of(context).buttonColor,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  text,
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      ?.copyWith(fontSize: 18),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static exitDialog(BuildContext context, String text,
      void Function()? yesClicked, void Function()? noClicked) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: 32),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Column(
            children: [
              Text(
                text,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    ?.copyWith(fontSize: 18),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AppThemeShared.sharedRaisedButton(
                      context: context,
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.2,
                      color: Colors.green,
                      buttonText: "Yes",
                      onPressed: yesClicked),
                  AppThemeShared.sharedRaisedButton(
                      context: context,
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.2,
                      color: Colors.red,
                      buttonText: "No",
                      onPressed: noClicked)
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
