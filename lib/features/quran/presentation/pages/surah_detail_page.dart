import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/reader_provider.dart';
import '../widgets/ayah_card.dart';

class SurahDetailPage extends ConsumerWidget {
  final int surahId;
  final String surahName;

  const SurahDetailPage({
    super.key,
    required this.surahId,
    required this.surahName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final readerAsync = ref.watch(readerProvider(surahId));

    return Scaffold(
      appBar: AppBar(
        title: Text(surahName),
        actions: [
          IconButton(
            onPressed: () =>
                ref.read(readerProvider(surahId).notifier).decreaseFontSize(),
            icon: const Icon(Icons.text_decrease_rounded, size: 20),
          ),
          IconButton(
            onPressed: () =>
                ref.read(readerProvider(surahId).notifier).increaseFontSize(),
            icon: const Icon(Icons.text_increase_rounded, size: 20),
          ),
        ],
      ),
      body: readerAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text('Gagal memuat surah: $e', style: theme.textTheme.bodyMedium),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(readerProvider(surahId)),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
        data: (state) => ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 24),
          itemCount: state.ayahs.length,
          itemBuilder: (context, index) {
            final ayah = state.ayahs[index];
            return AyahCard(
              ayah: ayah,
              arabicFontSize: state.fontSize,
              onBookmark: () async {
                await ref
                    .read(readerProvider(surahId).notifier)
                    .saveBookmark(surahId, surahName, ayah.ayah);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Ayat ${ayah.ayah} ditandai'),
                      backgroundColor: theme.colorScheme.primary,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
