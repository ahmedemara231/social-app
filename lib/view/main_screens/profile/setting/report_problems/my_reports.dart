import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled10/modules/myText.dart';
import 'package:untitled10/view/main_screens/profile/setting/report_problems/report_details.dart';
import 'package:untitled10/view_model/auth_cubit/cubit.dart';
import 'package:untitled10/view_model/profile/cubit.dart';
import 'package:untitled10/view_model/profile/states.dart';

class MyReports extends StatefulWidget {
  const MyReports({super.key});

  @override
  State<MyReports> createState() => _MyReportsState();
}

class _MyReportsState extends State<MyReports> {
  
  @override
  void initState() {
    ProfileCubit.getInstance(context).getMyReports(
        uId: AuthCubit.getInstance(context).userModel!.uId
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit,ProfileStates>(
      listener: (context, state){},
      builder: (context, state)
      {
        return Scaffold(
          appBar: AppBar(
            title: MyText(text: 'Reports'),
          ),
          body: ProfileCubit.getInstance(context).myReports.isEmpty?
          Center(child: MyText(text: 'No Reports yet',fontSize: 25,fontWeight: FontWeight.w500,)) :
          ListView.separated(
              itemBuilder: (context, index) => InkWell(
                onTap: ()
                {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReportDetails(
                          report: ProfileCubit.getInstance(context).myReports[index],
                        ),
                      ),
                  );
                },
                child: Card(
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: MyText(text: '${ProfileCubit.getInstance(context).myReports[index]['problem']}',fontWeight: FontWeight.w500,fontSize: 18),
                    ),
                    trailing: Column(
                      children: [
                        MyText(text: '${ProfileCubit.getInstance(context).myReports[index]['time']}',fontWeight: FontWeight.bold,fontSize: 14,),
                        const SizedBox(height: 8,),
                        MyText(text: 'Waiting...',fontWeight: FontWeight.w500,fontSize: 15),
                      ],
                    ),
                  ),
                ),
              ), separatorBuilder: (context, index) => const SizedBox(height: 16,),
              itemCount: ProfileCubit.getInstance(context).myReports.length,
          ),
        );
      },
    );
  }
}
