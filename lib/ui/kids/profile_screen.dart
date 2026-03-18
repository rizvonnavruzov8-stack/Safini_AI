import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/state_providers.dart';
import '../../core/app_theme.dart';
import 'avatar_customizer.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(coinBalanceProvider);
    final level = ref.watch(levelProvider);
    final progress = ref.watch(progressToNextLevelProvider);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildProfileHeader(context, ref, level, progress),
            const SizedBox(height: 30),
            _buildStatsRow(balance),
            const SizedBox(height: 40),
            _buildActionList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, WidgetRef ref, int level, double progress) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.primaryColor, width: 4),
                boxShadow: [
                  BoxShadow(color: AppTheme.primaryColor.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8))
                ],
                image: const DecorationImage(
                  image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuDgTVTT1D5mv1d0zmlTH5zrv7sxPwJ1a1X3LGg0LzL1JFsHZeM8H9l3rMvNATxKc2sFGgun-91ATsAsz92f9NTHvA_fSwzoPcfmN-c3cKr_ntREkP3obrfdXeMOGkSOP6ajM1DTLhbkDZKayDhC5WMRbT7cSr6WbNOIzBULZdIpfcB4vlq-lDaEv5rZrkIY_uhEhNxxATWBlBdMDJrfdvBff6htbndO8FcapEoTwWFTftDezSAZz2mtOTBQ1LEQ5n6pD-0jJbeL42sh"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const AvatarCustomizer())),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: AppTheme.primaryColor, shape: BoxShape.circle),
                child: const Icon(Icons.edit, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(ref.watch(childProfileProvider)['name'] ?? 'Child', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Level $level", style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                  Text("${(progress * 100).toInt()}% to Level ${level + 1}", style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(int balance) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem("Coins", "$balance", Icons.monetization_on, Colors.amber),
        _buildStatItem("Streaks", "5 Days", Icons.local_fire_department, Colors.orange),
        _buildStatItem("Badges", "12", Icons.stars, Colors.purple),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
      ],
    );
  }

  Widget _buildActionList(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildActionItem(context, "Customize Avatar", Icons.person_outline, () {
             Navigator.push(context, MaterialPageRoute(builder: (c) => const AvatarCustomizer()));
          }),
          _buildActionItem(context, "Achievements", Icons.emoji_events_outlined, () {}),
          _buildActionItem(context, "Parental Controls", Icons.security_outlined, () {
             // Maybe a logic to switch to parent mode with PIN
          }),
          _buildActionItem(context, "Help & Support", Icons.help_outline, () {}),
        ],
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right, size: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
