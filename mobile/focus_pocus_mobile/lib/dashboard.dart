import 'dart:convert';
import 'package:focus_pocus_mobile/delete_routine.dart';
import 'package:focus_pocus_mobile/edit_routine.dart';
import 'package:focus_pocus_mobile/login.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:focus_pocus_mobile/add_routine.dart';
import 'package:focus_pocus_mobile/routine_timer.dart';

import 'Routine.dart';

class MyDashboardPage extends StatefulWidget {
  MyDashboardPage({Key key, this.title, this.token}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final String token;

  @override
  _MyDashboardState createState() => _MyDashboardState();
}

class Post {
  final String token;
  final List<Routine> routines;
  final String message;

  Post({this.token, this.routines, this.message});

  factory Post.fromJson(Map<String, dynamic> json) {

    return Post(
      token: json['token'],
      routines: List<Routine>.from(json['routines'].map((i) => Routine.fromJson(i))),
      message: json['message'],
    );
  }
}

class _MyDashboardState extends State<MyDashboardPage> with SingleTickerProviderStateMixin
{
  Future<Post> fetchPost(String token) async {
    var mUrl = "http://54.221.121.199/userRoutines";
    // {'username': '$username', 'email': '$email', 'password': '$password'}
    var body = json.encode({
      "token": '$token',
    });

    var response = await http.post(mUrl,
        body: body,
        headers: {'Content-type': 'application/json'});

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      Post mPost = Post.fromJson(json.decode(response.body));

      /*
      Fluttertoast.showToast(
          msg: mPost.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );*/

      return mPost;
    } else {
      // If that call was not successful, throw an error.
      Post mPost = Post.fromJson(json.decode(response.body));

      /*
      Fluttertoast.showToast(
          msg: mPost.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );*/

      throw Exception('Failed to load post');
    }
  }

  List<Routine> routines;
  final List<int> colorCodes = <int>[600, 500];

  Duration timeStandard = new Duration(minutes: 25);
  Duration timeRemaining;

  Post mPost;
  String timerStartPauseText = "";
  String startTimer = "Start";
  String pauseTimer = "Pause";
  bool isRunning = false;

