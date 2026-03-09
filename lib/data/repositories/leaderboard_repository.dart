import '../models/leaderboard_user_model.dart';

class LeaderboardRepository {
  const LeaderboardRepository();

  List<LeaderboardUserModel> getLeaderboard() {
    return const [
      LeaderboardUserModel(
        id: 'u1',
        name: 'Ferxl',
        score: 9050,
        wins: 18,
        accuracy: 92.4,
        rank: 1,
      ),
      LeaderboardUserModel(
        id: 'u2',
        name: 'Nancy',
        score: 9420,
        wins: 16,
        accuracy: 89.1,
        rank: 2,
      ),
      LeaderboardUserModel(
        id: 'u3',
        name: 'Serrrto',
        score: 8990,
        wins: 14,
        accuracy: 87.8,
        rank: 3,
      ),
      LeaderboardUserModel(
        id: 'u4',
        name: 'Marcos',
        score: 8610,
        wins: 12,
        accuracy: 84.0,
        rank: 4,
      ),
      LeaderboardUserModel(
        id: 'u5',
        name: 'Cecilia',
        score: 8380,
        wins: 10,
        accuracy: 81.3,
        rank: 5,
      ),
      LeaderboardUserModel(
        id: 'u6',
        name: 'Joshua',
        score: 8150,
        wins: 9,
        accuracy: 79.2,
        rank: 6,
      ),
    ];
  }
}
