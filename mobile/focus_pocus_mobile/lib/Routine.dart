class Routine {
  final String routineId;
  // String userId;
  final String routineName;
  final bool coffeeNap;
  final int napTimer;
  final int pomTimer;
  final int breakTimer;
  int pomCount;
  final int breakCount;
  final int largeBreakCount;
  final bool goalHit;
  List<Choice> choices;

  Routine ({this.routineId, this.routineName, this.coffeeNap, this.napTimer, this.pomTimer, this.breakTimer, this.pomCount, this.breakCount, this.largeBreakCount, this.goalHit, this.choices});

  factory Routine.fromJson(Map<String, dynamic> json) {
    Routine routine = new Routine(
      routineId: json['_id'],
      routineName: json['routineName'],
      coffeeNap: json['coffeeNap'],
      napTimer: json['napTimer'],
      pomTimer: json['pomTimer'],
      breakTimer: json['breakTimer'],
      pomCount: json['pomCount'],
      breakCount: json['breakCount'],
      largeBreakCount: json['largeBreakCount'],
      goalHit: json['goalHit'],
      choices: null,
    );

    List<Choice> tChoices = new List<Choice>();
    tChoices.add(new Choice("Edit Routine", routine));
    tChoices.add(new Choice("Delete Routine", routine));

    return Routine(
      routineId: json['_id'],
      routineName: json['routineName'],
      coffeeNap: json['coffeeNap'],
      napTimer: json['napTimer'],
      pomTimer: json['pomTimer'],
      breakTimer: json['breakTimer'],
      pomCount: json['pomCount'],
      breakCount: json['breakCount'],
      largeBreakCount: json['largeBreakCount'],
      goalHit: json['goalHit'],
      choices: tChoices,
    );
  }
}

class Choice {

  String title;
  Routine routine;

  Choice (String title, Routine routine)
  {
    this.title = title;
    this.routine = routine;
  }
}