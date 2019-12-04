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

  Routine ({this.routineId, this.routineName, this.coffeeNap, this.napTimer, this.pomTimer, this.breakTimer, this.pomCount, this.breakCount, this.largeBreakCount, this.goalHit});

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      routineId: json['routineId'],
      routineName: json['routineName'],
      coffeeNap: json['coffeeNap'],
      napTimer: json['napTimer'],
      pomTimer: json['pomTimer'],
      breakTimer: json['breakTimer'],
      pomCount: json['pomCount'],
      breakCount: json['breakCount'],
      largeBreakCount: json['largeBreakCount'],
      goalHit: json['goalHit'],
    );
  }
}