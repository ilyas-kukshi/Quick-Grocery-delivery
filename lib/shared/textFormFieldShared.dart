import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFormFieldShared {
  static textFormField({
    required BuildContext context,
    String labelText = '',
    String hintText = '',
    TextEditingController? controller,
    TextInputAction? textInputAction,
    TextInputType? keyboardType,

    //
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    void Function(String?)? onSaved,
    void Function()? onEditingComplete,
    void Function(String)? onFieldSubmitted,
    void Function()? onTap,

    //
    bool obscureText = false,
    bool autoFocus = false,
    bool readonly = false,

    //
    Widget? suffixIcon
  }) {
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
          obscureText: obscureText,
          autofocus: autoFocus,
          readOnly: readonly,
          onChanged: onChanged,
          onSaved: onSaved,
          onEditingComplete: onEditingComplete,
          onFieldSubmitted: onFieldSubmitted,
          onTap: onTap,
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
}
