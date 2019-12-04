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

class MyDeleteRoutinePage extends StatefulWidget {
  MyDeleteRoutinePage({Key key, this.title, this.token, this.routine}) : super(key: key);

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
  _MyDeleteRoutineState createState() => _MyDeleteRoutineState();
}

class _MyDeleteRoutineState extends State<MyDeleteRoutinePage> with SingleTickerProviderStateMixin {

  Future<Post> fetchPost(String token, String routineId) async {

    var mUrl = "http://54.221.121.199/deleteRoutine";

    var body = json.encode({
      "token": '$token',
      "routineId": '$routineId',
    });

    var response = await http.post(mUrl,
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

  @override
  void initState() {
    super.initState();
  }

  final _nameController = TextEditingController();
  final _focusController = TextEditingController();
  final _shortBreakController = TextEditingController();
  final _longBreakController = TextEditingController();
  final _goalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Image.asset('assets/fp_logo_small.png'),
                    Text('Focus Pocus'),
                    Container(
                      child: Text(
                        "Do you wish to delete this routine?",
                        style: TextStyle(fontSize: 30, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      padding: EdgeInsets.only(left: 5),
                      margin: EdgeInsets.all(20),
                    ),
                    Container(
                      child: RaisedButton(
                        child: Text('DELETE ROUTINE'),
                        onPressed: () {
                          //String token, String routineName, bool coffeeNap,
                          //      int pomTimer, int breakTimer, int pomCount, int breakCount,
                          //      int largeBreakCount, bool goalHit
                          // fetchPost(widget.token, _nameController.text, false, int.parse(_focusController.text), int.parse(_shortBreakController.text), 0, 0, 0, false);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }

}