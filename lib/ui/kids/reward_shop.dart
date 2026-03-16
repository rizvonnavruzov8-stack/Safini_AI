import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/transaction_model.dart';
import '../../providers/state_providers.dart';

class RewardShop extends ConsumerWidget {
  const RewardShop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(coinBalanceProvider);
    final theme = Theme.of(context);

    // Mock rewards for MVP
    final rewards = [
      {'id': 'r1', 'title': 'Roblox Access', 'cost': 50, 'time': 30, 'icon': FontAwesomeIcons.gamepad, 'color': Colors.red},
      {'id': 'r2', 'title': 'YouTube Time', 'cost': 30, 'time': 15, 'icon': FontAwesomeIcons.youtube, 'color': Colors.redAccent},
      {'id': 'r3', 'title': 'Minecraft Session', 'cost': 100, 'time': 60, 'icon': FontAwesomeIcons.cubes, 'color': Colors.green},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reward Shop'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '🪙 $balance',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 0.8,
        ),
        itemCount: rewards.length,
        itemBuilder: (context, index) {
          final reward = rewards[index];
          final canAfford = balance >= (reward['cost'] as int);

          return _buildRewardCard(context, ref, reward, canAfford);
        },
      ),
    );
  }

  Widget _buildRewardCard(BuildContext context, WidgetRef ref, Map<String, dynamic> reward, bool canAfford) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(reward['icon'] as IconData, color: reward['color'] as Color, size: 40),
          const SizedBox(height: 12),
          Text(
            reward['title'] as String,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            '${reward['time']} Minutes',
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: canAfford ? () => _confirmPurchase(context, ref, reward) : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              minimumSize: const Size(0, 36),
              backgroundColor: canAfford ? const Color(0xFFFFD700) : Colors.grey[300],
              foregroundColor: canAfford ? Colors.black : Colors.grey[600],
            ),
            child: Text('${reward['cost']} Coins'),
          ),
        ],
      ),
    );
  }

  void _confirmPurchase(BuildContext context, WidgetRef ref, Map<String, dynamic> reward) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ready to play?'),
        content: Text('This will unlock ${reward['time']} minutes of ${reward['title']}. Ready?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Not yet')),
          ElevatedButton(
            onPressed: () {
              ref.read(coinBalanceProvider.notifier).addTransaction(Transaction(
                id: DateTime.now().toIso8601String(),
                amount: reward['cost'] as int,
                type: TransactionType.spend,
                date: DateTime.now(),
                description: 'Unlocked ${reward['title']}',
              ));
              Navigator.pop(context);
              _showSuccessOverlay(context, reward['title'] as String);
            },
            child: const Text('Unlock!'),
          ),
        ],
      ),
    );
  }

  void _showSuccessOverlay(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Success! $title is unlocked for your next session.'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
