import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dashboard.dart';
import 'package:http/http.dart' as http;

Future<Post> fetchPost(String username, String email, String password) async {
  var mUrl = "http://54.221.121.199/registerUser";
  // {'username': '$username', 'email': '$email', 'password': '$password'}
  var body = json.encode({
    "username": '$username',
    "email": '$email',
    "password": '$password'
  });

  var response = await http.post(mUrl,
      body: body,
      headers: {'Content-type': 'application/json'});

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    Post mPost = Post.fromJson(json.decode(response.body));

    Fluttertoast.showToast(
        msg: mPost.username,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );

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

class Post {
  final String username;
  final String message;

  Post({this.username, this.message});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      username: json['username'],
      message: json['message'],
    );
  }
}


class MyForgotPasswordPage extends StatefulWidget {
  MyForgotPasswordPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyForgotPasswordState createState() => _MyForgotPasswordState();
}

class _MyForgotPasswordState extends State<MyForgotPasswordPage> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  final _emailController = TextEditingController();

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
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          filled: true,
                          labelText: 'Email',
                        ),
                      ),
                      padding: EdgeInsets.only(left: 5),
                      margin: EdgeInsets.all(20),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: Text('CLEAR'),
                    onPressed: () {
                      _emailController.clear();
                    },
                  ),
                  RaisedButton(
                    child: Text('RESET PASSWORD'),
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyDashboardPage(title: 'Dashboard')));
                    },
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }

}
