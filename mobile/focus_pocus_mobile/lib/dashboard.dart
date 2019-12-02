import 'package:flutter/material.dart';
import 'package:focus_pocus_mobile/routine_timer.dart';

class MyDashboardPage extends StatefulWidget {
  MyDashboardPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyDashboardState createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboardPage> with SingleTickerProviderStateMixin
{
  Duration timeStandard = new Duration(minutes: 25);
  Duration timeRemaining;

  String timerStartPauseText = "";
  String startTimer = "Start";
  String pauseTimer = "Pause";
  bool isRunning = false;

  DateTime targetTime;
  String timeLeft = "";

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Pomodoro Routines'),
    /*
    Tab(text: 'Power-Napper'),
    Tab(text: 'Intake Tracker'),*/
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    timerStartPauseText = startTimer;
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<String> routines = <String>['Study Calculus', 'Exercise', 'Play Games', 'Talk to Family', 'Check Emails', 'Remember the 80\'s'];
  final List<int> colorCodes = <int>[600, 500];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              color: Colors.white,
            ),
            onPressed: () {

            },
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: myTabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: myTabs.map((Tab tab) {
          if (tab.text == "Pomodoro Routines")
            return Center(
              child: ListView.builder(
                itemCount: routines.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: ListTile(
                      title: Text('${routines[index]}'),
                      trailing: Icon(Icons.more_vert),
                      onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MyRoutineTimerPage(title: '${routines[index]} Timer')));
                        },
                      dense: false,
                    ),
                    color: Colors.amber[colorCodes[index%2]],
                  );
                },
              ),
            );
          else if(tab.text == "Power-Napper")
            return Center(
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
                                isRunning = true;
                                timerStartPauseText = pauseTimer;
                                //executeTimer();
                              }
                              else
                              {
                                isRunning = false;
                                timerStartPauseText = startTimer;
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
              )
            );
          else
            return Center(
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: routines.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 50,
                    color: Colors.amber[colorCodes[index%2]],
                    child: Center(child: Text('Entry ${routines[index]}')),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(),
              ),
            );
        }).toList(),
      ),
    );
  }
}