import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ButtonShared {
  static buttonShared({
    required BuildContext context,
    required double height,
    required double width,
    required Color color,
    required String buttonText,
    void Function()? onPressed,
    dynamic Function(Function, Function, ButtonState)? onTap,
  }) {
    return ArgonButton(
      height: height,
      width: width,
      child: Text(
        buttonText,
        style: Theme.of(context).textTheme.headline1?.copyWith(fontSize: 16),
      ),
      loader: Container(
        padding: EdgeInsets.all(10),
        child: SpinKitRotatingCircle(
          color: Colors.white,
          // size: loaderWidth ,
        ),
      ),
      onTap: onTap,
    );

    // return ElevatedButton(
    //     onPressed: onPressed,
  }
}
