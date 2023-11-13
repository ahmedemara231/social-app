import 'package:flutter/material.dart';
import 'package:untitled10/modules/myText.dart';
import 'package:untitled10/view_model/sharedPrefs/sharedPrefs.dart';

class CustomerSupModel extends StatelessWidget {
  IconData icon;
  String title;
  String subTitle;
   CustomerSupModel({super.key,
     required this.icon,
     required this.title,
     required this.subTitle,
   });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: SharedPrefs.sharedPreferences.getBool('appTheme') == false?
          Colors.grey[200]:
          Colors.grey[850],
        ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(icon),
          ),
      ),
      title: MyText(text: title,color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 18,),
      subtitle: MyText(text: subTitle,fontWeight: FontWeight.bold,fontSize: 16,),
    );
  }
}
