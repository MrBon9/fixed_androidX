import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'scaffold_custom.dart';
import 'UserDetail.dart';

class Home_screen extends StatefulWidget {
  @override
  _Home_screen createState() => _Home_screen();
}

class _Home_screen extends State<Home_screen> {
  @override
  Widget build(BuildContext context) {
    var loc = '\u{1F4CD}';
    var map = '\u{1F5FA}';
    var cab_icon = '\u{1F5C4}';
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 18.0, 0.0, 10.0),
                child: Text(
                  'Location',
                  style: TextStyle(fontSize: 45.0),
                ),
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
                      child: Container(
                        height: 100.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(9.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.2),
                              spreadRadius: 4,
                              blurRadius: 5,
                            )
                          ],
                          color: Colors.white,
                        ),
                        child: ListTile(
                          // leading: ,
                          title: Text(
                            '$cab_icon A4 Automactic Cabinet  \n$loc 268 Ly Thuong Kiet, District 10 \n$map Ho Chi Minh City, Viet Nam',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          onTap: () {},
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
                      child: Container(
                        height: 100.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(9.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.2),
                              spreadRadius: 4,
                              blurRadius: 5,
                            )
                          ],
                          color: Colors.white,
                        ),
                        child: ListTile(
                          // leading: ,
                          title: Text(
                            '$cab_icon A5 Automactic Cabinet  \n$loc 268 Ly Thuong Kiet, District 10 \n$map Ho Chi Minh City, Viet Nam',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          onTap: () {},
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
                      child: Container(
                        height: 100.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(9.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.2),
                              spreadRadius: 4,
                              blurRadius: 5,
                            )
                          ],
                          color: Colors.white,
                        ),
                        child: ListTile(
                          // leading: ,
                          title: Text(
                            '$cab_icon B4 Automactic Cabinet  \n$loc 268 Ly Thuong Kiet, District 10 \n$map Ho Chi Minh City, Viet Nam',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          onTap: () {},
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
                      child: Container(
                        height: 100.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(9.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.2),
                              spreadRadius: 4,
                              blurRadius: 5,
                            )
                          ],
                          color: Colors.white,
                        ),
                        child: ListTile(
                          // leading: ,
                          title: Text(
                            '$cab_icon C5 Automactic Cabinet  \n$loc 268 Ly Thuong Kiet, District 10 \n$map Ho Chi Minh City, Viet Nam',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          onTap: () {},
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
                      child: Container(
                        height: 100.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(9.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.2),
                              spreadRadius: 4,
                              blurRadius: 5,
                            )
                          ],
                          color: Colors.white,
                        ),
                        child: ListTile(
                          // leading: ,
                          title: Text(
                            '$cab_icon Mr.Bon Automactic Cabinet  \n$loc Di An Town \n$map Binh Duong Province, Viet Nam',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          onTap: () {},
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
                      child: Container(
                        height: 100.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(9.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.2),
                              spreadRadius: 4,
                              blurRadius: 5,
                            )
                          ],
                          color: Colors.white,
                        ),
                        child: ListTile(
                          // leading: ,
                          title: Text(
                            '$cab_icon Dorm Automactic Cabinet  \n$loc 497 Hoa Hao, District 10 \n$map Ho Chi Minh City, Viet Nam',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          onTap: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: Naviagationbar());
  }

  Future handler(MethodCall call) {}
}
