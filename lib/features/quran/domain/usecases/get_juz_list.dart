import '../repository/quran_repository.dart';
import '../entities/juz.dart';

class GetJuzList {
  final QuranRepository repository;

  GetJuzList(this.repository);

  Future<List<Juz>> call() => repository.getJuzList();
}
