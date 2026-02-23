import 'package:flutter/material.dart';
import '../../domain/entities/ayah.dart';

class AyahCard extends StatelessWidget {
  final Ayah ayah;
  final double arabicFontSize;
  final VoidCallback? onBookmark;
  final Color? backgroundColor;

  const AyahCard({
    super.key,
    required this.ayah,
    this.arabicFontSize = 28.0,
    this.onBookmark,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      // Gunakan warna dari parameter jika ada, jika tidak gunakan default surface
      color: backgroundColor ?? colorScheme.surface,
      // [EDIT DISINI] Ubah margin menjadi 0 agar tampilan full (mentok ke sisi layar)
      margin: EdgeInsets.zero,
      // [EDIT DISINI] Atur kelengkungan sudut (border radius) di sini
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          0,
        ), // Ubah nilai 0 sesuai kebutuhan (misal 12.0 untuk melengkung)
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Ayah number (left) + Arabic text (right) ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ayah number on the left
                Padding(
                  padding: const EdgeInsets.only(top: 8, right: 12),
                  child: Text(
                    '${ayah.ayah}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Arabic text on the right
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      // [EDIT DISINI] Mengganti tanda Ruku' (Ain kecil/U+08D6) yang error (tofu)
                      // dengan huruf Ain standar (U+0639) agar tetap terbaca.
                      ayah.arabic.replaceAll('\u08D6', ' \u0639'),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'KFGQPC',
                        fontSize: arabicFontSize,
                        height: 1.8,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Latin transliteration
            Text(
              ayah.latin,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 8),
            // Translation with superscript citations
            _buildTranslation(theme),
            // Footnotes section
            if (ayah.footnotes != null && ayah.footnotes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surface.withValues(alpha: 0.5),
                  // [EDIT DISINI] Pengaturan border untuk kotak keterangan
                  // Menggunakan border top sebagai penanda keterangan
                  border: Border(
                    top: BorderSide(color: colorScheme.primary, width: 1.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Keterangan',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      ayah.footnotes!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Builds translation text with ALL numeric characters rendered as
  /// superscript citations using [Text.rich], [WidgetSpan], and
  /// [Transform.translate]. Supports multi-digit numbers dynamically.
  Widget _buildTranslation(ThemeData theme) {
    final text = ayah.translation;
    final baseStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
      height: 1.5,
    );
    final citationStyle = theme.textTheme.labelSmall?.copyWith(
      color: theme.colorScheme.primary,
      fontSize: 10,
      fontWeight: FontWeight.bold,
    );

    // Match citation markers: one or more digits followed by ")"
    // e.g. "Tuhan1) semesta" → captures "1", consumes "1)"
    final regex = RegExp(r'(\d+)\)');
    final matches = regex.allMatches(text);

    if (matches.isEmpty) {
      return Text(text, style: baseStyle);
    }

    final spans = <InlineSpan>[];
    int lastEnd = 0;

    for (final match in matches) {
      // Add preceding text
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: text.substring(lastEnd, match.start)));
      }
      // Add superscript number (without the parenthesis)
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Transform.translate(
            offset: const Offset(0, -6),
            child: Text(match.group(1)!, style: citationStyle),
          ),
        ),
      );
      lastEnd = match.end;
    }

    // Add remaining text after last match
    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd)));
    }

    return Text.rich(TextSpan(style: baseStyle, children: spans));
  }
}
