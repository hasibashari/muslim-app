import '../repository/quran_repository.dart';
import '../entities/surah.dart';

class GetSurahList {
  final QuranRepository repository;

  GetSurahList(this.repository);

  Future<List<Surah>> call() => repository.getSurahList();
}
