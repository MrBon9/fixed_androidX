import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'UserDetail.dart';

class ListBox extends StatefulWidget {
  var item;
  ListBox({Key key, this.item}) : super(key: key);
  @override
  _ListBox createState() => _ListBox(item: item);
}

class _ListBox extends State<ListBox> {
  String current_station_location;
  String current_station_no;
  String current_station_id;
  String current_role;
  var item;
  _ListBox({Key key, this.item}) {
    UserDetails.listBox = new List();
    current_station_location = item["location"];
    current_station_no = item["no"];
    current_station_id = item["_id"];

    for (var i = 0; i < UserDetails.store.length; i++) {
      var inside_store = UserDetails.store[i];
      if (current_station_id == inside_store["station_id"]) {
        var boxJson = {
          "_id": inside_store['box_id'],
          "no": inside_store["cabinet"][0]["no"],
          "state": inside_store["cabinet"][0]['state'],
          "station_id": inside_store['cabinet'][0]['station_id'],
          "role": inside_store['role']
        };
        UserDetails.listBox.add(boxJson);
      }
    }

    print(UserDetails.listBox);
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
                    builder: (context) => Box(item: UserDetails.listBox[index]),
                  ),
                );
              },
            );
          },
        ),
        bottomNavigationBar: Naviagationbar());
  }
}

class Box extends StatefulWidget {
  var item;
  Box({Key key, this.item}) : super(key: key);
  @override
  _Box createState() => _Box(item: item);
}

class _Box extends State<Box> {
  var item;
  var box_id;
  var box_no;
  var station_id;
  var role;

  _Box({Key key, this.item}) {
    box_id = item['_id'];
    box_no = item['no'];
    station_id = item['station_id'];
    role = item['role'];

    print(item);
  }

  Widget deletemode() {
    if (role == null) return Container();
    if (role == 'own')
      return RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          onPressed: () async {
            Response response =
                await post(UserDetails.api + 'delete_a_box', body: {
              'id_num': UserDetails.id.toString(),
              'box_id': box_id.toString(),
              'box_no': box_no.toString(),
              'station_id': station_id.toString()
            });
            Fluttertoast.showToast(
                msg: response.body,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.blue,
                textColor: Colors.white);
          },
          textColor: Colors.white,
          padding: const EdgeInsets.all(0.0),
          child: Ink(
            // decoration: const BoxDecoration(
            //   gradient: LinearGradient(
            //       colors: <Color>[Colors.blue, Colors.white],
            //       begin: Alignment.topCenter,
            //       end: Alignment.bottomCenter),
            //   borderRadius:
            //       BorderRadius.all(Radius.circular(80.0)),
            // ),
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
            child: const Text('Delete button', style: TextStyle(fontSize: 20)),
          ));

    if (role == 'auth')
      return RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          onPressed: () async {
            Response response =
                await post(UserDetails.api + 'reject_a_box', body: {
              'authorize_id': UserDetails.id,
              'box_id': box_id,
              'station_id': station_id,
            });
            Fluttertoast.showToast(
                msg: response.body,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.blue,
                textColor: Colors.white);
          },
          textColor: Colors.white,
          padding: const EdgeInsets.all(0.0),
          child: Ink(
            // decoration: const BoxDecoration(
            //   gradient: LinearGradient(
            //       colors: <Color>[Colors.blue, Colors.white],
            //       begin: Alignment.topCenter,
            //       end: Alignment.bottomCenter),
            //   borderRadius:
            //       BorderRadius.all(Radius.circular(80.0)),
            // ),
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
            child: const Text('Reject button', style: TextStyle(fontSize: 20)),
          ));
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
                padding: EdgeInsets.only(top: 30.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                          onPressed: () async {
                            String qrResult = await UserDetails.Scann_QR();

                            print(qrResult);
                            if (qrResult != null) {
                              Response response = await post(
                                  UserDetails.api + 'open_box',
                                  body: {
                                    'id_num': UserDetails.id.toString(),
                                    'box_id': box_id.toString(),
                                    'box_no': box_no.toString(),
                                    'token': qrResult.toString()
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
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(0.0),
                          child: Ink(
                            // decoration: const BoxDecoration(
                            //   gradient: LinearGradient(
                            //       colors: <Color>[Colors.blue, Colors.white],
                            //       begin: Alignment.topCenter,
                            //       end: Alignment.bottomCenter),
                            //   borderRadius:
                            //       BorderRadius.all(Radius.circular(80.0)),
                            // ),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(80.0)),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child: const Text('Open button',
                                style: TextStyle(fontSize: 20)),
                          )),
                      deletemode()
                    ]))),
        bottomNavigationBar: Naviagationbar());
  }
}

class CheckBox extends StatefulWidget {
  @override
  _CheckBoxState createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  static bool oneHour = false;
  static bool oneDay = false;
  static bool oneMonth = false;
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
                value: oneHour,
                onChanged: (bool value) {
                  setState(() {
                    oneHour = value;
                  });
                  if (value == true) {
                    setState(() {
                      oneDay = false;
                      oneMonth = false;
                    });
                  }
                },
              ),
              Text("One hour"),
            ],
          ),
          // [Tuesday] checkbox
          Row(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Checkbox(
                value: oneDay,
                onChanged: (bool value) {
                  setState(() {
                    oneDay = value;
                  });
                  if (value == true) {
                    setState(() {
                      oneHour = false;
                      oneMonth = false;
                    });
                  }
                },
              ),
              Text("One day"),
            ],
          ),
          // [Wednesday] checkbox
          Row(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Checkbox(
                value: oneMonth,
                onChanged: (bool value) {
                  setState(() {
                    oneMonth = value;
                  });
                  if (value == true) {
                    setState(() {
                      oneDay = false;
                      oneHour = false;
                    });
                  }
                },
              ),
              Text("One month"),
            ],
          ),
        ],
      ),
    );
  }
}
