import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/task_model.dart';
import '../../providers/state_providers.dart';

class TaskCreator extends ConsumerStatefulWidget {
  const TaskCreator({super.key});

  @override
  ConsumerState<TaskCreator> createState() => _TaskCreatorState();
}

class _TaskCreatorState extends ConsumerState<TaskCreator> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  int _coins = 20;
  TaskCategory _category = TaskCategory.realWorld;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Mission')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Mission Title', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'e.g., Clean your room',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<TaskCategory>(
              value: _category,
              items: TaskCategory.values.map((cat) {
                return DropdownMenuItem(value: cat, child: Text(cat.name.toUpperCase()));
              }).toList(),
              onChanged: (val) => setState(() => _category = val!),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            const Text('Reward (Time Coins)', style: TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              value: _coins.toDouble(),
              min: 5,
              max: 100,
              divisions: 19,
              label: '$_coins',
              onChanged: (val) => setState(() => _coins = val.toInt()),
            ),
            Center(child: Text('Reward: $_coins Coins', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty) {
                  ref.read(taskListProvider.notifier).addTask(SafiniTask(
                    id: DateTime.now().toIso8601String(),
                    title: _titleController.text,
                    description: _descController.text,
                    category: _category,
                    coins: _coins,
                  ));
                  Navigator.pop(context);
                }
              },
              child: const Text('Save Mission'),
            ),
          ],
        ),
      ),
    );
  }
}
