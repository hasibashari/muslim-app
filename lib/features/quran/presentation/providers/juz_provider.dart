import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/juz.dart';
import 'quran_provider.dart';

final juzProvider = Provider<AsyncValue<List<Juz>>>((ref) {
  return ref.watch(juzListProvider);
});
