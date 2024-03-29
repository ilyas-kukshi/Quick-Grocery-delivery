import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AppThemeShared {
  static Color buttonColor = Color(0xff33D1DB);

  static appBar(
      {required String title,
      required BuildContext context,
      bool automaticallyImplyLeading = false,
      bool? centerTitle = true,
      Widget? leading,
      List<Widget>? actions,
      Color? backgroundColor = Colors.black}) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline2?.copyWith(fontSize: 28),
      ),
      automaticallyImplyLeading: false,
      centerTitle: centerTitle,
      leading: leading,
      actions: actions,
      backgroundColor: backgroundColor,
    );
  }

  static argonButtonShared({
    required BuildContext context,
    required double height,
    required double width,
    required Color color,
    required String buttonText,
    required dynamic Function(Function, Function, ButtonState)? onTap,
    double borderRadius = 0.0,
  }) {
    return ArgonButton(
      height: height,
      width: width,
      color: color,
      borderRadius: borderRadius,
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

  static textFormField(
      {required BuildContext context,
      String labelText = '',
      String hintText = '',
      String? initialValue,
      TextEditingController? controller,
      TextInputAction? textInputAction,
      TextInputType? keyboardType,
      AutovalidateMode? autovalidateMode,

      //
      String? Function(String?)? validator,
      void Function(String)? onChanged,
      void Function(String?)? onSaved,
      void Function()? onEditingComplete,
      void Function(String)? onFieldSubmitted,
      void Function()? onTap,
      List<TextInputFormatter>? inputFormatters,

      //
      bool obscureText = false,
      bool autoFocus = false,
      bool readonly = false,
      bool expands = false,

      //
      int? maxLines,
      int? minLines,

      //
      Widget? suffixIcon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: Theme.of(context).textTheme.headline3?.copyWith(fontSize: 16),
        ),
        SizedBox(height: 5),
        TextFormField(
          controller: controller,
          validator: validator,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          initialValue: initialValue,
          obscureText: obscureText,
          autofocus: autoFocus,
          readOnly: readonly,
          expands: expands,
          maxLines: maxLines,
          minLines: minLines,
          autovalidateMode: autovalidateMode,
          onChanged: onChanged,
          onSaved: onSaved,
          onEditingComplete: onEditingComplete,
          onFieldSubmitted: onFieldSubmitted,
          onTap: onTap,
          inputFormatters: inputFormatters,
          style: Theme.of(context).textTheme.headline3?.copyWith(fontSize: 16),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: Theme.of(context)
                .textTheme
                .headline3
                ?.copyWith(fontSize: 14, color: Colors.black.withOpacity(0.7)),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.black)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.black)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.black)),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.black)),
          ),
        )
      ],
    );
  }

  static sharedRaisedButton({
    required BuildContext context,
    required double height,
    required double width,
    required Color color,
    required String buttonText,
    required void Function()? onPressed,
    double borderRadius = 0.0,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(height: height, width: width),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: Theme.of(context).textTheme.headline1?.copyWith(fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(primary: color),
      ),
    );
  }
}
