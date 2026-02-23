import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasource/quran_local_datasource.dart';
import '../../data/repository_impl/quran_repository_impl.dart';
import '../../domain/entities/surah.dart';
import '../../domain/entities/juz.dart';
import '../../domain/entities/bookmark.dart';
import '../../domain/usecases/get_surah_list.dart';
import '../../domain/usecases/get_juz_list.dart';
import '../../domain/usecases/get_last_read.dart';
import '../../domain/usecases/save_bookmark.dart';
import '../../domain/usecases/remove_bookmark.dart';

final _repositoryProvider = Provider<QuranRepositoryImpl>((ref) {
  return QuranRepositoryImpl(localDatasource: QuranLocalDatasource());
});

final surahListProvider = FutureProvider<List<Surah>>((ref) {
  final repo = ref.watch(_repositoryProvider);
  return GetSurahList(repo).call();
});

final juzListProvider = FutureProvider<List<Juz>>((ref) {
  final repo = ref.watch(_repositoryProvider);
  return GetJuzList(repo).call();
});

final lastReadProvider = FutureProvider<Bookmark?>((ref) {
  final repo = ref.watch(_repositoryProvider);
  return GetLastRead(repo).call();
});

final bookmarkListProvider =
    AsyncNotifierProvider<BookmarkListNotifier, List<Bookmark>>(
      BookmarkListNotifier.new,
    );

class BookmarkListNotifier extends AsyncNotifier<List<Bookmark>> {
  @override
  Future<List<Bookmark>> build() async {
    final repo = ref.watch(_repositoryProvider);
    return repo.getBookmarks();
  }

  Future<void> saveBookmark(Bookmark bookmark) async {
    final repo = ref.read(_repositoryProvider);
    await SaveBookmark(repo).call(bookmark);
    ref.invalidateSelf();
    ref.invalidate(lastReadProvider);
    await future;
  }

  Future<void> removeBookmark(int surahId, int ayahNumber) async {
    final repo = ref.read(_repositoryProvider);
    await RemoveBookmark(repo).call(surahId, ayahNumber);
    ref.invalidateSelf();
    await future;
  }
}
