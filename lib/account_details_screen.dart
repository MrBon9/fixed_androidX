import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'UserDetail.dart';
import 'scaffold_custom.dart';

class AccountDetails extends StatefulWidget {
  @override
  _AccountDetails createState() => _AccountDetails();
}

class _AccountDetails extends State<AccountDetails> {
  var username = UserDetails.username;
  var email = UserDetails.email;
  var cab;
  @override
  void initState() {
    this.userState();

    super.initState();
  }

  void userState() async {
    Response response = await post(UserDetails.api + 'load_station',
        body: {'id_num': UserDetails.id});

    var result = jsonDecode(response.body);
    UserDetails.store = result;
    setState(() {
      cab = UserDetails.store.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    // var loc = '\u{1F4CD}';
    // var map = '\u{1F5FA}';
    // var cab_icon = '\u{1F5C4}';
    // TODO: implement build
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.blue, Colors.teal[100]],
              ),
            ),
          ),
          title: Image.asset(
            'image/Logo.png',
            fit: BoxFit.contain,
            height: 45,
          ),
          actions: <Widget>[
            Container(
                padding: EdgeInsets.all(2.0),
                child: IconButton(
                  onPressed: () {
                    print('search');
                  },
                  icon: Icon(Icons.search),
                ))
          ],
        ),
        body: Center(
          child: Container(
            height: 700.0,
            width: 360.0,
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Username: $username',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Email: $email',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    'Amount of Cabinet : $cab',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Naviagationbar());
  }
}