  DateTime targetTime;
  String timeLeft = "";

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Pomodoro Routines'),
    /*
    Tab(text: 'Power-Napper'),
    Tab(text: 'Intake Tracker'),*/
  ];

  void createSubMenu()
  {

  }

  TabController _tabController;

  Future<Post> retrievePost ()
  async {
    mPost = await fetchPost(widget.token);
    return mPost;
  }

  @override
  void initState() {
    super.initState();
    timerStartPauseText = startTimer;
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void mAddRoutine()
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyAddRoutinePage(title: 'Add Routine', token: widget.token)));
  }

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    if (choice.title == "Edit Routine")
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyEditRoutinePage(title: 'Edit Routine', token: widget.token, routine: choice.routine)));
    else
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyDeleteRoutinePage(title: 'Delete Routine', token: widget.token, routine: choice.routine)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              color: Colors.white,
            ),
            onPressed: () {
              mAddRoutine();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(title: 'Login')));
            },
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: myTabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: myTabs.map((Tab tab) {
          if (tab.text == "Pomodoro Routines")
            return Center(
              child: Container(
                child: FutureBuilder(
                  future: fetchPost(widget.token),
                  builder: (BuildContext context, AsyncSnapshot<Post> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return new Text('Issue Posting Data');
                      case ConnectionState.waiting:
                        return new Center(child: new CircularProgressIndicator());
                      case ConnectionState.active:
                        return new Text('');
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Uh oh! No Routines Found! Start populating this list by creating a new routine with the Plus Symbol above!',
                                style: TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              )
                            ],
                          );
                        } else {
                          routines = snapshot.data.routines;
                          return new ListView.builder(
                            itemCount: routines.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                child: ListTile(
                                  title: Text('${routines[index].routineName}'),
                                  trailing: PopupMenuButton<Choice>(
                                    onSelected: _select,
                                    itemBuilder: (BuildContext context) {
                                      return routines[index].choices.map((Choice choice) {
                                        return PopupMenuItem<Choice>(
                                          value: choice,
                                          child: Text(choice.title),
                                        );
                                      }).toList();
                                    },
                                  ),
                                  /*,*/
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyRoutineTimerPage(title: '${routines[index].routineName} routine', routine: routines[index])));
                                  },
                                  dense: false,
                                ),
                                color: Colors.amber[colorCodes[index%2]],
                              );
                            },
                          );
                        }
                    }
                  }
                ),
              ),
              /*ListView.builder(
                itemCount: routines.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: ListTile(
                      title: Text('${routines[index].getRoutineName()}'),
                      trailing: Icon(Icons.more_vert),
                      onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MyRoutineTimerPage(title: '${routines[index]} Timer')));
                        },
                      dense: false,
                    ),
                    color: Colors.amber[colorCodes[index%2]],
                  );
                },
              ),*/
            );
          /*
          else if(tab.text == "Power-Napper")
            return Center(
              child: Column(
                // Column is also a layout widget. It takes a list of children and
                // arranges them vertically. By default, it sizes itself to fit its
                // children horizontally, and tries to be as tall as its parent.
                //
                // Invoke "debug painting" (press "p" in the console, choose the
                // "Toggle Debug Paint" action from the Flutter Inspector in Android
                // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
                // to see the wireframe for each widget.
                //
                // Column has various properties to control how it sizes itself and
                // how it positions its children. Here we use mainAxisAlignment to
                // center the children vertically; the main axis here is the vertical
                // axis because Columns are vertical (the cross axis would be
                // horizontal).
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Center(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: IntrinsicHeight(
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: <Widget>
                                          [
                                            Container(
                                              child: Icon(
                                                Icons.access_alarm,
                                                size: 40,
                                              ),
                                              decoration: new BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius: new BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  bottomLeft: Radius.circular(20),
                                                ),
                                              ),
                                              padding: EdgeInsets.only(left: 5),
                                            ),
                                            Flexible(
                                              child: TextField(
                                                textAlign: TextAlign.left,
                                                decoration: new InputDecoration(
                                                  hintText: 'Set Focus Timer',
                                                  border: new OutlineInputBorder(
                                                    borderRadius: BorderRadius.only(
                                                      topRight: Radius.circular(20),
                                                      bottomRight: Radius.circular(20),
                                                    ),
                                                    borderSide: new BorderSide(
                                                      color: Colors.black,
                                                      width: 0.5,
                                                    ),
                                                  ),
                                                ),
                                                style: TextStyle(fontSize: 16, color: Colors.white),
                                              ),
                                            ),
                                          ]
                                      ),
                                    ),
                                    margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
                                  ),
                                  Container(
                                    child: IntrinsicHeight(
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: <Widget>
                                          [
                                            Container(
                                              child: Icon(
                                                Icons.alarm_off,
                                                size: 40,
                                              ),
                                              decoration: new BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius: new BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  bottomLeft: Radius.circular(20),
                                                ),
                                              ),
                                              padding: EdgeInsets.only(left: 5),
                                            ),
                                            Flexible(
                                              child: TextField(
                                                textAlign: TextAlign.left,
                                                decoration: new InputDecoration(
                                                  hintText: 'Set Break Timer',
                                                  border: new OutlineInputBorder(
                                                    borderRadius: BorderRadius.only(
                                                      topRight: Radius.circular(20),
                                                      bottomRight: Radius.circular(20),
                                                    ),
                                                    borderSide: new BorderSide(
                                                      color: Colors.black,
                                                      width: 0.5,
                                                    ),
                                                  ),
                                                ),
                                                style: TextStyle(fontSize: 16, color: Colors.white),
                                              ),
                                            ),
                                          ]
                                      ),
                                    ),
                                    margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
                                  ),
                                ],
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: RaisedButton(
                            child: Text('$timerStartPauseText'),
                            onPressed: () {
                              if (!isRunning)
                              {
                                isRunning = true;
                                timerStartPauseText = pauseTimer;
                                //executeTimer();
                              }
                              else
                              {
                                isRunning = false;
                                timerStartPauseText = startTimer;
                              }
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                            ),
                          ),
                          margin: EdgeInsets.only(right: 15),
                        ),
                        Container(
                          child: RaisedButton(
                            child: Text('Reset Timer'),
                            onPressed: () {
                              timerStartPauseText = startTimer;
                              timeLeft = timeStandard.inMinutes.toString() + ":" + (timeStandard.inSeconds % 60).toString().padLeft(2,'0');
                              timeRemaining = null;
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                            ),
                          ),
                          margin: EdgeInsets.only(left: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            );*/
          else
            return Center(
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: routines.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 50,
                    color: Colors.amber[colorCodes[index%2]],
                    child: Center(child: Text('Entry ${routines[index]}')),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(),
              ),
            );
        }).toList(),
      ),
    );
  }
}