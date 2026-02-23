import '../../domain/entities/bookmark.dart';

class BookmarkModel extends Bookmark {
  const BookmarkModel({
    required super.surahId,
    required super.surahName,
    required super.ayahNumber,
    required super.createdAt,
  });

  /// Accepts both camelCase (legacy JSON) and snake_case (SQLite) keys.
  factory BookmarkModel.fromJson(Map<String, dynamic> json) {
    return BookmarkModel(
      surahId: (json['surah_id'] ?? json['surahId']) as int,
      surahName: (json['surah_name'] ?? json['surahName']) as String,
      ayahNumber: (json['ayah_number'] ?? json['ayahNumber']) as int,
      createdAt: DateTime.parse(
        (json['created_at'] ?? json['createdAt']) as String,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'surah_id': surahId,
      'surah_name': surahName,
      'ayah_number': ayahNumber,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
