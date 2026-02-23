import 'package:flutter/material.dart';
import '../../domain/entities/juz.dart';

class JuzTile extends StatelessWidget {
  final Juz juz;
  final VoidCallback? onTap;

  const JuzTile({super.key, required this.juz, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                '${juz.number}',
                style: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Juz ${juz.number}', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    '${juz.startSurah} : ${juz.startAyah} - ${juz.endSurah} : ${juz.endAyah}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: theme.colorScheme.secondary.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
