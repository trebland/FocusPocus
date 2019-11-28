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
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Pomodoro Routines'),
    Tab(text: 'Power-Napper'),
    Tab(text: 'Intake Tracker'),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
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