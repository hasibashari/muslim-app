import '../repository/quran_repository.dart';

class RemoveBookmark {
  final QuranRepository repository;

  RemoveBookmark(this.repository);

  Future<void> call(int surahId, int ayahNumber) =>
      repository.removeBookmark(surahId, ayahNumber);
}
