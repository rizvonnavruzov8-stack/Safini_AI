import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/transaction_model.dart';
import '../../models/reward_model.dart';
import '../../providers/state_providers.dart';
import '../../core/app_theme.dart';
import 'avatar_customizer.dart';

class RewardShop extends ConsumerWidget {
  const RewardShop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(coinBalanceProvider);
    final rewards = ref.watch(rewardListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        title: const Text('Reward Store'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          _buildCoinBadge(balance),
        ],
      ),
      body: rewards.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No rewards available. Ask your parent to add some!'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.refresh(rewardListProvider),
                    child: const Text('Refresh Store'),
                  ),
                ],
              ),
            )

          : GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 0.75,
              ),
              itemCount: rewards.length,
              itemBuilder: (context, index) {
                final reward = rewards[index];
                final canAfford = balance >= reward.cost;
                return _buildRewardCard(context, ref, reward, canAfford);
              },
            ),
    );
  }

  Widget _buildCoinBadge(int balance) {
    return Container(
      margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.monetization_on, color: AppTheme.accentGold, size: 18),
          const SizedBox(width: 4),
          Text(
            '$balance',
            style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardCard(BuildContext context, WidgetRef ref, Reward reward, bool canAfford) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getRewardColor(reward.title).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(_getRewardIcon(reward.title), color: _getRewardColor(reward.title), size: 30),
          ),
          const SizedBox(height: 12),
          Text(
            reward.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            reward.description,
            style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: canAfford ? () => _confirmPurchase(context, ref, reward) : null,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 40),
              backgroundColor: canAfford ? AppTheme.primaryColor : Colors.grey[200],
              foregroundColor: canAfford ? Colors.white : Colors.grey[500],
              elevation: canAfford ? 4 : 0,
            ),
            child: Text('${reward.cost} Coins'),
          ),
        ],
      ),
    );
  }

  IconData _getRewardIcon(String title) {
    final t = title.toLowerCase();
    if (t.contains('youtube')) return FontAwesomeIcons.youtube;
    if (t.contains('roblox')) return FontAwesomeIcons.gamepad;
    if (t.contains('minecraft')) return FontAwesomeIcons.cubes;
    if (t.contains('stars')) return FontAwesomeIcons.star;
    return Icons.apps;
  }

  Color _getRewardColor(String title) {
    final t = title.toLowerCase();
    if (t.contains('youtube')) return Colors.red;
    if (t.contains('roblox')) return Colors.blue;
    if (t.contains('minecraft')) return Colors.green;
    return AppTheme.primaryColor;
  }

  void _confirmPurchase(BuildContext context, WidgetRef ref, Reward reward) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Ready to unlock?'),
        content: Text('This will redeem ${reward.cost} Time Coins for ${reward.title}. Enjoy your time!'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Not yet')),
          ElevatedButton(
            onPressed: () {
              ref.read(coinBalanceProvider.notifier).addTransaction(Transaction(
                id: DateTime.now().toIso8601String(),
                amount: reward.cost,
                type: TransactionType.spend,
                date: DateTime.now(),
                description: 'Unlocked ${reward.title}',
              ));
              Navigator.pop(c);
              _showSuccessOverlay(context, reward.title);
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
