import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stable_flutter_gp1/signup_form.dart';
//import 'background_signup.dart';
import 'home_screen.dart';
import 'UserDetail.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  TextEditingController emailControler = new TextEditingController();
  TextEditingController passControler = new TextEditingController();
  //get myGradient => null;
  KeyboardVisibilityNotification _keyboardVisibility =
      new KeyboardVisibilityNotification();
  int _keyboardVisibilitySubscriberId;
  bool _keyboardState;

  @protected
  void initState() {
    super.initState();
    _keyboardState = _keyboardVisibility.isKeyboardVisible;

    _keyboardVisibilitySubscriberId = _keyboardVisibility.addNewListener(
      onChange: (bool visible) {
        setState(() {
          _keyboardState = visible;
          print(_keyboardState);
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _keyboardVisibility.removeListener(_keyboardVisibilitySubscriberId);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("image/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(children: <Widget>[
              _keyboardState ? Container() : Logo(),
              Padding(
                padding: EdgeInsets.only(top: 48.0),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 10,
                          blurRadius: 5,
                        )
                      ],
                      color: Colors.white,
                    ),
                    height: 280.0,
                    width: 320.0,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'LOGIN FORM',
                            style: TextStyle(
                              fontSize: 30.0,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: emailControler,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: InputBorder.none,
                            filled: true,
                          ),
                        ),
                        TextFormField(
                          obscureText: true,
                          controller: passControler,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: InputBorder.none,
                            filled: true,
                          ),
                          //obscureText: true,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(60, 20, 60, 20),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0)),
                            padding: const EdgeInsets.all(0.0),
                            child: Ink(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    colors: <Color>[Colors.blue, Colors.white],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(80.0)),
                              ),
                              child: Container(
                                constraints: const BoxConstraints(
                                    minWidth: 90.0,
                                    minHeight:
                                        40.0), // min sizes for Material buttons
                                alignment: Alignment.center,
                                child: const Text(
                                  'Login',
                                  style: TextStyle(fontSize: 22.0),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              //LOGIN API
                              String email_Trans = emailControler.text;
                              String pass_Trans = passControler.text;
                              if (email_Trans.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: "Enter email!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIos: 1,
                                    backgroundColor: Colors.blue,
                                    textColor: Colors.white);
                                return;
                              }

                              if (pass_Trans.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: "Enter password!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIos: 1,
                                    backgroundColor: Colors.blue,
                                    textColor: Colors.white);
                                return;
                              }

                              Response response =
                                  await post(UserDetails.api + 'login', body: {
                                'email': email_Trans,
                                'password': pass_Trans
                              });

                              if (response.body.contains('Email not exists') |
                                  response.body.contains('Wrong password')) {
                                Fluttertoast.showToast(
                                    msg: response.body,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIos: 1,
                                    backgroundColor: Colors.blue,
                                    textColor: Colors.white);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "ok",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIos: 1,
                                    backgroundColor: Colors.blue,
                                    textColor: Colors.white);

                                var result = json.decode(response.body);

                                UserDetails.id = result['_id'];
                                UserDetails.email = result['email'];
                                UserDetails.username = result['username'];

                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString("id", result['_id']);
                                prefs.setString("email", result['email']);
                                prefs.setString("username", result['username']);

                                Response response1 = await post(
                                    UserDetails.api + 'load_station',
                                    body: {'id_num': UserDetails.id});

                                var result1 = jsonDecode(response1.body);
                                UserDetails.store = result1;

                                var platform = const MethodChannel(
                                    'flutter.native/AndroidPlatform');
                                final String addUserInfo =
                                    await platform.invokeMethod('addUserInfo', {
                                  "id": UserDetails.id,
                                  "username": UserDetails.username,
                                  "email": UserDetails.email
                                });
                                var addUserInfo_result = (addUserInfo);
                                print(addUserInfo_result);

                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => Home_screen()),
                                    (Route<dynamic> route) => false);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(child: _keyboardState ? Container() : Signupbar())
            ])));
  }
}

class Signupbar extends StatefulWidget {
  //Signupbar({Key key}) : super(key: key);

  @override
  _SignupbarState createState() => _SignupbarState();
}

class _SignupbarState extends State<Signupbar> {
  // KeyboardVisibilityNotification _keyboardVisibility =
  //     new KeyboardVisibilityNotification();
  // int _keyboardVisibilitySubscriberId;
  // bool _keyboardState;

  // @protected
  // void initState() {
  //   _keyboardState = _keyboardVisibility.isKeyboardVisible;

  //   _keyboardVisibilitySubscriberId = _keyboardVisibility.addNewListener(
  //     onChange: (bool visible) {
  //       setState(() {
  //         _keyboardState = visible;
  //       });
  //     },
  //   );
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   _keyboardVisibility.removeListener(_keyboardVisibilitySubscriberId);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return
        // _keyboardState
        //     ? Container()
        //     :
        Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          gradient: new LinearGradient(
            colors: [Colors.blue, Colors.teal[100]],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        //color: Colors.red,

        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 5.0),
            child: Text(
              "Don't have an account?",
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
          ),
          RaisedButton(
            padding: const EdgeInsets.all(12.0),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
                side: BorderSide(color: Colors.white)),
            child: const Text(
              'Sign up',
              style: TextStyle(fontSize: 18.0),
            ),
            color: Colors.red[400],
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => SignupScreen()),
                  (Route<dynamic> route) => false);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => BackgroundColorSignUp()),
              // );
            },
          ),
        ]),
      ),
    );
  }
}

class Logo extends StatefulWidget {
  //Logo({Key key}) : super(key: key);

  @override
  _LogoState createState() => _LogoState();
}

class _LogoState extends State<Logo> {
  // KeyboardVisibilityNotification _keyboardVisibility =
  //     new KeyboardVisibilityNotification();
  // int _keyboardVisibilitySubscriberId;
  // bool _keyboardState;

  // @protected
  // void initState() {
  //   _keyboardState = _keyboardVisibility.isKeyboardVisible;

  //   _keyboardVisibilitySubscriberId = _keyboardVisibility.addNewListener(
  //     onChange: (bool visible) {
  //       setState(() {
  //         _keyboardState = visible;
  //       });
  //     },
  //   );
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   _keyboardVisibility.removeListener(_keyboardVisibilitySubscriberId);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return
        // _keyboardState
        //     ? Container()
        //     :
        Padding(
      child: Image.asset(
        'image/Logo.png',
      ),
      padding: EdgeInsets.only(top: 30.0),
    );
  }
}
