import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_model.dart';
import '../models/reward_model.dart';
import '../models/transaction_model.dart';

class StorageService {
  static const String taskBoxName = 'tasks';
  static const String rewardBoxName = 'rewards';
  static const String transactionBoxName = 'transactions';
  static const String settingsBoxName = 'settings';

  Future<void> init() async {
    await Hive.initFlutter();
    
    // Register Adapters
    Hive.registerAdapter(TaskCategoryAdapter());
    Hive.registerAdapter(SafiniTaskAdapter());
    Hive.registerAdapter(RewardAdapter());
    Hive.registerAdapter(TransactionTypeAdapter());
    Hive.registerAdapter(TransactionAdapter());

    // Open Boxes
    await Hive.openBox<SafiniTask>(taskBoxName);
    await Hive.openBox<Reward>(rewardBoxName);
    await Hive.openBox<Transaction>(transactionBoxName);
    await Hive.openBox(settingsBoxName);

    // Add default tasks if empty
    final taskBox = Hive.box<SafiniTask>(taskBoxName);
    if (taskBox.isEmpty) {
      await _seedData();
    }
  }

  Future<void> _seedData() async {
    final taskBox = Hive.box<SafiniTask>(taskBoxName);
    final rewardBox = Hive.box<Reward>(rewardBoxName);

    await taskBox.addAll([
      SafiniTask(
        id: '1',
        title: 'Duolingo Streak',
        description: 'Complete one lesson in Duolingo.',
        category: TaskCategory.language,
        coins: 10,
      ),
      SafiniTask(
        id: '2',
        title: 'Daily Steps',
        description: 'Reach 5,000 steps today.',
        category: TaskCategory.movement,
        coins: 15,
      ),
      SafiniTask(
        id: '3',
        title: 'Logic Master',
        description: 'Solve 3 logic puzzles.',
        category: TaskCategory.brain,
        coins: 20,
      ),
    ]);

    await rewardBox.addAll([
      Reward(
        id: 'r1',
        title: 'Roblox Time',
        description: '30 minutes of Roblox play.',
        cost: 30,
        durationMinutes: 30,
      ),
      Reward(
        id: 'r2',
        title: 'YouTube Break',
        description: '15 minutes of YouTube.',
        cost: 15,
        durationMinutes: 15,
      ),
    ]);
  }

  Box<SafiniTask> getTaskBox() => Hive.box<SafiniTask>(taskBoxName);
  Box<Reward> getRewardBox() => Hive.box<Reward>(rewardBoxName);
  Box<Transaction> getTransactionBox() => Hive.box<Transaction>(transactionBoxName);
  Box getSettingsBox() => Hive.box(settingsBoxName);
}
