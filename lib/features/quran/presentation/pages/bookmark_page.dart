import 'package:flutter/material.dart';
import '../../domain/entities/bookmark.dart';
import 'reader_page.dart';

class BookmarkPage extends StatelessWidget {
  final List<Bookmark> bookmarks;
  final Future<void> Function(int surahId, int ayahNumber)? onRemove;

  const BookmarkPage({super.key, required this.bookmarks, this.onRemove});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (bookmarks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border_rounded,
              size: 64,
              color: theme.colorScheme.secondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text('Belum ada bookmark', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Tandai ayat favorit Anda', style: theme.textTheme.bodySmall),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: bookmarks.length,
      separatorBuilder: (_, _) =>
          Divider(color: theme.dividerColor, height: 1, indent: 72),
      itemBuilder: (context, index) {
        final bookmark = bookmarks[index];
        return ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.bookmark_rounded,
              color: theme.colorScheme.secondary,
              size: 20,
            ),
          ),
          title: Text(bookmark.surahName, style: theme.textTheme.titleMedium),
          subtitle: Text(
            'Ayat ${bookmark.ayahNumber}',
            style: theme.textTheme.bodySmall,
          ),
          trailing: onRemove != null
              ? IconButton(
                  onPressed: () =>
                      onRemove!(bookmark.surahId, bookmark.ayahNumber),
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: theme.colorScheme.error,
                    size: 20,
                  ),
                )
              : null,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ReaderPage(
                  surahId: bookmark.surahId,
                  surahName: bookmark.surahName,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
