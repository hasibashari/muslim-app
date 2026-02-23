import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quran_provider.dart';
import 'surah_page.dart';
import 'juz_page.dart';
import 'bookmark_page.dart';

class QuranPage extends ConsumerStatefulWidget {
  const QuranPage({super.key});

  @override
  ConsumerState<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends ConsumerState<QuranPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surahAsync = ref.watch(surahListProvider);
    final juzAsync = ref.watch(juzListProvider);
    final bookmarkAsync = ref.watch(bookmarkListProvider);

    final isLoading =
        surahAsync.isLoading || juzAsync.isLoading || bookmarkAsync.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Al-Quran'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.colorScheme.secondary,
          labelColor: theme.colorScheme.secondary,
          unselectedLabelColor: theme.textTheme.bodySmall?.color,
          tabs: const [
            Tab(text: 'Surah'),
            Tab(text: 'Juz'),
            Tab(text: 'Bookmark'),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                const SurahPage(),
                JuzPage(juzList: juzAsync.value ?? []),
                BookmarkPage(
                  bookmarks: bookmarkAsync.value ?? [],
                  onRemove: (surahId, ayahNumber) async {
                    await ref
                        .read(bookmarkListProvider.notifier)
                        .removeBookmark(surahId, ayahNumber);
                  },
                ),
              ],
            ),
    );
  }
}
