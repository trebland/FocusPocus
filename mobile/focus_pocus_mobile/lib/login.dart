import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:focus_pocus_mobile/forgot_password.dart';
import 'package:focus_pocus_mobile/register_account.dart';

import 'dashboard.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(title: 'Focus Pocus -- Login'),
    );
  }
}
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
class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

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
                      controller: _usernameController,
                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'Username',
                      ),
                    ),
                    padding: EdgeInsets.only(left: 5),
                    margin: EdgeInsets.all(20),
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
                    child: Column(
                      children: <Widget>[
                        Builder(
                            builder: (context) => Center(
                                child: FlatButton(
                                  child: const Text('Forgot Password?'),
                                  onPressed: ()
                                  {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => MyForgotPasswordPage(title: "Reset Password",)),
                                    );
                                  },
                                )
                            )
                        ),
                        Text(
                            "OR"
                        ),
                        Builder(
                            builder: (context) => Center(
                                child: FlatButton(
                                  child: const Text('Register Account'),
                                  onPressed: ()
                                  {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => MyRegisterAccountPage(title: "Register Account",)),
                                    );
                                  },
                                )
                            )
                        )
                      ],
                    ),
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
                    _usernameController.clear();
                    _passwordController.clear();
                  },
                ),
                RaisedButton(
                  child: Text('LOGIN'),
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
