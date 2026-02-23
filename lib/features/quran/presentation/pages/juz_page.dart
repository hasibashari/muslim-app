import 'package:flutter/material.dart';
import '../../domain/entities/juz.dart';
import '../widgets/juz_tile.dart';

class JuzPage extends StatelessWidget {
  final List<Juz> juzList;

  const JuzPage({super.key, required this.juzList});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (juzList.isEmpty) {
      return Center(
        child: Text('Tidak ada data juz', style: theme.textTheme.bodyMedium),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: juzList.length,
      separatorBuilder: (_, _) =>
          Divider(color: theme.dividerColor, height: 1, indent: 72),
      itemBuilder: (context, index) {
        return JuzTile(juz: juzList[index]);
      },
    );
  }
}
