import 'package:hive/hive.dart';

part 'app_limit_model.g.dart';

@HiveType(typeId: 7)
class AppLimit extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String appName;
  @HiveField(2)
  int usedMinutes;
  @HiveField(3)
  int limitMinutes;
  @HiveField(4)
  final int colorHex;

  AppLimit({
    required this.id,
    required this.appName,
    required this.usedMinutes,
    required this.limitMinutes,
    required this.colorHex,
  });
}
