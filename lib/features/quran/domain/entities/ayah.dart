class Ayah {
  final int id;
  final int surahId;
  final int ayah;
  final int page;
  final int juz;
  final String arabic;
  final String latin;
  final String translation;
  final String? footnotes;
  final List<String> arabicWords;

  const Ayah({
    required this.id,
    required this.surahId,
    required this.ayah,
    required this.page,
    required this.juz,
    required this.arabic,
    required this.latin,
    required this.translation,
    this.footnotes,
    this.arabicWords = const [],
  });
}
