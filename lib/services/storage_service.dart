import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_model.dart';
import '../models/reward_model.dart';
import '../models/transaction_model.dart';
import '../models/avatar_model.dart';
import '../models/app_limit_model.dart';

class StorageService {
  static const String taskBoxName = 'tasks';
  static const String rewardBoxName = 'rewards';
  static const String transactionBoxName = 'transactions';
  static const String settingsBoxName = 'settings';
  static const String avatarBoxName = 'avatars';
  static const String appLimitBoxName = 'appLimits';

  Future<void> init() async {
    await Hive.initFlutter();
    
    // Register Adapters
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(TaskCategoryAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(SafiniTaskAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(RewardAdapter());
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(TransactionTypeAdapter());
    if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(TransactionAdapter());
    if (!Hive.isAdapterRegistered(5)) Hive.registerAdapter(AvatarCategoryAdapter());
    if (!Hive.isAdapterRegistered(6)) Hive.registerAdapter(AvatarItemAdapter());
    if (!Hive.isAdapterRegistered(7)) Hive.registerAdapter(AppLimitAdapter());

    // Open Boxes
    await Hive.openBox<SafiniTask>(taskBoxName);
    await Hive.openBox<Reward>(rewardBoxName);
    await Hive.openBox<Transaction>(transactionBoxName);
    await Hive.openBox(settingsBoxName);
    await Hive.openBox<AvatarItem>(avatarBoxName);
    await Hive.openBox<AppLimit>(appLimitBoxName);

    // Seed data if empty
    if (Hive.box<SafiniTask>(taskBoxName).isEmpty) {
      await _seedTasks();
    }
    if (Hive.box<Reward>(rewardBoxName).isEmpty) {
      await _seedRewards();
    }
    if (Hive.box<AvatarItem>(avatarBoxName).isEmpty) {
      await _seedAvatars();
    }
    if (Hive.box<AppLimit>(appLimitBoxName).isEmpty) {
      await _seedAppLimits();
    }
  }

  Future<void> _seedTasks() async {
    final taskBox = Hive.box<SafiniTask>(taskBoxName);
    await taskBox.addAll([
      SafiniTask(id: '1', title: 'Complete Duolingo', description: 'Daily streak bonus!', category: TaskCategory.language, coins: 20),
      SafiniTask(id: '2', title: 'Walk 5,000 Steps', description: 'Keep it moving!', category: TaskCategory.movement, coins: 10),
      SafiniTask(id: '3', title: 'Logical Puzzle', description: 'Brain power boost', category: TaskCategory.brain, coins: 15),
      SafiniTask(id: '4', title: 'Chess Lesson', description: 'Master the board', category: TaskCategory.brain, coins: 25),
    ]);
  }

  Future<void> _seedRewards() async {
    final rewardBox = Hive.box<Reward>(rewardBoxName);
    await rewardBox.addAll([
      Reward(id: 'r1', title: 'YouTube Kids', description: '+30 Minutes', cost: 100, durationMinutes: 30),
      Reward(id: 'r2', title: 'Roblox', description: '+20 Minutes', cost: 150, durationMinutes: 20),
      Reward(id: 'r3', title: 'Brawl Stars', description: '+15 Minutes', cost: 80, durationMinutes: 15),
      Reward(id: 'r4', title: 'Minecraft', description: '+45 Minutes', cost: 200, durationMinutes: 45),
    ]);
  }


  Future<void> _seedAvatars() async {
    final avatarBox = Hive.box<AvatarItem>(avatarBoxName);
    await avatarBox.addAll([
      AvatarItem(id: 'a1', name: 'Blue Cape', cost: 0, category: AvatarCategory.outfit, iconPath: 'apparel', isOwned: true),
      AvatarItem(id: 'a2', name: 'Golden Armor', cost: 450, category: AvatarCategory.outfit, iconPath: 'shield'),
      AvatarItem(id: 'a3', name: 'Pink Suit', cost: 300, category: AvatarCategory.outfit, iconPath: 'rocket_launch'),
    ]);
  }

  Future<void> _seedAppLimits() async {
    final appLimitBox = Hive.box<AppLimit>(appLimitBoxName);
    await appLimitBox.addAll([
      AppLimit(id: 'app1', appName: 'YouTube Kids', usedMinutes: 0, limitMinutes: 60, colorHex: 0xFFF44336), // Red
      AppLimit(id: 'app2', appName: 'Roblox', usedMinutes: 0, limitMinutes: 60, colorHex: 0xFF2196F3), // Blue
    ]);
  }

  Box<SafiniTask> getTaskBox() => Hive.box<SafiniTask>(taskBoxName);
  Box<Reward> getRewardBox() => Hive.box<Reward>(rewardBoxName);
  Box<Transaction> getTransactionBox() => Hive.box<Transaction>(transactionBoxName);
  Box<AvatarItem> getAvatarBox() => Hive.box<AvatarItem>(avatarBoxName);
  Box<AppLimit> getAppLimitBox() => Hive.box<AppLimit>(appLimitBoxName);
  Box getSettingsBox() => Hive.box(settingsBoxName);
}
