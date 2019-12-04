import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Routine.dart';
import 'dashboard.dart';

import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;


class Post {
  final String token;
  final String message;

  Post({this.token, this.message});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      token: json['token'],
      message: json['message'],
    );
  }
}

class MyEditRoutinePage extends StatefulWidget {
  MyEditRoutinePage({Key key, this.title, this.token, this.routine}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final String token;
  final Routine routine;

  @override
  _MyEditRoutineState createState() => _MyEditRoutineState();
}

class _MyEditRoutineState extends State<MyEditRoutinePage> with SingleTickerProviderStateMixin {

  Future<Post> fetchPost(String token, String routineId, String routineName,
      int pomTimer, int breakTimer, int pomCount, int breakCount,
      int largeBreakCount, bool goalHit) async {
    var mUrl = "http://54.221.121.199/editRoutine";
    // {'username': '$username', 'email': '$email', 'password': '$password'}
    var body = json.encode({
      "token": '$token',
      "_id": '$routineId',
      "routineName": '$routineName',
      "pomTimer": '$pomTimer',
      "breakTimer": '$breakTimer',
      "pomCount": '$pomCount',
      "breakCount": '$breakCount',
      "largeBreakCount": '$largeBreakCount',
      "goalHit": '$goalHit',
    });

    var response = await http.put(mUrl,
        body: body,
        headers: {'Content-type': 'application/json'});

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      Post mPost = Post.fromJson(json.decode(response.body));

      Fluttertoast.showToast(
          msg: mPost.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );

      Navigator.pop(context, MaterialPageRoute(builder: (context) => MyDashboardPage(title: 'Dashboard', token: mPost.token)));
      return mPost;
    } else {
      // If that call was not successful, throw an error.
      Post mPost = Post.fromJson(json.decode(response.body));

      Fluttertoast.showToast(
          msg: mPost.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

      throw Exception('Failed to load post');
    }
  }

  final _nameController = TextEditingController();
  final _focusController = TextEditingController();
  final _shortBreakController = TextEditingController();
  final _longBreakController = TextEditingController();
  final _goalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.routine.routineName;
    _focusController.text = widget.routine.pomTimer.toString();
    _shortBreakController.text = widget.routine.breakTimer.toString();
    _longBreakController.text = widget.routine.breakCount.toString();
    _goalController.text = widget.routine.largeBreakCount.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/fp_logo_small.png'),
                      Text('Focus Pocus'),
                    ],
                  ),
                  margin: EdgeInsets.all(10),
                ),
                Container(
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Routine Name',
                    ),
                  ),
                  padding: EdgeInsets.only(left: 5),
                  margin: EdgeInsets.all(20),
                ),
                Container(
                  child: TextField(
                    controller: _focusController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ], // Only numbers can be entered
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Focus Timer Duration',
                    ),
                  ),
                  padding: EdgeInsets.only(left: 5),
                  margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                ),
                Container(
                  child: TextField(
                    controller: _shortBreakController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ], // Only numbers can be entered
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Short Break Timer Duration',
                    ),
                  ),
                  padding: EdgeInsets.only(left: 5),
                  margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                ),
                Container(
                  child: TextField(
                    controller: _longBreakController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ], // Only numbers can be entered
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Long Break Timer Duration',
                    ),
                  ),
                  padding: EdgeInsets.only(left: 5),
                  margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                ),
                Container(
                  child: TextField(
                    controller: _goalController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ], // Only numbers can be entered
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Focus Session Goal',
                    ),
                  ),
                  padding: EdgeInsets.only(left: 5),
                  margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                ),
                Container(
                  child: ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: Text('CLEAR'),
                        onPressed: () {
                          _nameController.clear();
                          _focusController.clear();
                          _shortBreakController.clear();
                          _longBreakController.clear();
                          _goalController.clear();
                        },
                      ),
                      RaisedButton(
                        child: Text('EDIT ROUTINE'),
                        onPressed: () {
                          //String token, String routineName, bool coffeeNap,
                          //      int pomTimer, int breakTimer, int pomCount, int breakCount,
                          //      int largeBreakCount, bool goalHit
                          fetchPost(widget.token, widget.routine.routineId,_nameController.text,
                              int.parse(_focusController.text), int.parse(_shortBreakController.text), 0, int.parse(_longBreakController.text), int.parse(_goalController.text), false);
                          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyDashboardPage(title: 'Dashboard')));
                        },
                      ),
                    ],
                  ),
                ),
            ],
          )
        )
    );
  }

}