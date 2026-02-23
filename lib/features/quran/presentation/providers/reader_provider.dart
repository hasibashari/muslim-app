import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasource/quran_local_datasource.dart';
import '../../data/repository_impl/quran_repository_impl.dart';
import '../../domain/entities/ayah.dart';
import '../../domain/entities/bookmark.dart';
import '../../domain/usecases/get_surah_detail.dart';
import '../../domain/usecases/save_bookmark.dart';
import 'quran_provider.dart';

final readerProvider =
    AsyncNotifierProvider.family<ReaderNotifier, ReaderState, int>(
      (surahId) => ReaderNotifier(surahId),
    );

class ReaderState {
  final List<Ayah> ayahs;
  final double fontSize;

  const ReaderState({required this.ayahs, this.fontSize = 28.0});

  ReaderState copyWith({List<Ayah>? ayahs, double? fontSize}) {
    return ReaderState(
      ayahs: ayahs ?? this.ayahs,
      fontSize: fontSize ?? this.fontSize,
    );
  }
}

class ReaderNotifier extends AsyncNotifier<ReaderState> {
  final int surahId;

  ReaderNotifier(this.surahId);

  @override
  Future<ReaderState> build() async {
    final repo = QuranRepositoryImpl(localDatasource: QuranLocalDatasource());
    final ayahs = await GetSurahDetail(repo).call(surahId);
    return ReaderState(ayahs: ayahs);
  }

  void increaseFontSize() {
    final current = state.value;
    if (current == null) return;
    if (current.fontSize < 48) {
      state = AsyncData(current.copyWith(fontSize: current.fontSize + 2));
    }
  }

  void decreaseFontSize() {
    final current = state.value;
    if (current == null) return;
    if (current.fontSize > 18) {
      state = AsyncData(current.copyWith(fontSize: current.fontSize - 2));
    }
  }

  Future<void> saveBookmark(
    int surahId,
    String surahName,
    int ayahNumber,
  ) async {
    final repo = QuranRepositoryImpl(localDatasource: QuranLocalDatasource());
    await SaveBookmark(repo).call(
      Bookmark(
        surahId: surahId,
        surahName: surahName,
        ayahNumber: ayahNumber,
        createdAt: DateTime.now(),
      ),
    );
    ref.invalidate(bookmarkListProvider);
    ref.invalidate(lastReadProvider);
  }
}
