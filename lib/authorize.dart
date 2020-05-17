import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'UserDetail.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'scaffold_custom.dart';
import 'authStation.dart';

var current_auth_id;
var current_station_id;
var current_box_id;

class Authorize extends StatefulWidget {
  // ExamplePage({ Key key }) : super(key: key);
  @override
  _ExamplePageState createState() => new _ExamplePageState();
}

class _ExamplePageState extends State<Authorize> {
  // final formKey = new GlobalKey<FormState>();
  // final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _filter = new TextEditingController();

  String _searchText = "";
  List searchData = new List();
  List searchDisplay = new List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Authorize User');

  List auth_display = new List();

  _ExamplePageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          //searchData = store;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    _filter.clear();
    this._searchData();
    this._getAuthUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: _buildBar(context),
      body: Container(
          child: this._searchIcon.icon == Icons.search
              ? _buildListAuth()
              : _buildListSearch()),
      resizeToAvoidBottomPadding: false,
      bottomNavigationBar: Naviagationbar(),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Colors.blue, Colors.teal[100]]))),
      // leading: new IconButton(
      //   icon: _searchIcon,
      //   onPressed: _searchPressed,
      // ),
      actions: <Widget>[
        Container(
            padding: EdgeInsets.all(2.0),
            child: IconButton(
              onPressed: () {
                print('search');
                this._searchPressed();
              },
              icon: Icon(Icons.search),
            ))
      ],
    );
  }

  Widget _buildListAuth() {
    return ListView.builder(
      itemCount: auth_display == null ? 0 : auth_display.length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          title: Text(auth_display[index]['username'] +
              ' - ' +
              auth_display[index]['email']),
          onTap: () {
            current_auth_id = auth_display[index]['_id'];
            UserDetails.auth_id = auth_display[index]['_id'];
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ListChoice(item: auth_display[index]),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildListSearch() {
    if (!(_searchText.isEmpty)) {
      var convert = _searchText.toLowerCase();
      RegExp re = RegExp(r'' "^${convert}" '.*\$');
      searchDisplay = new List();

      for (int i = 0; i < searchData.length; i++) {
        searchDisplay.add(searchData[i]);
      }

      List tempList = new List();
      for (int i = 0; i < searchDisplay.length; i++) {
        if (re.hasMatch(searchDisplay[i]['email'].toLowerCase())) {
          tempList.add(searchDisplay[i]);
        }
        // if (searchData[i].toLowerCase().contains(_searchText.toLowerCase())) {
        //   tempList.add(searchData[i]);
        // }
      }
      searchDisplay = tempList;
      //print(searchDisplay);
    } else {
      print('ok');
      searchDisplay.clear();
    }
    return ListView.builder(
      itemCount: searchDisplay.length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          title: Text(searchDisplay[index]['email']),
          onTap: () {
            UserDetails.auth_id = searchDisplay[index]['_id'];
            print(searchDisplay[index]['email']);
            var check = false;
            for (var i = 0; i < auth_display.length; i++) {
              if (auth_display[i]['_id'] == searchDisplay[index]['_id']) {
                check = true;
                break;
              }
            }
            if (check == true) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListChoice(item: searchDisplay[index]),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AuthProcess(item: searchDisplay[index]),
                ),
              );
            }
            // setState(() {
            //   _filter.clear();
            // });
          },
        );
      },
    );
  }

  void _searchPressed() {
    setState(() {
      //filteredNames.clear();
      print('hello');
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search), hintText: 'Search...'),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Authorize User');
        //dsearchResult = store;
        _filter.clear();
      }
    });
  }

  void _searchData() async {
    Response response = await post(UserDetails.api + 'list_user', body: {});
    var result = jsonDecode(response.body);
    List<dynamic> tempList = new List();

    for (int i = 0; i < result.length; i++) {
      if (UserDetails.id != result[i]['_id']) tempList.add(result[i]);
    }

    if (this.mounted) {
      setState(() {
        //tempList.shuffle();
        searchData = tempList;
      });
      //print(searchData);
    }
  }

  void _getAuthUser() async {
    Response response = await post(UserDetails.api + 'list_authorize',
        body: {'id_num': UserDetails.id});
    var result = jsonDecode(response.body);
    UserDetails.auth_store = (result);
    List temp = new List();
    for (var i = 0; i < result.length; i++) {
      if (temp.length == 0) {
        temp.add(result[i]['Authorize'][0]);
      } else {
        for (var j = 0; j < temp.length; j++) {
          var check = false;
          if (temp[j]['_id'] == result[i]['Authorize'][0]['_id']) check = true;
          if (check == false) temp.add(result[i]['Authorize'][0]);
        }
      }
    }

    if (this.mounted) {
      setState(() {
        auth_display = temp;
      });
    }
  }
}

