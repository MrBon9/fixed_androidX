import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'UserDetail.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegBox extends StatefulWidget {
  var item;
  RegBox({Key key, this.item}) : super(key: key);
  @override
  _RegBox createState() => _RegBox(item: item);
}

class _RegBox extends State<RegBox> {
  String current_station_location;
  String current_station_no;
  String current_station_id;
  var item;
  _RegBox({Key key, this.item}) {
    current_station_location = item["location"];
    current_station_no = item["no"];
    current_station_id = item["_id"];
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
          itemCount: UserDetails.regBox.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: ListBoxDisplay(item: UserDetails.regBox[index]),
              onTap: () {
                print(UserDetails.regBox[index]);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RegBoxProcess(item: UserDetails.regBox[index]),
                  ),
                );
              },
            );
          },
        ),
        bottomNavigationBar: Naviagationbar());
  }
}

class RegBoxProcess extends StatefulWidget {
  var item;
  RegBoxProcess({Key key, this.item}) : super(key: key);
  @override
  _RegBoxProcess createState() => _RegBoxProcess(item: item);
}

class _RegBoxProcess extends State<RegBoxProcess> {
  var message;
  var item;
  _RegBoxProcess({Key key, this.item}) {
    print(item);
  }

  static const platform = const MethodChannel('flutter.native/AndroidPlatform');

  // Future<void> responseFromNativeCode(no, amount) async {
  //   final String result = await platform.invokeMethod(
  //       'helloFromNativeCode', {"box_no": "${no}", "amount": amount});
  //   var response = json.decode(result);
  //   message = response["message"];

  //   print(response["message"]);
  // }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("No ${item['no']}"),
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
            child: Column(children: <Widget>[
          CheckBox(),
          RaisedButton(
              onPressed: () async {
                String period_kind;
                int amount;
                if (_CheckBoxState.oneHour == true) {
                  period_kind = "1";
                  amount = 1000;
                } else if (_CheckBoxState.oneDay == true) {
                  period_kind = "2";
                  amount = 4000;
                } else if (_CheckBoxState.oneMonth == true) {
                  period_kind = "3";
                  amount = 16000;
                }

                if (period_kind != null) {
                  Response checkOwn =
                      await post(UserDetails.api + 'checkOwn', body: {
                    'id_num': UserDetails.id,
                    'box_id': item['_id'],
                    'station_id': item['station_id']
                  });

                  var checkOwn_result = (checkOwn.body);
                  print(checkOwn_result);
                  if (checkOwn_result.contains('0')) {
                    print("Ok");

                    //call Android plaftform
                    final String getMoMoToken = await platform.invokeMethod(
                        'getMoMoToken', {
                      "box_no": "${item['no']}",
                      "amount": amount,
                      "period": period_kind
                    });
                    var getMoMoToken_result = json.decode(getMoMoToken);

                    print(getMoMoToken_result);
                    if (getMoMoToken_result["status"] == 0) {
                      Fluttertoast.showToast(
                          msg: "transaction in processing",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white);

                      Response prePay =
                          await post(UserDetails.api + 'prePay', body: {
                        'id_num': UserDetails.id,
                        'box_id': item['_id'],
                        'station_id': item['station_id'],
                        'period_kind': period_kind,
                        'partnerCode': "MOMOTOAE20200418",
                        'customerNumber': getMoMoToken_result["phonenumber"],
                        'token': getMoMoToken_result['data'],
                        'amount': amount.toString(),
                      });
                      var prePay_result = json.decode(prePay.body);
                      print(prePay_result);
                    } else if (getMoMoToken_result["status"] == 5) {
                      Fluttertoast.showToast(
                          msg: "Timeout transaction",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white);
                    } else if (getMoMoToken_result["status"] == 6) {
                      Fluttertoast.showToast(
                          msg: "Transaction is canceled",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white);
                    }
                  } else if (checkOwn_result.contains('1')) {
                    Fluttertoast.showToast(
                        msg: "Box is already hired",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white);
                  }
                }
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
                child: const Text('Register', style: TextStyle(fontSize: 20)),
              )),
        ])),
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
  void initState() {
    setState(() {
      oneHour = false;
      oneDay = false;
      oneMonth = false;
    });
    super.initState();
  }

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
              Text("One hour - 1000"),
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
              Text("One day - 4000"),
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
              Text("One month - 16000"),
            ],
          ),
        ],
      ),
    );
  }
}
