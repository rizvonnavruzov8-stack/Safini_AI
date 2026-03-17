import 'package:hive/hive.dart';

part 'avatar_model.g.dart';

@HiveType(typeId: 5)
enum AvatarCategory { outfit, face, hair, back, effects }

@HiveType(typeId: 6)
class AvatarItem extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final int cost;
  @HiveField(3)
  final AvatarCategory category;
  @HiveField(4)
  final String iconPath;
  @HiveField(5)
  bool isOwned;

  AvatarItem({
    required this.id,
    required this.name,
    required this.cost,
    required this.category,
    required this.iconPath,
    this.isOwned = false,
  });
}