class AuthProcess extends StatefulWidget {
  var item;
  AuthProcess({Key key, this.item}) : super(key: key) {}
  @override
  _AuthProcess createState() => _AuthProcess(item: item);
}

class _AuthProcess extends State<AuthProcess> {
  var item;
  _AuthProcess({Key key, this.item}) {}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(item['username']),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AuthStation()),
                          );
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         ListStation_auth(item: item),
                          //   ),
                          // );
                          // String qrResult = await UserDetails.Scann_QR();

                          // print(qrResult);
                          // if (qrResult != null) {
                          //   Response response = await post(
                          //       UserDetails.api + '/open_box',
                          //       body: {
                          //         'id_num': UserDetails.id.toString(),
                          //         'box_id': box_id.toString(),
                          //         'box_no': box_no.toString(),
                          //         'token': qrResult.toString()
                          //       });
                          //   Fluttertoast.showToast(
                          //       msg: response.body,
                          //       toastLength: Toast.LENGTH_SHORT,
                          //       gravity: ToastGravity.BOTTOM,
                          //       timeInSecForIos: 1,
                          //       backgroundColor: Colors.blue,
                          //       textColor: Colors.white);
                          // }
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
                          child: const Text('Authorize',
                              style: TextStyle(fontSize: 20)),
                        )),
                  ]))),
      bottomNavigationBar: Naviagationbar(),
    );
  }
}

class ListChoice extends StatefulWidget {
  var item;
  ListChoice({Key key, this.item}) : super(key: key) {}
  @override
  _ListChoice createState() => _ListChoice(item: item);
}

class _ListChoice extends State<ListChoice> {
  var auth_username;
  var item;
  _ListChoice({Key key, this.item}) {
    auth_username = item['username'];
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(auth_username),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ListStation_auth(item: item),
                            ),
                          );
                          // String qrResult = await UserDetails.Scann_QR();

                          // print(qrResult);
                          // if (qrResult != null) {
                          //   Response response = await post(
                          //       UserDetails.api + '/open_box',
                          //       body: {
                          //         'id_num': UserDetails.id.toString(),
                          //         'box_id': box_id.toString(),
                          //         'box_no': box_no.toString(),
                          //         'token': qrResult.toString()
                          //       });
                          //   Fluttertoast.showToast(
                          //       msg: response.body,
                          //       toastLength: Toast.LENGTH_SHORT,
                          //       gravity: ToastGravity.BOTTOM,
                          //       timeInSecForIos: 1,
                          //       backgroundColor: Colors.blue,
                          //       textColor: Colors.white);
                          // }
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
                          child: const Text('List Boxes',
                              style: TextStyle(fontSize: 20)),
                        )),
                    RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        onPressed: () async {
                          print('hello');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AuthStation()),
                          );
                          // Response response = await post(
                          //     UserDetails.api + '/delete_a_box',
                          //     body: {
                          //       'id_num': UserDetails.id.toString(),
                          //       'box_id': box_id.toString(),
                          //       'box_no': box_no.toString(),
                          //       'station_id': station_id.toString()
                          //     });
                          // Fluttertoast.showToast(
                          //     msg: response.body,
                          //     toastLength: Toast.LENGTH_SHORT,
                          //     gravity: ToastGravity.BOTTOM,
                          //     timeInSecForIos: 1,
                          //     backgroundColor: Colors.blue,
                          //     textColor: Colors.white);
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(80.0)),
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: const Text('New Box',
                              style: TextStyle(fontSize: 20)),
                        )),
                  ]))),
      bottomNavigationBar: Naviagationbar(),
    );
  }
}

