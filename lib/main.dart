import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:stable_flutter_gp1/home_screen.dart';
import 'package:stable_flutter_gp1/login_form.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'UserDetail.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  bool checkUser;
  static const platform = const MethodChannel('flutter.native/AndroidPlatform');

  @override
  void initState() {
    super.initState();
    this.userState();
    //call Android plaftform
    platform.invokeMethod('startSocket');
  }

  void userState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool id_state = prefs.containsKey("id");
    setState(() {
      checkUser = id_state;
    });
    if (id_state == true) {
      UserDetails.id = prefs.getString('id');
      UserDetails.email = prefs.getString('email');
      UserDetails.username = prefs.getString('username');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DEMO GP1',
      home: checkUser == true ? Home_screen() : LoginScreen(),
    );
  }
}
