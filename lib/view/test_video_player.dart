// import 'dart:html';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:untitled10/modules/myText.dart';
// import 'dart:io';
//
// class Test extends StatelessWidget {
//    Test({super.key});
//
//   late File video;
//   void pickVideo()
//   {
//     final picker = ImagePicker();
//     picker.pickVideo(source: ImageSource.camera).then((value)
//     {
//       // video = File(value.path);
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: MyText(text: 'video test'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:untitled10/modules/myText.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: ElevatedButton(
        onPressed: ()
        {
          print(Jiffy.now().yMMMdjm);
        },
        child: MyText(text: 'show time'),
      ),),
    );
  }
}

