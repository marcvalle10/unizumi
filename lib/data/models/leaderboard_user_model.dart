class LeaderboardUserModel {
  final String id;
  final String name;
  final int score;
  final int wins;
  final double accuracy;
  final int rank;

  const LeaderboardUserModel({
    required this.id,
    required this.name,
    required this.score,
    required this.wins,
    required this.accuracy,
    required this.rank,
  });
}
