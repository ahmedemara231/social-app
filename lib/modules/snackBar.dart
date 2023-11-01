import 'package:flutter/material.dart';
import 'package:untitled10/modules/myText.dart';

class MySnackBar
{
  static void showSnackBar({
    required context,
    required String message,
    Color? color
})
  {
    SnackBar snackBar = SnackBar(
      backgroundColor: color?? Colors.grey,
        content: MyText(
          text: message,
          fontSize: 20,
        ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}