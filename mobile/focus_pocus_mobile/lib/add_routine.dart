import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class MyAddRoutinePage extends StatefulWidget {
  MyAddRoutinePage({Key key, this.title, this.token}) : super(key: key);

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
  _MyAddRoutineState createState() => _MyAddRoutineState();
}

class _MyAddRoutineState extends State<MyAddRoutinePage> with SingleTickerProviderStateMixin {

  Future<Post> fetchPost(String token, String routineName, bool coffeeNap,
      int pomTimer, int breakTimer, int pomCount, int breakCount,
      int largeBreakCount, bool goalHit) async {
    var mUrl = "http://54.221.121.199/createRoutine";
    // {'username': '$username', 'email': '$email', 'password': '$password'}
    var body = json.encode({
      "token": '$token',
      "routineName": '$routineName',
      "coffeeNap": '$coffeeNap',
      "pomTimer": '$pomTimer',
      "breakTimer": '$breakTimer',
      "pomCount": '$pomCount',
      "breakCount": '$breakCount',
      "largeBreakCount": '$largeBreakCount',
      "goalHit": '$goalHit',
    });

    var response = await http.post(mUrl,
        body: body,
        headers: {'Content-type': 'application/json'});

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      Post mPost = Post.fromJson(json.decode(response.body));

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

  @override
  void initState() {
    super.initState();
    _focusController.text = "25";
    _shortBreakController.text = "5";
    _longBreakController.text = "10";
    _goalController.text = "3";
  }

  final _nameController = TextEditingController();
  final _focusController = TextEditingController();
  final _shortBreakController = TextEditingController();
  final _longBreakController = TextEditingController();
  final _goalController = TextEditingController();

  FocusNode pomNode = new FocusNode();
  FocusNode breakNode = new FocusNode();
  FocusNode largeBreakNode = new FocusNode();
  FocusNode goalNode = new FocusNode();

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
                        onSubmitted: (String value) {
                          FocusScope.of(context).requestFocus(pomNode);
                        },
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
                        onSubmitted: (String value) {
                          FocusScope.of(context).requestFocus(breakNode);
                        },
                        focusNode: pomNode,
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
                        onSubmitted: (String value) {
                          FocusScope.of(context).requestFocus(largeBreakNode);
                        },
                        focusNode: breakNode,
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
                        onSubmitted: (String value) {
                          FocusScope.of(context).requestFocus(goalNode);
                        },
                        focusNode: largeBreakNode,
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
                        focusNode: goalNode,
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
                          child: Text('ADD ROUTINE'),
                          onPressed: () {
                            //String token, String routineName, bool coffeeNap,
                            //      int pomTimer, int breakTimer, int pomCount, int breakCount,
                            //      int largeBreakCount, bool goalHit
                            fetchPost(widget.token, _nameController.text, false,
                                int.parse(_focusController.text), int.parse(_shortBreakController.text), 0, int.parse(_longBreakController.text), int.parse(_goalController.text), false);
                            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyDashboardPage(title: 'Dashboard')));
                          },
                        ),
                      ],
                    ),
                  ),
                ]
            )
        )
    );
  }

}