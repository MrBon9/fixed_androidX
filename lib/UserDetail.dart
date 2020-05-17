import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'authorize.dart';
import 'listStation.dart';
import 'home_screen.dart';
import 'RegStation.dart';

class UserDetails {
  static String api = "https://dhdsmartcabinet.herokuapp.com/";
  static String id = "";
  static String email = "";
  static String username = "";
  static List<dynamic> listStation = new List();
  static List<dynamic> listBox = new List();
  static List<dynamic> regStation = new List();
  static List<dynamic> regBox = new List();
  static List<dynamic> store = new List();
  static List<dynamic> auth_store = new List();
  static String auth_id = "";

  static Scann_QR() async {
    String result;
    try {
      result = (await BarcodeScanner.scan()) as String;
      print("Scann successfully");
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.cameraAccessDenied) {
        print('Camera permission was denied');
      } else {
        print('Unknown Error $ex');
      }
    } on FormatException {
      print("You pressed the back button before scanning anything");
    } catch (ex) {
      print("Unknown Error $ex");
    }
    return result;
  }
}

class Authrize {
  String id;
  String email = "";
  String username = "";
  List<dynamic> listStation = new List();
  List<dynamic> listBox = new List();
}

class Naviagationbar extends StatefulWidget {
  @override
  _Naviagationbar createState() => _Naviagationbar();
}

class _Naviagationbar extends State<Naviagationbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Colors.blue, Colors.teal[100]],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new IconButton(
            icon: Icon(
              Icons.home,
              size: 30.0,
            ),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Home_screen()),
                  (Route<dynamic> route) => false);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => Home_screen()),
              // );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.person_add,
              size: 30.0,
            ),
            onPressed: () async {
              Response response = await post(UserDetails.api + 'load_station',
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
                  for (var j = 0; j < UserDetails.listStation.length; j++) {
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
                  MaterialPageRoute(builder: (context) => Authorize()),
                  (Route<dynamic> route) => false);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => Authorize()),
              // );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.add_to_queue,
              size: 30.0,
              color: Colors.black,
            ),
            onPressed: () async {
              Response response = await post(UserDetails.api + 'list_station',
                  body: {'id_num': UserDetails.id});
              var result = jsonDecode(response.body);

              UserDetails.regStation = result;
              print(UserDetails.regStation);

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => RegStation()),
                  (Route<dynamic> route) => false);

              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => RegStation()));
            },
          ),
          IconButton(
            icon: Icon(
              Icons.dashboard,
              size: 30.0,
            ),
            onPressed: () async {
              Response response = await post(UserDetails.api + 'load_station',
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
                  for (var j = 0; j < UserDetails.listStation.length; j++) {
                    String temp = inside_station['_id'];
                    String temp1 = UserDetails.listStation[j]['_id'];
                    if (temp == temp1) found = true;
                  }
                  if (found == false)
                    UserDetails.listStation.add(inside_station);
                }
              }
              for (var i = 0; i < UserDetails.listStation.length; i++) {
                print(UserDetails.listStation[i]);
              }

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => ListStation()),
                  (Route<dynamic> route) => false);

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => ListStation()),
              // );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.settings,
              size: 30.0,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class ListStationDisplay extends StatefulWidget {
  var item;
  ListStationDisplay({Key key, this.item}) : super(key: key);
  @override
  _ListStationDisplay createState() => _ListStationDisplay(item: item);
}

class _ListStationDisplay extends State<ListStationDisplay> {
  String location;
  String no;
  var item;
  _ListStationDisplay({Key key, this.item}) {
    location = item['location'];
    no = item['no'];
  }

  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(2),
        height: 140,
        child: Card(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Location " '${location}' ' - ' "No " '${no}'),
              ]),
        ));
  }
}

class ListBoxDisplay extends StatefulWidget {
  var item;
  ListBoxDisplay({Key key, this.item}) : super(key: key);
  @override
  _ListBoxDisplay createState() => _ListBoxDisplay(item: item);
}

class _ListBoxDisplay extends State<ListBoxDisplay> {
  String no;
  String role;
  var item;
  _ListBoxDisplay({Key key, this.item}) {
    no = item['no'].toString();
    role = item['role'];
    print(role);
  }

  Widget build(BuildContext context) {
    return display();
  }

  Widget display() {
    if (role == null)
      return Container(
          padding: EdgeInsets.all(2),
          height: 140,
          child: Card(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("No " '${no}'),
                ]),
          ));
    if (role == 'own') {
      return Container(
          padding: EdgeInsets.all(2),
          height: 140,
          child: Card(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[Text("No " '${no}'), Text('Own')]),
          ));
    }
    if (role == "auth") {
      return Container(
          padding: EdgeInsets.all(2),
          height: 140,
          child: Card(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[Text("No " '${no}'), Text('Auth')]),
          ));
    }
  }
}
