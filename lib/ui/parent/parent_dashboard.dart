import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/task_model.dart';
import '../../providers/state_providers.dart';
import 'approval_queue.dart';
import 'task_creator.dart';

class ParentDashboard extends ConsumerWidget {
  const ParentDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskListProvider);
    final pendingApprovals = tasks.where((t) => t.isCompleted && !t.isApproved).length;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(taskListProvider),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChildSummary(context),
            const SizedBox(height: 24),
            if (pendingApprovals > 0) _buildApprovalAlert(context, pendingApprovals),
            const SizedBox(height: 24),
            _buildQuickActions(context),
            const SizedBox(height: 32),
            Text('Child Activity', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildActivityList(context, tasks),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => ref.read(appModeProvider.notifier).state = AppMode.kids,
        label: const Text('Kids Mode'),
        icon: const Icon(Icons.face),
      ),
    );
  }

  Widget _buildChildSummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF6C63FF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Color(0xFF6C63FF), size: 40),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Child: Ilkhom Jr.',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Parent: Ilkhom S.',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalAlert(BuildContext context, int count) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.notification_important, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'You have $count tasks waiting for approval!',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ApprovalQueue())),
            child: const Text('Review'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            context,
            'Create Task',
            Icons.add_task,
            Colors.blue,
            () => Navigator.push(context, MaterialPageRoute(builder: (c) => const TaskCreator())),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionButton(
            context,
            'Reward Rules',
            Icons.rule,
            Colors.purple,
            () {},
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityList(BuildContext context, List tasks) {
    if (tasks.isEmpty) return const Center(child: Text('No tasks created yet.'));
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length > 5 ? 5 : tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          leading: Icon(_getCategoryIcon(task.category), color: Colors.grey),
          title: Text(task.title),
          subtitle: Text(task.isApproved ? 'Approved' : (task.isCompleted ? 'Pending Approval' : 'In Progress')),
          trailing: Text('${task.coins} pts'),
        );
      },
    );
  }

  IconData _getCategoryIcon(TaskCategory cat) {
    switch (cat) {
      case TaskCategory.language: return FontAwesomeIcons.language;
      case TaskCategory.movement: return FontAwesomeIcons.personRunning;
      case TaskCategory.brain: return FontAwesomeIcons.brain;
      case TaskCategory.realWorld: return FontAwesomeIcons.house;
      case TaskCategory.social: return FontAwesomeIcons.users;
      default: return Icons.task;
    }
  }
}
