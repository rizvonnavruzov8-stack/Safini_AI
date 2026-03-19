import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
enum TaskCategory {
  @HiveField(0)
  language,
  @HiveField(1)
  movement,
  @HiveField(2)
  brain,
  @HiveField(3)
  realWorld,
  @HiveField(4)
  social
}

@HiveType(typeId: 1)
class SafiniTask extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final TaskCategory category;
  @HiveField(4)
  final int coins;
  @HiveField(5)
  bool isCompleted;
  @HiveField(6)
  bool isApproved;
  @HiveField(8)
  bool isRejected;

  SafiniTask({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.coins,
    this.isCompleted = false,
    this.isApproved = false,
    this.isRejected = false,
    @HiveField(7)
    this.proof,
  });
}
