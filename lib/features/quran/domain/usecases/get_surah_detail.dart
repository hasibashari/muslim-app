import '../repository/quran_repository.dart';
import '../entities/ayah.dart';

class GetSurahDetail {
  final QuranRepository repository;

  GetSurahDetail(this.repository);

  Future<List<Ayah>> call(int surahId) => repository.getSurahDetail(surahId);
}
