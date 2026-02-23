import '../../domain/entities/surah.dart';
import '../../domain/entities/ayah.dart';
import '../../domain/entities/juz.dart';
import '../../domain/entities/bookmark.dart';
import '../../domain/repository/quran_repository.dart';
import '../datasource/quran_local_datasource.dart';
import '../models/bookmark_model.dart';
import '../models/juz_model.dart';

class QuranRepositoryImpl implements QuranRepository {
  final QuranLocalDatasource localDatasource;

  QuranRepositoryImpl({required this.localDatasource});

  @override
  Future<List<Surah>> getSurahList() => localDatasource.getSurahList();

  @override
  Future<List<Ayah>> getSurahDetail(int surahId) =>
      localDatasource.getSurahDetail(surahId);

  @override
  Future<List<Juz>> getJuzList() async {
    // Build juz list from surah data. Quran has 30 juz.
    // Simplified mapping of juz boundaries
    const juzData = <List<dynamic>>[
      [1, 'Al-Fatihah', 1, 'Al-Baqarah', 141],
      [2, 'Al-Baqarah', 142, 'Al-Baqarah', 252],
      [3, 'Al-Baqarah', 253, 'Ali \'Imran', 92],
      [4, 'Ali \'Imran', 93, 'An-Nisa\'', 23],
      [5, 'An-Nisa\'', 24, 'An-Nisa\'', 147],
      [6, 'An-Nisa\'', 148, 'Al-Ma\'idah', 81],
      [7, 'Al-Ma\'idah', 82, 'Al-An\'am', 110],
      [8, 'Al-An\'am', 111, 'Al-A\'raf', 87],
      [9, 'Al-A\'raf', 88, 'Al-Anfal', 40],
      [10, 'Al-Anfal', 41, 'At-Taubah', 92],
      [11, 'At-Taubah', 93, 'Hud', 5],
      [12, 'Hud', 6, 'Yusuf', 52],
      [13, 'Yusuf', 53, 'Ibrahim', 52],
      [14, 'Al-Hijr', 1, 'An-Nahl', 128],
      [15, 'Al-Isra\'', 1, 'Al-Kahf', 74],
      [16, 'Al-Kahf', 75, 'Taha', 135],
      [17, 'Al-Anbiya\'', 1, 'Al-Hajj', 78],
      [18, 'Al-Mu\'minun', 1, 'Al-Furqan', 20],
      [19, 'Al-Furqan', 21, 'An-Naml', 55],
      [20, 'An-Naml', 56, 'Al-\'Ankabut', 45],
      [21, 'Al-\'Ankabut', 46, 'Al-Ahzab', 30],
      [22, 'Al-Ahzab', 31, 'Yasin', 27],
      [23, 'Yasin', 28, 'Az-Zumar', 31],
      [24, 'Az-Zumar', 32, 'Fussilat', 46],
      [25, 'Fussilat', 47, 'Al-Jasiyah', 37],
      [26, 'Al-Ahqaf', 1, 'Az-Zariyat', 30],
      [27, 'Az-Zariyat', 31, 'Al-Hadid', 29],
      [28, 'Al-Mujadalah', 1, 'At-tahrim', 12],
      [29, 'Al-Mulk', 1, 'Al-Mursalat', 50],
      [30, 'An-Naba\'', 1, 'An-Nas', 6],
    ];

    return juzData
        .map(
          (j) => JuzModel(
            number: j[0] as int,
            startSurah: j[1] as String,
            startAyah: j[2] as int,
            endSurah: j[3] as String,
            endAyah: j[4] as int,
          ),
        )
        .toList();
  }

  @override
  Future<Bookmark?> getLastRead() => localDatasource.getLastRead();

  @override
  Future<void> saveBookmark(Bookmark bookmark) async {
    final model = BookmarkModel(
      surahId: bookmark.surahId,
      surahName: bookmark.surahName,
      ayahNumber: bookmark.ayahNumber,
      createdAt: bookmark.createdAt,
    );
    await localDatasource.insertBookmark(model);
    await localDatasource.saveLastRead(model);
  }

  @override
  Future<void> removeBookmark(int surahId, int ayahNumber) =>
      localDatasource.removeBookmark(surahId, ayahNumber);

  @override
  Future<List<Bookmark>> getBookmarks() => localDatasource.getBookmarks();
}
