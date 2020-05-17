import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'UserDetail.dart';
import 'dart:convert';
import 'RegBox.dart';
import 'scaffold_custom.dart';

class RegStation extends StatefulWidget {
  @override
  _RegStation createState() => _RegStation();
}

class _RegStation extends State<RegStation> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        drawer: AppDrawer(),
        appBar: new AppBar(
          title: new Text("Register"),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.blue, Colors.teal[100]],
              ),
            ),
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
        body: ListView.builder(
          itemCount: UserDetails.regStation.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: ListStationDisplay(item: UserDetails.regStation[index]),
              onTap: () async {
                Response response = await post(UserDetails.api + 'list_box',
                    body: {'station_id': UserDetails.regStation[index]['_id']});
                var result = jsonDecode(response.body);
                UserDetails.regBox = result;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RegBox(item: UserDetails.regStation[index]),
                  ),
                );
              },
            );
          },
        ),
        bottomNavigationBar: Naviagationbar());
  }
}
