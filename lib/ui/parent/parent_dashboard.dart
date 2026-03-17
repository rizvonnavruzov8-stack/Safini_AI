import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/state_providers.dart';
import '../../core/app_theme.dart';
import 'approval_queue.dart';
import 'task_creator.dart';

class ParentDashboard extends ConsumerWidget {
  const ParentDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskListProvider);
    final balance = ref.watch(coinBalanceProvider);
    final pendingApprovals = tasks.where((t) => t.isCompleted && !t.isApproved).length;

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () => ref.read(appModeProvider.notifier).state = AppMode.kids,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildChildProfile(context, balance),
            _buildStatsGrid(),
            _buildScreenTimeChart(context),
            _buildAppLimits(context),
            if (pendingApprovals > 0) _buildApprovalAlert(context, pendingApprovals),
            _buildRealWorldTasks(context, tasks),
            const SizedBox(height: 30),
          ],
        ),
      ),
      // Bottom Nav Mockup from UI
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildChildProfile(BuildContext context, int balance) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2), width: 4),
              image: const DecorationImage(
                image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuCTQDXst8akwkrfwYKSSfcANDHttEaNPofNNX4N-aZQ59C9OVSOKHNhl6VCbwOGrC2H1fgke4mJNH2_7rC__r08LE_fC0Xk4Pon7gvjt2kWGc4OBB-RJStcdk2BumYIjsxCcXnpaHLb6QBFl23t8I_QNhSe5nO7uX1T6zUk1ZtqtaAI5yFAQyIUIg45wtayfcG1r0YM44SnUKCGiUGywmjWMm92LS1EC4uEpKtABsBXRiiHGmMr1VmYjSHLKZ0mm_5lIfcsJ8K0h1BC"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Alex's Progress", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Text("Level 12 Explorer", style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w600)),
              Row(
                children: [
                  const Icon(Icons.monetization_on, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text("$balance Time Coins", style: const TextStyle(color: AppTheme.slate500, fontSize: 14)),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildStatCard("Steps", "4,230", "+12% vs yesterday", Icons.directions_run),
          const SizedBox(width: 12),
          _buildStatCard("Lessons", "5/8", "+2 today", Icons.school),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String sub, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppTheme.primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(title.toUpperCase(), style: const TextStyle(fontSize: 10, color: AppTheme.slate500, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(sub, style: const TextStyle(color: AppTheme.emerald600, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildScreenTimeChart(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Weekly Screen Time", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBar(0.4), _buildBar(0.6), _buildBar(0.3), _buildBar(0.8),
                _buildBar(0.95, isPrimary: true), _buildBar(0.5), _buildBar(0.45),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(double heightFactor, {bool isPrimary = false}) {
    return Container(
      width: 35,
      height: 100 * heightFactor,
      decoration: BoxDecoration(
        color: isPrimary ? AppTheme.primaryColor : AppTheme.primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildAppLimits(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("App Limits", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(onPressed: () {}, child: const Text("Manage All")),
            ],
          ),
          _buildAppItem("YouTube Kids", 48, 60, Colors.red),
          const SizedBox(height: 12),
          _buildAppItem("Roblox", 15, 60, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildAppItem(String name, int current, int limit, Color color) {
    double progress = current / limit;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.slate100)),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.play_arrow, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                LinearProgressIndicator(value: progress, color: color, backgroundColor: AppTheme.slate100),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("$current / ${limit}m", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              Text("${limit - current}m left", style: const TextStyle(fontSize: 10, color: AppTheme.slate500)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildRealWorldTasks(BuildContext context, List tasks) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Real-world Tasks", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const TaskCreator())),
                icon: const Icon(Icons.add, size: 16),
                label: const Text("New Task", style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(minimumSize: const Size(0, 36), padding: const EdgeInsets.symmetric(horizontal: 12)),
              )
            ],
          ),
          const SizedBox(height: 12),
          ...tasks.map((task) => _buildTaskItem(task)).toList(),
        ],
      ),
    );
  }

  Widget _buildTaskItem(dynamic task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1))),
      child: Row(
        children: [
          const Icon(Icons.cleaning_services, color: AppTheme.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const Text("Daily Chore", style: TextStyle(fontSize: 12, color: AppTheme.slate500)),
            ]),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.amber.shade100, borderRadius: BorderRadius.circular(4)),
                child: Text("${task.coins} 🪙", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              const SizedBox(height: 4),
              Text(task.isApproved ? "Approved" : "Active", style: TextStyle(color: task.isApproved ? Colors.green : Colors.blue, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildApprovalAlert(BuildContext context, int count) {
     return Padding(
       padding: const EdgeInsets.symmetric(horizontal: 20),
       child: ListTile(
         tileColor: Colors.orange.shade50,
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
         leading: const Icon(Icons.notification_important, color: Colors.orange),
         title: Text("You have $count tasks to approve"),
         trailing: const Icon(Icons.chevron_right),
         onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ApprovalQueue())),
       ),
     );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppTheme.primaryColor,
      unselectedItemColor: AppTheme.slate500,
      currentIndex: 0,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Monitor"),
        BottomNavigationBarItem(icon: Icon(Icons.task_alt), label: "Tasks"),
        BottomNavigationBarItem(icon: Icon(Icons.phone_iphone), label: "Apps"),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Family"),
      ],
    );
  }
}