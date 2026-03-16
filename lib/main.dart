import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/app_theme.dart';
import 'providers/state_providers.dart';
import 'services/storage_service.dart';
import 'ui/kids/kids_dashboard.dart';
import 'ui/parent/parent_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final storageService = StorageService();
  await storageService.init();

  runApp(
    ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(storageService),
      ],
      child: const SafiniApp(),
    ),
  );
}

class SafiniApp extends ConsumerWidget {
  const SafiniApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(appModeProvider);

    return MaterialApp(
      title: 'Safini AI',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: mode == AppMode.kids ? const KidsDashboard() : const ParentDashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}
