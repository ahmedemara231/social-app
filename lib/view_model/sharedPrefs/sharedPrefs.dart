import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs
{
  static late SharedPreferences sharedPreferences;

  static Future<void> initCacheMemory()async
  {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<void> saveAppTheme(bool darkMode)async
  {
    await sharedPreferences.setBool('appTheme', darkMode).then((value)
    {
      log('saved $darkMode');
    });
  }

  static Future<void> saveLoginState(bool value) async
  {
     sharedPreferences.setBool('isLogin', value).then((value)
    {
      if(value == true)
        {
          log('logged in');
        }
      else{
        return;
      }
    });
  }

  static Future<void> saveUserDataWhenLogin(List<String> userData)async
  {
    await sharedPreferences.setStringList('userData', userData);
  }
}