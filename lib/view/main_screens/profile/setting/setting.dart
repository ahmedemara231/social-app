import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled10/view/auth_screens/login.dart';
import 'package:untitled10/view/main_screens/profile/setting/report_problems/report_problem.dart';
import 'package:untitled10/view/main_screens/profile/setting/savedPosts.dart';
import 'package:untitled10/view_model/auth_cubit/cubit.dart';
import 'package:untitled10/view_model/profile/cubit.dart';
import 'package:untitled10/view_model/profile/states.dart';
import 'package:untitled10/view_model/sharedPrefs/sharedPrefs.dart';
import '../../../../modules/myText.dart';

class Setting extends StatelessWidget {
   const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit,ProfileStates>(
      builder: (context, state)
      {
        return Scaffold(
            appBar: AppBar(
              title: MyText(
                text: 'Settings',
                fontWeight: FontWeight.w500,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        MyText(text: 'Dark mode',fontSize: 20,fontWeight: FontWeight.w500,),
                        const Spacer(),
                        Switch(
                          inactiveThumbColor: Colors.black38,
                          value: SharedPrefs.sharedPreferences.getBool('appTheme') == false? false : true,
                          activeColor: Colors.grey,
                          onChanged: (value)
                          {
                            ProfileCubit.getInstance(context).changeAppTheme(value);
                          },

                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: ()
                      {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SavedPosts(),
                            ),
                        );
                      },
                      child: Row(
                        children: [
                          MyText(text: 'Saved Posts',fontSize: 20,fontWeight: FontWeight.w500,),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          MyText(text: 'contact us',fontSize: 20,fontWeight: FontWeight.w500,),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () 
                      {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportProblem(),
                            ),
                        );
                      },
                      child: Row(
                        children: [
                          MyText(text: 'Report a problem', color:Colors.red, fontSize: 20,fontWeight: FontWeight.w500,),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if(FirebaseAuth.instance.currentUser?.emailVerified == false)
                      Column(
                        children: [
                          InkWell(
                          onTap: ()async
                          {
                            await AuthCubit.getInstance(context).verifyEmail(context);
                          },
                          child: Row(
                            children: [
                              MyText(
                                text: 'verify your account',
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue,
                              ),
                              const Spacer(),
                              const Icon(Icons.arrow_forward_ios)
                            ],
                          ),
                    ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    InkWell(
                      onTap: ()
                      {
                        showDialog(context: context, builder: (context) => AlertDialog(
                          title: MyText(text: 'Are you sure to logout?',fontSize: 20,),
                          actions: [
                            TextButton(
                                onPressed: ()
                                {
                                  Navigator.pop(context);
                                }, child: MyText(text: 'Cancel',fontSize: 16,)),
                            TextButton(
                                onPressed: ()
                                {
                                  AuthCubit.getInstance(context).changeLoginState(false).then((value)
                                  {
                                    Navigator.pop(context);
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Login(),
                                      ), (route) => false,
                                    );
                                  });
                                }, child: MyText(text: 'logout',fontSize: 16,))
                          ],
                        ),);
                      },
                      child: Row(
                        children: [
                          MyText(text: 'log out',fontSize: 20,fontWeight: FontWeight.w500,),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
        );
      },
    );
  }
}
