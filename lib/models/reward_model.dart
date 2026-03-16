import 'package:hive/hive.dart';

part 'reward_model.g.dart';

@HiveType(typeId: 2)
class Reward extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final int cost;
  @HiveField(4)
  final int durationMinutes;

  Reward({
    required this.id,
    required this.title,
    required this.description,
    required this.cost,
    required this.durationMinutes,
  });
}
