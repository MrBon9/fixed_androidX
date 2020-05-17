import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stable_flutter_gp1/main.dart';
//import 'package:stable_flutter_gp1/main.dart';
import 'account_details_screen.dart';
import 'listStation.dart';
//import 'background_login.dart';
import 'UserDetail.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'authorize.dart';
import 'login_form.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawer createState() => _AppDrawer();
}

class _AppDrawer extends State<AppDrawer> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.grey[300],
        child: ListView(
          children: <Widget>[
            Container(
              height: 136.0,
              color: Colors.blue[400],
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(29, 40, 9, 9),
                    child: Container(
                      height: 72.0,
                      width: 72.0,
                      child: CircleAvatar(
                        radius: 36.0,
                        backgroundImage: AssetImage("image/vn.png"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(9, 45, 10, 9),
                    child: Center(
                        child: Text(
                      '${UserDetails.username}',
                      style: TextStyle(fontSize: 27, color: Colors.white),
                    )),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 5.0, 0, 2.0),
              child: Container(
                height: 336,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.account_box),
                      title: Text('Account Details'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountDetails()),
                        );
                        print('Account');
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.dashboard),
                      title: Text('Your Boxes'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () async {
                        Response response = await post(
                            UserDetails.api + 'load_station',
                            body: {'id_num': UserDetails.id});
                        print(response.body);

                        var result = jsonDecode(response.body);
                        UserDetails.store = result;
                        UserDetails.listStation = new List();
                        for (var i = 0; i < result.length; i++) {
                          var inside_station = result[i]["station"][0];

                          if (UserDetails.listStation.length == 0)
                            UserDetails.listStation.add(inside_station);
                          else {
                            bool found = false;
                            for (var j = 0;
                                j < UserDetails.listStation.length;
                                j++) {
                              String temp = inside_station['_id'];
                              String temp1 = UserDetails.listStation[j]['_id'];
                              if (temp == temp1) found = true;
                            }
                            if (found == false)
                              UserDetails.listStation.add(inside_station);
                          }
                        }
                        for (var i = 0;
                            i < UserDetails.listStation.length;
                            i++) {
                          print(UserDetails.listStation[i]);
                        }

                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => ListStation()),
                            (Route<dynamic> route) => false);

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => ListStation()),
                        // );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.announcement),
                      title: Text('Notifications'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        print('Notificate');
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.people),
                      title: Text('Friends'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        print('Friend List');
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.screen_share),
                      title: Text('Authorize Your Boxes'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () async {
                        Response response = await post(
                            UserDetails.api + 'load_station',
                            body: {'id_num': UserDetails.id});

                        var result = jsonDecode(response.body);
                        UserDetails.store = result;
                        UserDetails.listStation = new List();
                        for (var i = 0; i < result.length; i++) {
                          var inside_station = result[i]["station"][0];

                          if (UserDetails.listStation.length == 0)
                            UserDetails.listStation.add(inside_station);
                          else {
                            bool found = false;
                            for (var j = 0;
                                j < UserDetails.listStation.length;
                                j++) {
                              String temp = inside_station['_id'];
                              String temp1 = UserDetails.listStation[j]['_id'];
                              if (temp == temp1) found = true;
                            }
                            if (found == false)
                              UserDetails.listStation.add(inside_station);
                          }
                        }
                        // for (var i = 0; i < UserDetails.listStation.length; i++) {
                        //   print(UserDetails.listStation[i]);
                        // }
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => Authorize()),
                            (Route<dynamic> route) => false);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => Authorize()),
                        // );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.show_chart),
                      title: Text('Statistical'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        print('Statistical');
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 2.5, 0, 2.5),
              child: Container(
                height: 150.0,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 9.0, 72.0, 0.0),
                      child: Text(
                        'SUPPORT',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text('Hotline: 1900290997'),
                      // onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.mail),
                      title: Text('Email: teamKHMT15@gmail.com'),
                      // onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 2.5, 0, 130.0),
              child: Container(
                height: 60.0,
                color: Colors.white,
                child: ListTile(
                  title: Text('             ABOUT US',
                      style: TextStyle(fontSize: 20.0)),
                  onTap: () {
                    print('Link to web');
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0.0),
              child: Container(
                height: 54.0,
                color: Colors.white,
                child: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout'),
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    //Remove String
                    prefs.remove("id");
                    prefs.remove("email");
                    prefs.remove("username");

                    var platform =
                        const MethodChannel('flutter.native/AndroidPlatform');
                    final String deleteUserInfo =
                        await platform.invokeMethod('deleteUserInfo');
                    var deleteUserInfo_result = (deleteUserInfo);
                    print(deleteUserInfo_result);

                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (Route<dynamic> route) => false);

                    print('Logout');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
