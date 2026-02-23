import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/surah.dart';
import 'quran_provider.dart';

final surahSearchQueryProvider =
    NotifierProvider<SurahSearchQueryNotifier, String>(
      SurahSearchQueryNotifier.new,
    );

class SurahSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void update(String query) => state = query;
}

final filteredSurahListProvider = Provider<AsyncValue<List<Surah>>>((ref) {
  final query = ref.watch(surahSearchQueryProvider).toLowerCase();
  final surahListAsync = ref.watch(surahListProvider);

  return surahListAsync.whenData((surahList) {
    if (query.isEmpty) return surahList;
    return surahList.where((s) {
      return s.latin.toLowerCase().contains(query) ||
          s.transliteration.toLowerCase().contains(query) ||
          s.translation.toLowerCase().contains(query) ||
          s.id.toString() == query;
    }).toList();
  });
});
