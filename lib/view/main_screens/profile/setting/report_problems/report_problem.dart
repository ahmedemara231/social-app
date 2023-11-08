import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:untitled10/models/profile_models.dart';
import 'package:untitled10/modules/myText.dart';
import 'package:untitled10/modules/textFormField.dart';
import 'package:untitled10/view_model/auth_cubit/cubit.dart';
import 'package:untitled10/view_model/profile/cubit.dart';
import 'package:untitled10/view_model/profile/states.dart';

import 'my_reports.dart';

class ReportProblem extends StatelessWidget {
   ReportProblem({super.key});

   final formKey = GlobalKey<FormState>();
   final reportCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit,ProfileStates>(
      builder: (context, state)
      {
        return Scaffold(
          appBar: AppBar(
            title: MyText(text: 'Report Problem'),
            actions: [
              TextButton(
                  onPressed: ()
                  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyReports(),
                        ),
                    );
                  }, child: MyText(text: 'my reports',fontSize: 18,))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Form(
                  key: formKey,
                  child: TFF(
                    obscureText: false,
                    controller: reportCont,
                    hintText: 'Write your problem',
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)
                    ),
                  ),
                ),
                Row(
                  children: [
                    MyText(
                      text: 'tip : if your problem still call Customer Service ',
                      color: Colors.grey,fontWeight: FontWeight.bold,
                    ),
                    TextButton(
                        onPressed: () {},
                        child: MyText(text: '009922',color: Colors.blue,)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async
                    {
                      if(formKey.currentState!.validate())
                        {
                          await ProfileCubit.getInstance(context).reportProblem(
                            reportProblemModel: ReportProblemModel(
                                email: AuthCubit.getInstance(context).userModel!.email,
                                uId: AuthCubit.getInstance(context).userModel!.uId,
                                problem: reportCont.text,
                                time: Jiffy.now().yMMMdjm,
                            ),
                              context: context,
                          );
                        }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                      child: MyText(text: 'Send',fontSize: 20,color: Colors.white,),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
