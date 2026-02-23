import '../../domain/entities/ayah.dart';

class AyahModel extends Ayah {
  const AyahModel({
    required super.id,
    required super.surahId,
    required super.ayah,
    required super.page,
    required super.juz,
    required super.arabic,
    required super.latin,
    required super.translation,
    super.footnotes,
    super.arabicWords,
  });

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      id: json['id'] as int,
      surahId: json['surah_id'] as int,
      ayah: json['ayah'] as int,
      page: json['page'] as int? ?? 0,
      juz: json['juz'] as int? ?? 0,
      arabic: json['arabic'] as String? ?? '',
      latin: json['latin'] as String? ?? '',
      translation: json['translation'] as String? ?? '',
      footnotes: json['footnotes'] as String?,
      arabicWords:
          (json['arabic_words'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}
