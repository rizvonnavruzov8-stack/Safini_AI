import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/state_providers.dart';
import '../../core/app_theme.dart';
import 'reward_shop.dart';
import 'mission_feed.dart';

class KidsDashboard extends ConsumerWidget {
  const KidsDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watching providers for real-time data
    final balance = ref.watch(coinBalanceProvider);
    final level = ref.watch(levelProvider);
    final progress = ref.watch(progressToNextLevelProvider);
    final tasks = ref.watch(taskListProvider);
    
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomNav(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildAppBar(context, ref),
              _buildHero(context, balance, level),
              _buildProgress(context, progress),
              _buildQuickActions(context),
              _buildQuests(context, tasks),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Header matching HTML Mock
  Widget _buildAppBar(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppTheme.primaryColor.withOpacity(0.1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primaryColor, width: 2),
              image: const DecorationImage(
                image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuCAdqdKZbBThgPeqD23ig-H_IPD0ZU3_6Mb3mf9lN4EzOaWE0ealoujtPDCf4A0GLn3hqq2LY3xM-DBSGMREqEHP4P70jh8SEGG8BfRDj3-EQyHEVgcn8yyD-6jkwlmHkVd3xwA8csjdwVs4qOpY-3Bdhe-8wO_RY0035WWGcbRUZrK7VDASdvHRulyyqFj_2ynacHwjoBdYfVVyU7GyhUH9lLGtnGBmqMRMaSLNKjTcbzAXlVxN68kbtEzWIcCyNpImd8ryWsGtI4D"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            'Safinio Kids',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          IconButton(
            onPressed: () {
              ref.read(appModeProvider.notifier).state = AppMode.parent;
            },
            icon: const Icon(Icons.settings, color: AppTheme.primaryColor),
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  // Hero section with Avatar and Coins
  Widget _buildHero(BuildContext context, int balance, int level) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, AppTheme.bgLight.withOpacity(0.5)],
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primaryColor, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                  image: const DecorationImage(
                    image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuDgTVTT1D5mv1d0zmlTH5zrv7sxPwJ1a1X3LGg0LzL1JFsHZeM8H9l3rMvNATxKc2sFGgun-91ATsAsz92f9NTHvA_fSwzoPcfmN-c3cKr_ntREkP3obrfdXeMOGkSOP6ajM1DTLhbkDZKayDhC5WMRbT7cSr6WbNOIzBULZdIpfcB4vlq-lDaEv5rZrkIY_uhEhNxxATWBlBdMDJrfdvBff6htbndO8FcapEoTwWFTftDeqSAZz2mtOTBQ1LEQ5n6pD-0jJbeL42sh"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Text(
                  'LVL $level',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Explorer Leo',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 28),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainCenter,
            children: [
              const Icon(Icons.monetization_on, color: AppTheme.accentGold, size: 28),
              const SizedBox(width: 6),
              Text(
                '$balance Time Coins',
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // XP Progress Bar
  Widget _buildProgress(BuildContext context, double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('LEVEL PROGRESS', style: Theme.of(context).textTheme.labelLarge),
              Text('${(progress * 100).toInt()} / 100 XP', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              '${(100 - (progress * 100)).toInt()} XP more to reach the next level!',
              style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // Quick Action to Store
  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const RewardShop())),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: const Row(
            children: [
              Icon(Icons.shopping_cart, color: Colors.white, size: 32),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reward Store',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Spend your Time Coins',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  // Quest List
  Widget _buildQuests(BuildContext context, List tasks) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Today's Quests", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          if (tasks.isEmpty)
            const Center(child: Text("No quests today! Relax!"))
          else
            ...tasks.map((task) => _buildQuestItem(context, task)).toList(),
        ],
      ),
    );
  }

  Widget _buildQuestItem(BuildContext context, dynamic task) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: Colors.white,
      side: BorderSide(color: AppTheme.primaryColor.withOpacity(0.05)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.star, color: AppTheme.primaryColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(task.description, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.monetization_on, color: AppTheme.primaryColor, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${task.coins}',
                    style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 24, top: 12, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppTheme.primaryColor.withOpacity(0.1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', true),
          _buildNavItem(Icons.task_alt, 'Tasks', false),
          _buildNavItem(Icons.shopping_bag, 'Store', false),
          _buildNavItem(Icons.person, 'Profile', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool active) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: active ? AppTheme.primaryColor : AppTheme.textMuted, size: 28),
        Text(
          label,
          style: TextStyle(
            color: active ? AppTheme.primaryColor : AppTheme.textMuted,
            fontSize: 10,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}