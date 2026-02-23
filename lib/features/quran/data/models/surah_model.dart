import '../../domain/entities/surah.dart';

class SurahModel extends Surah {
  const SurahModel({
    required super.id,
    required super.arabic,
    required super.latin,
    required super.transliteration,
    required super.translation,
    required super.numAyah,
    required super.page,
    required super.location,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      id: json['id'] as int,
      arabic: (json['arabic'] as String? ?? '').trim(),
      latin: (json['latin'] as String? ?? '').trim(),
      transliteration: (json['transliteration'] as String? ?? '').trim(),
      translation: (json['translation'] as String? ?? '').trim(),
      numAyah: json['num_ayah'] as int? ?? 0,
      page: json['page'] as int? ?? 0,
      location: json['location'] as String? ?? '',
    );
  }
}
