import '../repository/quran_repository.dart';
import '../entities/bookmark.dart';

class SaveBookmark {
  final QuranRepository repository;

  SaveBookmark(this.repository);

  Future<void> call(Bookmark bookmark) => repository.saveBookmark(bookmark);
}
