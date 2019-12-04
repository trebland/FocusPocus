import 'dart:convert';
import 'package:flutter/material.dart';

import 'dashboard.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;



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

class MyRegisterAccountPage extends StatefulWidget {
  MyRegisterAccountPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyRegisterAccountState createState() => _MyRegisterAccountState();
}

class _MyRegisterAccountState extends State<MyRegisterAccountPage> with SingleTickerProviderStateMixin {

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

      Navigator.pop(context);
      return mPost;
    } else {
      // If that call was not successful, throw an error.
      Post mPost = Post.fromJson(json.decode(response.body));

      Fluttertoast.showToast(
          msg: mPost.message.contains("User validation failed: ") ? "Email or Username is already in use." : mPost.message,
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

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
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
              Container(
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Username',
                  ),
                ),
                padding: EdgeInsets.only(left: 5),
                margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
              ),
              Container(
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Password',
                  ),
                  obscureText: true,
                ),
                padding: EdgeInsets.only(left: 5),
                margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
              ),
              Container(
                child: TextField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Confirm Password',
                  ),
                  obscureText: true,
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
                        _emailController.clear();
                        _usernameController.clear();
                        _passwordController.clear();
                        _confirmPasswordController.clear();
                      },
                    ),
                    RaisedButton(
                      child: Text('REGISTER'),
                      onPressed: () {
                        if (!_emailController.text.contains("@") || !_emailController.text.contains(".com"))
                          Fluttertoast.showToast(
                              msg: "Invalid email format.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIos: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        else if (_passwordController.text.compareTo(_confirmPasswordController.text) != 0)
                          Fluttertoast.showToast(
                            msg: "Passwords do not match.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIos: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0
                          );
                        else
                          fetchPost(_usernameController.text, _emailController.text, _passwordController.text);
                        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyDashboardPage(title: 'Dashboard')));
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
