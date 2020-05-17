import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'UserDetail.dart';
import 'package:flutter/services.dart';

class AuthBox extends StatefulWidget {
  var item;
  AuthBox({Key key, this.item}) : super(key: key) {}
  @override
  _AuthBox createState() => _AuthBox(item: item);
}

class _AuthBox extends State<AuthBox> {
  String current_station_location;
  String current_station_no;
  String current_station_id;
  String current_role;
  var item;
  _AuthBox({Key key, this.item}) {
    UserDetails.listBox = new List();
    current_station_location = item["location"];
    current_station_no = item["no"];
    current_station_id = item["_id"];

    for (var i = 0; i < UserDetails.store.length; i++) {
      var inside_store = UserDetails.store[i];
      if (current_station_id == inside_store["station_id"] &&
          inside_store['role'] == 'own') {
        var boxJson = {
          "_id": inside_store['box_id'],
          "no": inside_store["cabinet"][0]["no"],
          "state": inside_store["cabinet"][0]['state'],
          "station_id": inside_store['cabinet'][0]['station_id'],
          "role": inside_store['role'],
          "start_time": inside_store['start_time'],
          "end_time": inside_store['end_time'],
        };
        UserDetails.listBox.add(boxJson);
      }
    }

    print(UserDetails.store);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Location "
              '${current_station_location}'
              ' - '
              "No "
              '${current_station_no}'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.blue, Colors.teal[100]],
              ),
            ),
          ),
        ),
        body: ListView.builder(
          itemCount: UserDetails.listBox.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: ListBoxDisplay(item: UserDetails.listBox[index]),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AuthBoxProc(item: UserDetails.listBox[index]),
                  ),
                );
              },
            );
          },
        ),
        bottomNavigationBar: Naviagationbar());
  }
}

class AuthBoxProc extends StatefulWidget {
  var item;
  AuthBoxProc({Key key, this.item}) : super(key: key) {}
  @override
  _AuthBoxProc createState() => _AuthBoxProc(item: item);
}

class _AuthBoxProc extends State<AuthBoxProc> {
  var item;
  var box_id;
  var box_no;
  var station_id;
  var role;
  var hello;

  _AuthBoxProc({Key key, this.item}) {
    box_no = item['no'];
    print(item);
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("No " '${box_no}'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.blue, Colors.teal[100]],
              ),
            ),
          ),
        ),
        body: Container(
            child: Padding(
          padding: EdgeInsets.only(top: 0.0),
          child: Container(
              child: Column(children: <Widget>[
            CheckBox(),
            RaisedButton(
                onPressed: () async {
                  String transfer = _CheckBoxState.limitControler.text;

                  String limit;
                  if (_CheckBoxState.unlimited) {
                    limit = 'unlimited';
                  } else {
                    if (transfer.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Enter number!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white);
                      return;
                    } else
                      limit = int.parse(transfer).toString();
                  }
                  print(limit);
                  Response response =
                      await post(UserDetails.api + 'auth_a_box', body: {
                    'authorize_id': UserDetails.auth_id,
                    'owner_id': UserDetails.id,
                    'box_id': item['_id'],
                    'station_id': item['station_id'],
                    'limit': limit,
                    'start_time': item['start_time'],
                    'end_time': item['end_time']
                  });
                  print(response.body);
                  Fluttertoast.showToast(
                      msg: response.body,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 1,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white);

                  // String trans = _CheckBoxState.limitControler.text;
                  // print(trans);

                  // if (period_kind != null) {
                  //   Response response =
                  //       await post(UserDetails.api + '/order', body: {
                  //     'id_num': UserDetails.id,
                  //     'box_id': item['_id'],
                  //     'station_id': item['station_id'],
                  //     'period_kind': period_kind
                  //   });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0)),
                textColor: Colors.white,
                padding: const EdgeInsets.all(0.0),
                child: Ink(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Color(0xFF0D47A1),
                        Color(0xFF1976D2),
                        Color(0xFF42A5F5),
                      ],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(80.0)),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: const Text('Submit button',
                      style: TextStyle(fontSize: 20)),
                )),
          ])),
        )),
        bottomNavigationBar: Naviagationbar());
  }
}

class CheckBox extends StatefulWidget {
  @override
  _CheckBoxState createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  static TextEditingController limitControler = new TextEditingController();
  static bool unlimited = false;
  String result;

  // _CheckBoxState() {
  //   setState(() {
  //     result = limitControler.text;
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // [Monday] checkbox
          Row(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Checkbox(
                value: unlimited,
                onChanged: (bool value) {
                  setState(() {
                    unlimited = value;
                  });
                },
              ),
              Text("Unlimited"),
            ],
          ),
          unlimited
              ? Container()
              : Padding(
                  padding: EdgeInsets.all(40.0),
                  child: new TextFormField(
                      controller: limitControler,
                      decoration: new InputDecoration(
                          labelText: "Enter number of using"),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ]),
                ),
        ],
      ),
    );
  }
}
