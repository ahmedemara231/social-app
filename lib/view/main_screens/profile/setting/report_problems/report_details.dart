import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled10/modules/myText.dart';
import 'package:untitled10/view_model/auth_cubit/cubit.dart';

class ReportDetails extends StatelessWidget {
  Map<String,dynamic> report;

  ReportDetails({super.key,
     required this.report,
   });
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(text: 'Report Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('user').doc(AuthCubit.getInstance(context).userModel?.uId).snapshots(),
                  builder: (context, snapshot)
                  {
                    if(snapshot.hasData)
                      {
                        return ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(snapshot.data?.data()?['profileImage']),
                            ),
                            title: MyText(
                              text: snapshot.data?.data()?['name'],
                              fontWeight: FontWeight.w500,
                            ),
                            trailing:Column(
                              children: [
                                MyText(
                                  text: report['time'],
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                                const SizedBox(height: 8,),
                                MyText(
                                    text: 'Waiting...',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15
                                ),
                              ],
                            )
                        );
                      }
                    else{
                      return MyText(text: '...');
                    }

                  },
                ),
                MyText(
                  fontSize: 20,
                    maxLines: 20,
                  text: report['problem'],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
