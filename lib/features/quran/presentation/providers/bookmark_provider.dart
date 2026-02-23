import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'quran_provider.dart';
import '../../domain/entities/bookmark.dart';

final bookmarkProvider = Provider<AsyncValue<List<Bookmark>>>((ref) {
  return ref.watch(bookmarkListProvider);
});
