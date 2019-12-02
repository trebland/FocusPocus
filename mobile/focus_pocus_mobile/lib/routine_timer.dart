import 'dart:async';

import 'package:flutter/material.dart';

void handleTimerEnd ()
{

}

class MyRoutineTimerPage extends StatefulWidget {
  MyRoutineTimerPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyRoutineTimerState createState() => _MyRoutineTimerState();
}

class _MyRoutineTimerState extends State<MyRoutineTimerPage>
{
  Duration timeStandard = new Duration(minutes: 25);
  Duration timeRemaining;

  String timerStartPauseText = "";
  String startTimer = "Start";
  String pauseTimer = "Pause";
  bool isRunning = false;

  DateTime targetTime;
  String timeLeft = "";

  @override
  void initState() {
    super.initState();
    timerStartPauseText = startTimer;
    timeLeft = timeStandard.inMinutes.toString() + ":" + (timeStandard.inSeconds % 60).toString().padLeft(2,'0');
    timeRemaining = null;
  }

  Future<void> executeTimer() async {
    while (isRunning) {
      setState(() {
        if (DateTime.now().isAfter(targetTime))
        {
          timeLeft = "Timer Over";
          isRunning = false;
        }
        else{
          Duration timeRemaining = targetTime.difference(DateTime.now());
          timeLeft = timeRemaining.inMinutes.toString() + ":" + (timeRemaining.inSeconds % 60).toString().padLeft(2,'0');
        }
      });
      await Future.delayed(Duration(seconds: 1), () {});
    }
  }

  Future<void> mStartTimer() async
  {

  }

  Future<void> mStopTimer() async
  {

  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      resizeToAvoidBottomPadding: false,
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
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
                          if (targetTime == null || DateTime.now().isAfter(targetTime)) {
                            if (timeRemaining != null)
                              targetTime = DateTime.now().add(timeRemaining);
                            else
                              targetTime = DateTime.now().add(timeStandard);
                          }

                          isRunning = true;
                          timerStartPauseText = pauseTimer;
                          executeTimer();
                        }
                        else
                        {
                          isRunning = false;
                          timerStartPauseText = startTimer;
                          timeRemaining = targetTime.difference(DateTime.now());
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
        ),
      ),
    );
  }
}