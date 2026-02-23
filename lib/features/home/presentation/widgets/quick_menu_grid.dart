import 'package:flutter/material.dart';
import '../../../../core/theme/app_color_scheme.dart';

class QuickMenuGrid extends StatelessWidget {
  final void Function(int tabIndex)? onNavigate;

  const QuickMenuGrid({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final menuItems = [
      _MenuItem(
        Icons.auto_stories_rounded,
        'Al-Quran',
        AppColorScheme.accentGreen,
      ),
      _MenuItem(Icons.menu_book_rounded, 'Hadits', AppColorScheme.accentBlue),
      _MenuItem(
        Icons.access_time_rounded,
        'Sholat',
        AppColorScheme.accentOrange,
      ),
      _MenuItem(Icons.favorite_rounded, 'Doa', AppColorScheme.accentRed),
      _MenuItem(Icons.mosque_rounded, 'Kiblat', AppColorScheme.accentPurple),
      _MenuItem(
        Icons.calendar_month_rounded,
        'Kalender',
        AppColorScheme.accentCyan,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Menu', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index];
              return InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: item.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(item.icon, color: item.color, size: 24),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final Color color;

  const _MenuItem(this.icon, this.label, this.color);
}
