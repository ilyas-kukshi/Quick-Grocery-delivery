import 'package:flutter/material.dart';

class AppBarShared {
  static appBar({
    required String title,
    required BuildContext context,
    bool? centerTitle,
    Widget? leading,
    List<Widget>? actions,
    Color? backgroundColor,
  }) {
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
}
