import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {
  static String userLoggedInKey = "LOGGED_IN_KEY";
  static String userNameKey = "USER_NAME_KEY";
  static String userEmailKey = "USER_EMAIL_KEY";


  static Future saveUserLoggedInStatus(bool isUserLoggedIn) async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future saveUserName(String userName) async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }

  static Future saveUserEmail(String userEmail) async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }

  static Future clearSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.clear();
  }

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  static Future<String?> getUserNameLoggedIn() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }

  static Future<String?> getUserEmailLoggedIn() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }



  static void nextScreen(context, screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  static void nextScreenReplace(context, screen) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => screen));
  }

  static void showSnackBar(context, color, message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message, style: const TextStyle(fontSize: 14),),
          backgroundColor: color,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: "OK",
            onPressed: (){},
            textColor: Colors.white,
          ),
        ));
  }
}