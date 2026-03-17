import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';
import '../models/reward_model.dart';
import '../models/transaction_model.dart';
import '../services/storage_service.dart';

enum AppMode { kids, parent }

final appModeProvider = StateProvider<AppMode>((ref) => AppMode.kids);

final storageServiceProvider = Provider((ref) => StorageService());

final taskListProvider = StateNotifierProvider<TaskListNotifier, List<SafiniTask>>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return TaskListNotifier(storage);
});

class TaskListNotifier extends StateNotifier<List<SafiniTask>> {
  final StorageService _storage;
  TaskListNotifier(this._storage) : super([]) {
    _loadTasks();
  }

  void _loadTasks() {
    state = _storage.getTaskBox().values.toList();
  }

  Future<void> addTask(SafiniTask task) async {
    await _storage.getTaskBox().add(task);
    _loadTasks();
  }

  Future<void> completeTask(String id, String proof) async {
    final task = state.firstWhere((t) => t.id == id);
    task.isCompleted = true;
    task.proof = proof;
    await task.save();
    _loadTasks();
  }

  Future<void> approveTask(String id) async {
    final task = state.firstWhere((t) => t.id == id);
    task.isApproved = true;
    await task.save();
    _loadTasks();
  }
}

final coinBalanceProvider = StateNotifierProvider<CoinBalanceNotifier, int>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return CoinBalanceNotifier(storage);
});

class CoinBalanceNotifier extends StateNotifier<int> {
  final StorageService _storage;
  CoinBalanceNotifier(this._storage) : super(0) {
    _calculateBalance();
  }

  void _calculateBalance() {
    int balance = 0;
    for (var tx in _storage.getTransactionBox().values) {
      if (tx.type == TransactionType.earn) {
        balance += tx.amount;
      } else {
        balance -= tx.amount;
      }
    }
    state = balance;
  }

  Future<void> addTransaction(Transaction tx) async {
    await _storage.getTransactionBox().add(tx);
    _calculateBalance();
  }
}

final xpProvider = StateProvider<int>((ref) => 1500); // Mocked XP

final levelProvider = Provider<int>((ref) {
  final xp = ref.watch(xpProvider);
  return (xp / 100).floor(); // Every 100 XP is a level
});

final progressToNextLevelProvider = Provider<double>((ref) {
  final xp = ref.watch(xpProvider);
  return (xp % 100) / 100.0; 
});