class ListStation_auth extends StatefulWidget {
  var item;
  ListStation_auth({Key key, this.item}) : super(key: key);
  @override
  _ListStation_auth createState() => _ListStation_auth(item: item);
}

class _ListStation_auth extends State<ListStation_auth> {
  String auth_id;
  String auth_username;
  String auth_email;
  List auth_station = new List();
  var item;
  _ListStation_auth({Key key, this.item}) {
    auth_id = item['_id'];
    auth_username = item['username'];
    auth_email = item['email'];
    auth_station = new List();
    for (var i = 0; i < UserDetails.auth_store.length; i++) {
      if (UserDetails.auth_store[i]['authorize_id'] == auth_id) {
        if (auth_station.length == 0) {
          auth_station.add(UserDetails.auth_store[i]['station'][0]);
        } else {
          for (var j = 0; j < auth_station.length; j++) {
            var check = false;
            if (auth_station[j]['_id'] ==
                UserDetails.auth_store[i]['station'][0]['_id']) check = true;
            if (check == false)
              auth_station.add(UserDetails.auth_store[i]['station'][0]);
          }
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(auth_username),
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
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: auth_station.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: ListStationDisplay(item: auth_station[index]),
                    onTap: () {
                      current_station_id = auth_station[index]['_id'];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ListBox_auth(item: auth_station[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ]),
      bottomNavigationBar: Naviagationbar(),
    );
  }
}

class ListBox_auth extends StatefulWidget {
  var item;
  ListBox_auth({Key key, this.item}) : super(key: key) {}

  @override
  _ListBox_auth createState() => _ListBox_auth(item: item);
}

class _ListBox_auth extends State<ListBox_auth> {
  String station_location;
  String station_no;
  String station_id;
  List auth_box = new List();
  var item;
  _ListBox_auth({Key key, this.item}) {
    station_location = item["location"];
    station_no = item["no"];
    station_id = item["_id"];
    auth_box = new List();
    for (var i = 0; i < UserDetails.auth_store.length; i++) {
      if (UserDetails.auth_store[i]['authorize_id'] == current_auth_id &&
          UserDetails.auth_store[i]['station_id'] == station_id) {
        auth_box.add(UserDetails.auth_store[i]['cabinet'][0]);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Location "
            '${station_location}'
            ' - '
            "No "
            '${station_no}'),
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
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: auth_box.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: ListBoxDisplay(item: auth_box[index]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Box_auth1(item: auth_box[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ]),
      bottomNavigationBar: Naviagationbar(),
    );
  }
}

class Box_auth1 extends StatefulWidget {
  var item;
  Box_auth1({Key key, this.item}) : super(key: key);

  @override
  _Box_auth1 createState() => _Box_auth1(item: item);
}

class _Box_auth1 extends State<Box_auth1> {
  var item;
  var box_id;
  var box_no;
  var station_id;

  _Box_auth1({Key key, this.item}) {
    box_id = item['_id'];
    box_no = item['no'];
    station_id = item['station_id'];
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
                padding: EdgeInsets.only(top: 30.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                          onPressed: () async {
                            // String qrResult = await UserDetails.Scann_QR();

                            Response response = await post(
                                UserDetails.api + 'revoke_a_box',
                                body: {
                                  'authorize_id': UserDetails.auth_id,
                                  'owner_id': UserDetails.id,
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
                            child: const Text('Revoke',
                                style: TextStyle(fontSize: 20)),
                          )),
                    ]))),
        bottomNavigationBar: Naviagationbar());
  }
}
