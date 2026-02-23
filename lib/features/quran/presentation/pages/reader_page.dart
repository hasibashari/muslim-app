import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/ayah.dart';
import '../../domain/entities/surah.dart';
import '../providers/quran_provider.dart';
import '../providers/reader_provider.dart';
import '../widgets/ayah_card.dart';

class ReaderPage extends ConsumerStatefulWidget {
  final int surahId;
  final String surahName;
  final int initialAyah;

  const ReaderPage({
    super.key,
    required this.surahId,
    required this.surahName,
    this.initialAyah = 1,
  });

  @override
  ConsumerState<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends ConsumerState<ReaderPage> {
  late int _activeSurahId;
  late String _activeSurahName;
  int _currentJuz = 1;
  List<Ayah> _currentAyahs = [];

  // Track the minimum item index built each frame to determine
  // which ayah is at the top of the visible viewport.
  int _minBuiltIndex = 0;
  bool _frameScheduled = false;

  @override
  void initState() {
    super.initState();
    _activeSurahId = widget.surahId;
    _activeSurahName = widget.surahName;
  }

  void _onSurahTap(Surah surah) {
    setState(() {
      _activeSurahId = surah.id;
      _activeSurahName = surah.transliteration;
      _currentAyahs = [];
    });
  }

  /// Navigate to adjacent surah by [delta] (+1 = next, -1 = previous).
  void _navigateToSurah(int delta) {
    final surahList = ref.read(surahListProvider).value;
    if (surahList == null || surahList.isEmpty) return;

    final targetId = _activeSurahId + delta;
    final target = surahList.where((s) => s.id == targetId).firstOrNull;
    if (target != null) {
      _onSurahTap(target);
    }
  }

  /// Called from [itemBuilder] each time an item is built.
  /// Tracks the smallest index built during the current frame.
  void _onItemBuilt(int index) {
    if (!_frameScheduled) {
      _minBuiltIndex = index;
      _frameScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _frameScheduled = false;
        if (_currentAyahs.isNotEmpty &&
            _minBuiltIndex >= 0 &&
            _minBuiltIndex < _currentAyahs.length) {
          _setJuz(_currentAyahs[_minBuiltIndex].juz);
        }
      });
    } else if (index < _minBuiltIndex) {
      _minBuiltIndex = index;
    }
  }

  void _setJuz(int juz) {
    if (_currentJuz != juz) {
      setState(() {
        _currentJuz = juz;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final readerAsync = ref.watch(readerProvider(_activeSurahId));
    final surahListAsync = ref.watch(surahListProvider);

    final surahList = surahListAsync.value;
    final activeSurah = surahList
        ?.where((s) => s.id == _activeSurahId)
        .firstOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Juz $_currentJuz',
          style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () => ref
                .read(readerProvider(_activeSurahId).notifier)
                .decreaseFontSize(),
            icon: const Icon(Icons.text_decrease_rounded, size: 20),
            tooltip: 'Perkecil teks',
          ),
          IconButton(
            onPressed: () => ref
                .read(readerProvider(_activeSurahId).notifier)
                .increaseFontSize(),
            icon: const Icon(Icons.text_increase_rounded, size: 20),
            tooltip: 'Perbesar teks',
          ),
        ],
      ),
      body: Column(
        children: [
          // ── RTL Surah Navigation Bar ──
          _SurahNavigationBar(
            surahList: surahList ?? [],
            activeSurahId: _activeSurahId,
            onSurahTap: _onSurahTap,
            theme: theme,
            colorScheme: colorScheme,
          ),
          // ── Ayah List (OrnamentalSurahInfoBar scrolls as first item) ──
          Expanded(
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                final velocity = details.primaryVelocity ?? 0;
                if (velocity > 300) {
                  // Swipe right → next surah
                  _navigateToSurah(1);
                } else if (velocity < -300) {
                  // Swipe left → previous surah
                  _navigateToSurah(-1);
                }
              },
              child: readerAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Gagal memuat surah: $e',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            ref.invalidate(readerProvider(_activeSurahId)),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
                data: (state) {
                  // Cache ayahs and initialise juz on first load
                  if (_currentAyahs != state.ayahs) {
                    _currentAyahs = state.ayahs;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_currentAyahs.isNotEmpty) {
                        _setJuz(_currentAyahs.first.juz);
                      }
                    });
                  }

                  // +1 for the info bar at index 0
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 24),
                    itemCount: state.ayahs.length + 1,
                    itemBuilder: (context, index) {
                      // Index 0 → scrollable surah info bar
                      if (index == 0) {
                        return _OrnamentalSurahInfoBar(
                          location: activeSurah?.location,
                          translation: activeSurah?.translation,
                          numAyah: activeSurah?.numAyah,
                          theme: theme,
                          colorScheme: colorScheme,
                        );
                      }

                      final ayahIndex = index - 1;
                      _onItemBuilt(ayahIndex);
                      final ayah = state.ayahs[ayahIndex];

                      // Logika Warna Selang-seling (Zebra Striping)
                      // Jika index genap (0, 2, 4...) gunakan warna A
                      // Jika index ganjil (1, 3, 5...) gunakan warna B
                      final bool isEven = ayahIndex % 2 == 0;
                      final Color rowColor = isEven
                          ? colorScheme.surface
                          : Colors.white;

                      return AyahCard(
                        ayah: ayah,
                        arabicFontSize: state.fontSize,
                        backgroundColor: rowColor,
                        onBookmark: () async {
                          await ref
                              .read(readerProvider(_activeSurahId).notifier)
                              .saveBookmark(
                                _activeSurahId,
                                _activeSurahName,
                                ayah.ayah,
                              );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Ayat ${ayah.ayah} ditandai'),
                                backgroundColor: colorScheme.primary,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Centered surah navigation bar showing previous / current / next.
class _SurahNavigationBar extends StatelessWidget {
  final List<Surah> surahList;
  final int activeSurahId;
  final ValueChanged<Surah> onSurahTap;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _SurahNavigationBar({
    required this.surahList,
    required this.activeSurahId,
    required this.onSurahTap,
    required this.theme,
    required this.colorScheme,
  });

  Surah? _findById(int id) => surahList.where((s) => s.id == id).firstOrNull;

  @override
  Widget build(BuildContext context) {
    final prev = _findById(activeSurahId - 1);
    final current = _findById(activeSurahId);
    final next = _findById(activeSurahId + 1);

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          // Left slot (RTL): next surah (or empty spacer)
          Expanded(
            child: next != null
                ? _buildItem(next, isActive: false)
                : const SizedBox.shrink(),
          ),
          // Center slot: active surah (always present)
          if (current != null)
            Expanded(child: _buildItem(current, isActive: true)),
          // Right slot (RTL): previous surah (or empty spacer)
          Expanded(
            child: prev != null
                ? _buildItem(prev, isActive: false)
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(Surah surah, {required bool isActive}) {
    return GestureDetector(
      onTap: () => onSurahTap(surah),
      child: Container(
        alignment: Alignment.center,
        decoration: isActive
            ? BoxDecoration(
                border: Border(
                  // Warna garis bawah pada tab surah yang aktif
                  bottom: BorderSide(color: colorScheme.primary, width: 2.5),
                ),
              )
            : null,
        child: Text(
          '${surah.id}. ${surah.transliteration}',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            // Warna teks nama surah: Primary jika aktif, abu-abu jika tidak
            color: isActive
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

/// Left: location | Center: translation | Right: numAyah Ayat
class _OrnamentalSurahInfoBar extends StatelessWidget {
  final String? location;
  final String? translation;
  final int? numAyah;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _OrnamentalSurahInfoBar({
    required this.location,
    required this.translation,
    required this.numAyah,
    required this.theme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          // Left: location
          Expanded(
            child: Text(
              location ?? '-',
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          // Center: translation (larger)
          Expanded(
            flex: 2,
            child: Text(
              translation ?? '-',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Right: numAyah Ayat
          Expanded(
            child: Text(
              '${numAyah ?? '-'}\nAyat',
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
