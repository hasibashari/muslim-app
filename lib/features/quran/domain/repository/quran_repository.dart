import '../entities/surah.dart';
import '../entities/ayah.dart';
import '../entities/juz.dart';
import '../entities/bookmark.dart';

abstract class QuranRepository {
  Future<List<Surah>> getSurahList();
  Future<List<Ayah>> getSurahDetail(int surahId);
  Future<List<Juz>> getJuzList();
  Future<Bookmark?> getLastRead();
  Future<void> saveBookmark(Bookmark bookmark);
  Future<void> removeBookmark(int surahId, int ayahNumber);
  Future<List<Bookmark>> getBookmarks();
}
