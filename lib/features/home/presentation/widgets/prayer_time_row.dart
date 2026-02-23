import 'package:flutter/material.dart';

class PrayerTimeRow extends StatelessWidget {
  const PrayerTimeRow({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final prayerTimes = [
      _PrayerTime('Subuh', '04:30'),
      _PrayerTime('Dzuhur', '12:05'),
      _PrayerTime('Ashar', '15:20'),
      _PrayerTime('Maghrib', '18:10'),
      _PrayerTime('Isya', '19:25'),
    ];

    // Find next prayer based on current time
    final now = DateTime.now();
    int nextPrayerIndex = 0;
    for (int i = 0; i < prayerTimes.length; i++) {
      final parts = prayerTimes[i].time.split(':');
      final prayerHour = int.parse(parts[0]);
      final prayerMinute = int.parse(parts[1]);
      if (now.hour < prayerHour ||
          (now.hour == prayerHour && now.minute < prayerMinute)) {
        nextPrayerIndex = i;
        break;
      }
      if (i == prayerTimes.length - 1) {
        nextPrayerIndex = 0; // All prayers passed, next is Subuh
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Waktu Sholat', style: theme.textTheme.titleLarge),
              Icon(
                Icons.location_on_rounded,
                color: theme.colorScheme.secondary,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(prayerTimes.length, (index) {
                final prayer = prayerTimes[index];
                final isNext = index == nextPrayerIndex;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 4,
                  ),
                  child: Column(
                    children: [
                      Text(
                        prayer.name,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isNext
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isNext
                              ? theme.colorScheme.secondary
                              : theme.textTheme.bodySmall?.color,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        prayer.time,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isNext
                              ? theme.colorScheme.onSurface
                              : theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                      if (isNext) ...[
                        const SizedBox(height: 4),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayerTime {
  final String name;
  final String time;

  const _PrayerTime(this.name, this.time);
}
