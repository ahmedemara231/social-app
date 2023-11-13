import 'package:flutter/material.dart';
import 'package:untitled10/modules/myText.dart';

class SettingModel extends StatelessWidget {
  String txt;
  void Function()? onTap;
  bool darkModeSet;
  bool? darkModeValue;
  void Function(bool)? onChanged;

   SettingModel({super.key,
     required this.txt,
     required this.onTap,
     required this.darkModeSet,
     this.darkModeValue,
     this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Card(
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  MyText(
                    text: txt,
                    fontSize: 20,
                  ),
                  const Spacer(),
                  if(darkModeSet == true)
                    Switch(
                        value: darkModeValue!,
                        inactiveThumbColor: Colors.black38,
                        activeColor: Colors.grey,
                        onChanged: onChanged
                    ),
                  if(darkModeSet == false)
                    const Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
