import 'package:flutter/material.dart';
import 'package:stable_flutter_gp1/login_form.dart';
import 'UserDetail.dart';
//import 'background_login.dart';
import 'package:http/http.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreen createState() => _SignupScreen();
}

class _SignupScreen extends State<SignupScreen> {
  // get myGradient => null;
  GlobalKey<FormState> _key = new GlobalKey();
  // bool _validate = false;
  TextEditingController usernameControler = new TextEditingController();
  TextEditingController emailControler = new TextEditingController();
  TextEditingController passControler = new TextEditingController();
  String email, password, confirm;
  int hello = 0;
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
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _keyboardVisibility.removeListener(_keyboardVisibilitySubscriberId);
  }

  Widget _inputForm() {
    if (hello == 0)
      return TextFormField(
        controller: usernameControler,
        decoration: InputDecoration(
          labelText: 'Username',
          border: InputBorder.none,
          filled: true,
        ),
      );
    else if (hello == 1)
      return TextFormField(
        controller: emailControler,
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'Email: end with @gmail.com,...',
          border: InputBorder.none,
          filled: true,
        ),
      );
    else
      return TextFormField(
        controller: passControler,
        decoration: InputDecoration(
          labelText: 'Password',
          border: InputBorder.none,
          filled: true,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("image/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(key: _key, children: <Widget>[
              _keyboardState ? Container() : Logo(),
              Padding(
                padding: EdgeInsets.only(top: 48.0),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.2),
                          spreadRadius: 10,
                          blurRadius: 5,
                        )
                      ],
                      color: Colors.white,
                    ),
                    height: 220.0,
                    width: 320.0,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'SIGN UP',
                            style: TextStyle(
                              fontSize: 30.0,
                            ),
                          ),
                        ),
                        _inputForm(),
                        Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0)),
                                    padding: const EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: <Color>[
                                              Colors.red,
                                              Colors.white
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(80.0)),
                                      ),
                                      child: Container(
                                        constraints: const BoxConstraints(
                                            minWidth: 90.0,
                                            minHeight:
                                                40.0), // min sizes for Material buttons
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Back',
                                          style: TextStyle(fontSize: 22.0),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        hello -= 1;
                                        if (hello < 0) hello = 0;
                                        if (hello > 1) hello = 1;
                                        print(hello);
                                      });
                                    },
                                  ),
                                  RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0)),
                                    padding: const EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: <Color>[
                                              Colors.red,
                                              Colors.white
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(80.0)),
                                      ),
                                      child: Container(
                                        constraints: const BoxConstraints(
                                            minWidth: 90.0,
                                            minHeight:
                                                40.0), // min sizes for Material buttons
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Next',
                                          style: TextStyle(fontSize: 22.0),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      String username_Trans =
                                          usernameControler.text;
                                      String email_Trans = emailControler.text;
                                      String pass_Trans = passControler.text;

                                      if (username_Trans.isEmpty &&
                                          hello == 0) {
                                        Fluttertoast.showToast(
                                            msg: "Enter username!",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIos: 1,
                                            backgroundColor: Colors.blue,
                                            textColor: Colors.white);
                                        return;
                                      }

                                      if (email_Trans.isEmpty && hello == 1) {
                                        Fluttertoast.showToast(
                                            msg: "Enter email!",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIos: 1,
                                            backgroundColor: Colors.blue,
                                            textColor: Colors.white);
                                        return;
                                      }

                                      if (pass_Trans.isEmpty && hello == 2) {
                                        Fluttertoast.showToast(
                                            msg: "Enter password!",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIos: 1,
                                            backgroundColor: Colors.blue,
                                            textColor: Colors.white);
                                        return;
                                      }

                                      setState(() {
                                        hello += 1;
                                        if (hello > 3) hello = 3;
                                        print(hello);
                                      });

                                      if (hello == 3) {
                                        Response response = await post(
                                            UserDetails.api + 'register',
                                            body: {
                                              'username': username_Trans,
                                              'email': email_Trans,
                                              'password': pass_Trans
                                            });

                                        Fluttertoast.showToast(
                                            msg: response.body,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIos: 1,
                                            backgroundColor: Colors.blue,
                                            textColor: Colors.white);
                                      }
                                    },
                                  ),
                                ]))
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(child: _keyboardState ? Container() : Loginbar())
            ])));
  }

  // String validateEmail(String value) {
  //   String patttern =
  //       r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  //   RegExp regExp = new RegExp(patttern);
  //   if (value.length == 0) {
  //     return "Email is Required";
  //   } else if (!regExp.hasMatch(value)) {
  //     return "Email must be have @";
  //   }
  //   return null;
  // }

  // _sendToServer() {
  //   if (_key.currentState.validate()) {
  //     // No any error in validation
  //     _key.currentState.save();
  //     print("Email $email");
  //     print("Password $password");
  //     print("Confirm Password $confirm");
  //   } else {
  //     // validation error
  //     setState(() {
  //       _validate = true;
  //     });
  //   }
  // }
}

class Loginbar extends StatefulWidget {
  //Loginbar({Key key}) : super(key: key);

  @override
  _LoginbarState createState() => _LoginbarState();
}

class _LoginbarState extends State<Loginbar> {
  // KeyboardVisibilityNotification _keyboardVisibility =
  //     new KeyboardVisibilityNotification();
  // int _keyboardVisibilitySubscriberId;
  // bool _keyboardState;

  // @protected
  // void initState() {
  //   super.initState();

  //   _keyboardState = _keyboardVisibility.isKeyboardVisible;

  //   _keyboardVisibilitySubscriberId = _keyboardVisibility.addNewListener(
  //     onChange: (bool visible) {
  //       setState(() {
  //         _keyboardState = visible;
  //       });
  //     },
  //   );
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _keyboardVisibility.removeListener(_keyboardVisibilitySubscriberId);
  // }

  @override
  Widget build(BuildContext context) {
    return
        //  _keyboardState
        //     ? Container()
        //     :
        Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          gradient: new LinearGradient(
            colors: [Colors.blue, Colors.teal[100]],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        // color: Colors.red,
        height: 70,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 5.0),
            child: Text(
              "Have an account?",
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
          ),
          RaisedButton(
            padding: const EdgeInsets.all(12.0),

            // child: Text(
            //   'Sign up',
            //   style: TextStyle(fontSize: 16),
            // ),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(40.0),
                side: BorderSide(color: Colors.white)),
            child: const Text(
              'Login',
              style: TextStyle(fontSize: 18.0),
            ),
            color: Colors.lightBlue[600],
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => MyApp()),
              //);
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
  //   super.initState();

  //   _keyboardState = _keyboardVisibility.isKeyboardVisible;

  //   _keyboardVisibilitySubscriberId = _keyboardVisibility.addNewListener(
  //     onChange: (bool visible) {
  //       setState(() {
  //         _keyboardState = visible;
  //       });
  //     },
  //   );
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _keyboardVisibility.removeListener(_keyboardVisibilitySubscriberId);
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
