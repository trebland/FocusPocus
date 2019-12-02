import 'dart:convert';

import 'package:flutter/material.dart';

import 'dashboard.dart';
import 'package:http/http.dart' as http;
/*
Future<Post> fetchPost() async {
  var response = await http.post(url, body: {'name': 'doodle', 'color': 'blue'});

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class Post {
  final String email;
  final String firstName;
  final String lastName;
  final List<String> roles;

  Post({this.email, this.firstName, this.lastName, this.roles});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      roles: json['roles'].cast<String>(),
    );
  }
}
*/
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
