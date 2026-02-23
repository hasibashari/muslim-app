import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/home_provider.dart';
import '../widgets/home_header.dart';
import '../widgets/quick_menu_grid.dart';
import '../widgets/prayer_time_row.dart';
import '../widgets/activity_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeHeader(
              greeting: homeState.greeting,
              date: homeState.formattedDate,
            ),
            const SizedBox(height: 24),
            const QuickMenuGrid(),
            const SizedBox(height: 24),
            const PrayerTimeRow(),
            const SizedBox(height: 24),
            const ActivityCard(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
