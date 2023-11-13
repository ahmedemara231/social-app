import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled10/models/setting_model.dart';
import 'package:untitled10/view/auth_screens/login.dart';
import 'package:untitled10/view/main_screens/profile/setting/report_problems/report_problem.dart';
import 'package:untitled10/view/main_screens/profile/setting/savedPosts.dart';
import 'package:untitled10/view_model/profile/cubit.dart';
import 'package:untitled10/view_model/profile/states.dart';
import 'package:untitled10/view_model/sharedPrefs/sharedPrefs.dart';
import '../../../../modules/myText.dart';
import 'contacting_us.dart';

class Setting extends StatelessWidget {
  Setting({super.key});

  late List<SettingModel> setting ;

  @override
   Widget build(BuildContext context) {
      return BlocBuilder<ProfileCubit,ProfileStates>(
        builder: (context, state)
        {
          setting =
          [
            SettingModel(
              txt: 'Dark mode',
              onTap: () {},
              darkModeSet: true,
              darkModeValue: SharedPrefs.sharedPreferences.getBool('appTheme') == false? false : true,
              onChanged: (value) {
                ProfileCubit.getInstance(context).changeAppTheme(value);
              },
            ),
            SettingModel(
                txt: 'Saved posts',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SavedPosts(),
                    ),
                  );
                },
                darkModeSet: false
            ),
            SettingModel(
                txt: 'Contact Us',
                onTap: ()
                {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContactingUs(),
                      ),
                  );
                },
                darkModeSet: false
            ),
            SettingModel(
                txt: 'Report Problem',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportProblem(),
                    ),);
                }, darkModeSet: false),
            SettingModel(
                txt: 'Log out',
                onTap: ()
                {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: MyText(text: 'Are you sure to logout ?'),
                      actions: [
                        TextButton(
                            onPressed: ()
                            {
                              Navigator.pop(context);
                            }, child: MyText(text: 'Cancel',fontSize: 18,),
                        ),
                        TextButton(
                          onPressed: ()async
                          {
                            Navigator.pop(context);
                            await SharedPrefs.saveLoginState(false).then((value)
                            {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Login(),
                                  ), (route) => false
                              );
                            });

                          }, child: MyText(text: 'Logout',fontSize: 18,),
                        ),
                      ],
                    ),
                  );
                },
                darkModeSet: false
            ),
          ];
          return Scaffold(
            appBar: AppBar(
              title: MyText(
                text: 'Settings',
                fontWeight: FontWeight.w500,
              ),
            ),
            body: ListView.builder(
              itemBuilder: (context, index) => setting[index],
              itemCount: setting.length,
            ),
          );
        },
      );
    }
}

