import 'package:flutter/material.dart';
import 'package:untitled10/view_model/sharedPrefs/sharedPrefs.dart';

class NewDivider extends StatelessWidget {
  const NewDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
        width: 50,
        height: 1.5,
        color: SharedPrefs.sharedPreferences.getBool('appTheme') == false?
        Colors.black:
        Colors.white,
    );
  }
}
