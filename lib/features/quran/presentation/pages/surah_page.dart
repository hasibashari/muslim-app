import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/surah_provider.dart';
import '../widgets/surah_tile.dart';
import 'reader_page.dart';

class SurahPage extends ConsumerStatefulWidget {
  const SurahPage({super.key});

  @override
  ConsumerState<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends ConsumerState<SurahPage>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _searchController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final filteredAsync = ref.watch(filteredSurahListProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            onChanged: (query) {
              ref.read(surahSearchQueryProvider.notifier).update(query);
            },
            decoration: InputDecoration(
              hintText: 'Cari surah...',
              hintStyle: const TextStyle(
                color: Colors.grey,
              ), // Ubah warna teks petunjuk (hint)
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey, // Ubah warna ikon search
              ),
              filled: true,
              fillColor: Colors.white, // Ubah warna background kotak pencarian
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            style: const TextStyle(
              color: Colors.black,
            ), // Ubah warna teks input
          ),
        ),
        Expanded(
          child: filteredAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Text(
                'Gagal memuat: $e',
                style: theme.textTheme.bodyMedium,
              ),
            ),
            data: (surahList) {
              if (surahList.isEmpty) {
                return Center(
                  child: Text(
                    'Surah tidak ditemukan',
                    style: theme.textTheme.bodyMedium,
                  ),
                );
              }
              return ListView.separated(
                itemCount: surahList.length,
                separatorBuilder: (_, _) =>
                    Divider(color: theme.dividerColor, height: 1, indent: 72),
                itemBuilder: (context, index) {
                  final surah = surahList[index];
                  return SurahTile(
                    surah: surah,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReaderPage(
                            surahId: surah.id,
                            surahName: surah.transliteration,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
