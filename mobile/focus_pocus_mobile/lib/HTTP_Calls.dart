import 'dart:convert';
import 'package:http/http.dart' as http;

/*
class MyAddRoutinePage_Test  extends StatelessWidget {
  MyAddRoutinePage_Test({Key key, this.title, this.token}) : super(key: key);

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
  Widget build(BuildContext context) {
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

        Fluttertoast.showToast(
            msg: mPost.message,
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
  }
}
*/


class LoginPost {
  final String username;
  final String token;
  final String message;

  LoginPost({this.username, this.token, this.message});

  factory LoginPost.fromJson(Map<String, dynamic> json) {
    return LoginPost(
      username: json['username'],
      token: json['token'],
      message: json['message'],
    );
  }
}

class MyLogin_Test {

  RegisterAccountPost _post;

  MyLogin_Test()
  {
    _post = null;
  }

  Future<LoginPost> fetchPost(String username, String password) async {
    var mUrl = "http://54.221.121.199/loginUser";

    var body = json.encode({
      "username": '$username',
      "password": '$password'
    });

    var response = await http.post(mUrl,
        body: body,
        headers: {'Content-type': 'application/json'});

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      LoginPost mPost = LoginPost.fromJson(json.decode(response.body));

      return mPost;
    } else {
      // If that call was not successful, throw an error.
      LoginPost mPost = LoginPost.fromJson(json.decode(response.body));

      return null;
    }
  }
}

class RegisterAccountPost {
  final String username;
  final String message;

  RegisterAccountPost({this.username, this.message});

  factory RegisterAccountPost.fromJson(Map<String, dynamic> json) {
    return RegisterAccountPost(
      username: json['username'],
      message: json['message'],
    );
  }
}

class MyRegisterAccount_Test {

  RegisterAccountPost _post;

  MyRegisterAccount_Test()
  {
    _post = null;
  }

  Future<RegisterAccountPost> fetchPost(String username, String email, String password) async {
    var mUrl = "http://54.221.121.199/registerUser";

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
      RegisterAccountPost mPost = RegisterAccountPost.fromJson(json.decode(response.body));

      return mPost;
    } else {
      return null;
    }
  }
}