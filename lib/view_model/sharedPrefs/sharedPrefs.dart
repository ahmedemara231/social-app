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
     await sharedPreferences.setBool('isLogin', value);
  }

  static Future<void> saveUserDataWhenLogin(Map<String,String> userData)async
  {
    await sharedPreferences.setString('userId', (userData['uId'] as String));
    await sharedPreferences.setString('userName', (userData['name'] as String));
    await sharedPreferences.setString('userEmail', (userData['email'] as String));
    await sharedPreferences.setString('userPhone', (userData['phone'] as String));
  }
}