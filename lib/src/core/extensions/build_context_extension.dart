import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  Size get size => MediaQuery.of(this).size;
  double get height => size.height;
  double get width => size.width;
  double get statusHeight => MediaQuery.of(this).viewPadding.top;

  snackThis({required String message, required Color color}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          left: 25,
          right: 25,
          bottom: height - 100,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Align(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
