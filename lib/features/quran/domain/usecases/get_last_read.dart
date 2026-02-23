import '../repository/quran_repository.dart';
import '../entities/bookmark.dart';

class GetLastRead {
  final QuranRepository repository;

  GetLastRead(this.repository);

  Future<Bookmark?> call() => repository.getLastRead();
}
