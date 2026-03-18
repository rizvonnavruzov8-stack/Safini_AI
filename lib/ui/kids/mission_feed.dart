import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/task_model.dart';
import '../../providers/state_providers.dart';
import '../../core/app_theme.dart';


class MissionFeed extends ConsumerWidget {
  const MissionFeed({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Missions'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: tasks.isEmpty
          ? const Center(child: Text('No missions today! Check back later.'))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return _buildTaskCard(context, ref, task);
              },
            ),
    );
  }

  Widget _buildTaskCard(BuildContext context, WidgetRef ref, SafiniTask task) {
    final isCompleted = task.isCompleted;
    final isApproved = task.isApproved;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isApproved ? Colors.green.shade100 : Colors.grey.shade200,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getCategoryColor(task.category).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(_getCategoryIcon(task.category), color: _getCategoryColor(task.category)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  task.description,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '+${task.coins}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFB8860B)),
                ),
              ),
              const SizedBox(height: 8),
              if (isApproved)
                const Icon(Icons.check_circle, color: Colors.green)
              else if (isCompleted)
                const Text('Pending', style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold))
              else
                ElevatedButton(
                  onPressed: () => _showCompletionDialog(context, ref, task),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    minimumSize: const Size(0, 30),
                  ),
                  child: const Text('Do it'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCompletionDialog(BuildContext context, WidgetRef ref, SafiniTask task) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('Finish ${task.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Great job! Tell your parent what you did or how it went.', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'e.g. I finished levels 1-3 in Duolingo!',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[500]?.withOpacity(0.05),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Maybe Later')),
          ElevatedButton(
            onPressed: () {
              ref.read(taskListProvider.notifier).completeTask(task.id, controller.text.isEmpty ? 'Task completed' : controller.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Request sent to Parent! 🚀'),
                  backgroundColor: AppTheme.primaryColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Send Request'),
          ),
        ],
      ),
    );
  }


  Color _getCategoryColor(TaskCategory cat) {
    switch (cat) {
      case TaskCategory.language: return Colors.blue;
      case TaskCategory.movement: return Colors.orange;
      case TaskCategory.brain: return Colors.purple;
      case TaskCategory.realWorld: return Colors.green;
      case TaskCategory.social: return Colors.pink;
    }
  }

  IconData _getCategoryIcon(TaskCategory cat) {
    switch (cat) {
      case TaskCategory.language: return FontAwesomeIcons.language;
      case TaskCategory.movement: return FontAwesomeIcons.personRunning;
      case TaskCategory.brain: return FontAwesomeIcons.brain;
      case TaskCategory.realWorld: return FontAwesomeIcons.house;
      case TaskCategory.social: return FontAwesomeIcons.users;
    }
  }
}
