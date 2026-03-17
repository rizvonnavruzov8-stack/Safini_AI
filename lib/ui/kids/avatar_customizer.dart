import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/state_providers.dart';
import '../../models/avatar_model.dart';
import '../../core/app_theme.dart';

class AvatarCustomizer extends ConsumerWidget {
  const AvatarCustomizer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(coinBalanceProvider);
    final avatars = ref.watch(avatarListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        title: const Text('My Avatar'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [_buildCoinBadge(balance)],
      ),
      body: Column(
        children: [
          _buildPreviewBox(context),
          _buildCategoryTabs(context),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, 
                mainAxisSpacing: 15, 
                crossAxisSpacing: 15,
                childAspectRatio: 0.8,
              ),
              itemCount: avatars.length,
              itemBuilder: (context, index) {
                final item = avatars[index];
                return _buildItemCard(context, ref, item, balance);
              },
            ),
          ),
          _buildSaveButton(context),
        ],
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

  Widget _buildPreviewBox(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      color: Colors.white,
      child: Center(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppTheme.primaryColor.withOpacity(0.05), AppTheme.primaryColor.withOpacity(0.15)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1), width: 4),
              ),
              child: ClipOval(
                child: Image.network(
                  "https://lh3.googleusercontent.com/aida-public/AB6AXuDgTVTT1D5mv1d0zmlTH5zrv7sxPwJ1a1X3LGg0LzL1JFsHZeM8H9l3rMvNATxKc2sFGgun-91ATsAsz92f9NTHvA_fSwzoPcfmN-c3cKr_ntREkP3obrfdXeMOGkSOP6ajM1DTLhbkDZKayDhC5WMRbT7cSr6WbNOIzBULZdIpfcB4vlq-lDaEv5rZrkIY_uhEhNxxATWBlBdMDJrfdvBff6htbndO8FcapEoTwWFTftDeqSAZz2mtOTBQ1LEQ5n6pD-0jJbeL42sh",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const CircleAvatar(
              backgroundColor: AppTheme.primaryColor,
              radius: 24,
              child: Icon(Icons.auto_awesome, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTabs(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.white,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildTab('Outfit', true),
          _buildTab('Face', false),
          _buildTab('Hair', false),
          _buildTab('Special', false),
        ],
      ),
    );
  }

  Widget _buildTab(String label, bool active) {
    return Container(
      margin: const EdgeInsets.only(right: 12, top: 10, bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active ? AppTheme.primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active ? Colors.white : AppTheme.textMuted,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, WidgetRef ref, AvatarItem item, int balance) {
    bool canAfford = balance >= item.cost;
    return GestureDetector(
      onTap: () {
        if (!item.isOwned && canAfford) {
          _confirmPurchase(context, ref, item);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: item.isOwned ? AppTheme.primaryColor : Colors.black.withOpacity(0.05),
            width: item.isOwned ? 2 : 1,
          ),
          boxShadow: [
             if (item.isOwned) BoxShadow(color: AppTheme.primaryColor.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Icon(
                _getIconData(item.iconPath),
                color: item.isOwned ? AppTheme.primaryColor : Colors.grey,
                size: 32,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: item.isOwned 
                ? const Icon(Icons.check_circle, color: AppTheme.primaryColor, size: 20)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.monetization_on, color: AppTheme.accentGold, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        '${item.cost}',
                        style: TextStyle(
                          color: canAfford ? AppTheme.primaryColor : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmPurchase(BuildContext context, WidgetRef ref, AvatarItem item) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('Unlock ${item.name}?'),
        content: Text('This will cost ${item.cost} Time Coins. Ready to look awesome?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Wait')),
          ElevatedButton(
            onPressed: () {
              ref.read(avatarListProvider.notifier).purchaseItem(item.id, item.cost);
              ref.read(coinBalanceProvider.notifier).addTransaction(Transaction(
                id: DateTime.now().toIso8601String(),
                amount: item.cost,
                type: TransactionType.spend,
                date: DateTime.now(),
                description: 'Bought ${item.name}',
              ));
              Navigator.pop(c);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${item.name} is now yours!')),
              );
            },
            child: const Text('Buy Now'),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
     return Padding(
       padding: const EdgeInsets.all(24),
       child: ElevatedButton(
         onPressed: () => Navigator.pop(context),
         child: const Text('Save My Look!'),
       ),
     );
  }

  IconData _getIconData(String path) {
    switch (path) {
      case 'apparel': return Icons.checkroom;
      case 'shield': return Icons.shield;
      case 'rocket_launch': return Icons.rocket_launch;
      default: return Icons.auto_awesome;
    }
  }
}