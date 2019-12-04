import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Routine.dart';
import 'package:vibrate/vibrate.dart';

void handleTimerEnd ()
{

}

class MyRoutineTimerPage extends StatefulWidget {
  MyRoutineTimerPage({Key key, this.title, this.routine}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final Routine routine;

  @override
  _MyRoutineTimerState createState() => _MyRoutineTimerState();
}

class _MyRoutineTimerState extends State<MyRoutineTimerPage> with SingleTickerProviderStateMixin
{
  String timerType = "";
  String focusTimer = "Focus";
  String shortBreakTimer = "Short Break";
  String longBreakTimer = "Long Break";
  bool canVibrate;

  String timerStartPauseText = "";
  String startTimer = "Start";
  String pauseTimer = "Pause";
  bool isRunning;

  DateTime targetTime;
  Duration timeRemaining;
  String timeLeft = "";

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    mCanVibrate();
    isRunning = false;
    timerType = focusTimer;
    timerStartPauseText = startTimer;
    timeRemaining = new Duration(minutes: widget.routine.pomTimer);
    timeLeft = timeRemaining.inMinutes.toString() + ":" + (timeRemaining.inSeconds % 60).toString().padLeft(2,'0');
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void changeTab() {
    setState(() {
      _tabController.animateTo(1 % _tabController.length);
    });
  }

  Future<void> mCanVibrate() async
  {
    canVibrate = await Vibrate.canVibrate;
  }

  Future<void> mStartTimer() async
  {
    isRunning = true;
    targetTime = DateTime.now().add(timeRemaining);
    changeTab();

    while (isRunning) {
      setState(() {
        if (targetTime.difference(DateTime.now()).compareTo(new Duration(seconds: 0, milliseconds: 999)) <= 0)
        {
          // We will add what may seem like an erroneous second,
          // .. but this is to account for the second it takes to re-loop and
          // .. prevents us from having an awkward jump from 1:00 to 0:58
          switch (timerType)
          {
            case "Focus":
              widget.routine.pomCount++;

              // Long Break
              if (widget.routine.pomCount % 2 == 0)
              {
                timerType = longBreakTimer;
              }
              else
              {
                timerType = shortBreakTimer;
                timeRemaining = new Duration(minutes: (widget.routine.breakTimer));
              }
              break;
            case "Short Break":
              timerType = focusTimer;
              timeRemaining = new Duration(minutes: (widget.routine.pomTimer));
              break;
            case "Long Break":
              timerType = focusTimer;
              timeRemaining = new Duration(minutes: (widget.routine.pomTimer));
              break;
          }
          if(canVibrate)
            Vibrate.vibrate();
        }
        else{
          timerStartPauseText = pauseTimer;
          timeRemaining = targetTime.difference(DateTime.now());
          timeLeft = timeRemaining.inMinutes.toString() + ":" + (timeRemaining.inSeconds % 60).toString().padLeft(2,'0');
        }
      });
      if (targetTime.difference(DateTime.now()).compareTo(new Duration(seconds: 0, milliseconds: 999)) <= 0){
        isRunning = false;
        mStartTimer();
      }
      else
        await Future.delayed(Duration(seconds: 1), () {});
    }
  }

  Future<void> mPauseTimer() async
  {
    setState(() {
      isRunning = false;
      timerStartPauseText = startTimer;
      timeRemaining = targetTime.difference(DateTime.now());
      timeLeft = timeRemaining.inMinutes.toString() + ":" + (timeRemaining.inSeconds % 60).toString().padLeft(2,'0');
    });
  }

  Future<void> mResetTimer() async
  {
    setState(() {
      isRunning = false;
      widget.routine.pomCount = 0;
      timerType = focusTimer;
      timerStartPauseText = startTimer;
      timeRemaining = new Duration(minutes: widget.routine.pomTimer);
      timeLeft = timeRemaining.inMinutes.toString() + ":" + (timeRemaining.inSeconds % 60).toString().padLeft(2,'0');
    });
  }

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Routine Preview'),
    Tab(text: 'Current Timer'),
  ];

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
        bottom: TabBar(
          controller: _tabController,
          tabs: myTabs,
        ),
      ),
      resizeToAvoidBottomPadding: false,
      body: TabBarView (
        controller: _tabController,
        children: myTabs.map((Tab tab)
          {
            if (tab.text == "Routine Preview")
              {
                return Center(
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
                                                    enabled: false,
                                                    decoration: new InputDecoration(
                                                      hintText: "Focus Timer: " + widget.routine.pomTimer.toString(),
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
                                                    enabled: false,
                                                    decoration: new InputDecoration(
                                                      hintText: "Short Break Timer: " + widget.routine.breakTimer.toString(),
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
                                                    enabled: false,
                                                    decoration: new InputDecoration(
                                                      hintText: "Long Break Timer: " + (widget.routine.breakTimer*2).toString(),
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
                                                    enabled: false,
                                                    decoration: new InputDecoration(
                                                      hintText: "Goal Hit: " + widget.routine.goalHit.toString(),
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
                                    mStartTimer();
                                  }
                                  else
                                  {
                                    mPauseTimer();
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
                                  mResetTimer();
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
                );
              }
            else {
              return Center (
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text (
                        '$timerType',
                        style: TextStyle(fontSize: 30, color: Colors.black),),
                      Text (
                        '$timeLeft',
                        style: TextStyle(fontSize: 30, color: Colors.black)),
                    ],
                  )
                ),
              );
            }
          }
        ).toList(),
      )
    );
  }
}