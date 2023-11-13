import 'package:flutter/material.dart';
import 'package:untitled10/modules/myText.dart';
import '../../../../models/customerSupport_model.dart';

class ContactingUs extends StatelessWidget {
   ContactingUs({super.key});
  
  List<CustomerSupModel> cusModels = 
  [
    CustomerSupModel(
        icon: Icons.phone,
        title: 'Contacting Number',
        subTitle: '+20 1069897'
    ),
    CustomerSupModel(
        icon: Icons.mail,
        title: 'Email Address',
        subTitle: 'help@gmail.com'
    ),
    CustomerSupModel(
        icon: Icons.facebook,
        title: 'Facebook',
        subTitle: '@help'
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(text: 'Contact Us'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => InkWell(
          onTap: () {},
            child: cusModels[index],
        ),
        itemCount: cusModels.length,
      ),
    );
  }
}
