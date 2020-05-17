import 'package:flutter/material.dart';
import 'scaffold_custom.dart';
import 'UserDetail.dart';
import 'authBox.dart';

class AuthStation extends StatefulWidget {
  @override
  _AuthStation createState() => _AuthStation();
}

class _AuthStation extends State<AuthStation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: new Text("Choose station"),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.blue, Colors.teal[100]],
              ),
            ),
          ),
          // title: Image.asset(
          //   'image/Logo.png',
          //   fit: BoxFit.contain,
          //   height: 45,
          // ),
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
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: UserDetails.listStation.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: ListStationDisplay(
                          item: UserDetails.listStation[index]),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AuthBox(item: UserDetails.listStation[index]),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ]),
        bottomNavigationBar: Naviagationbar());
  }
}
