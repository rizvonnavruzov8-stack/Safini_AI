import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 3)
enum TransactionType {
  @HiveField(0)
  earn,
  @HiveField(1)
  spend
}

@HiveType(typeId: 4)
class Transaction extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final int amount;
  @HiveField(2)
  final TransactionType type;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final String description;

  Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.date,
    required this.description,
  });
}
