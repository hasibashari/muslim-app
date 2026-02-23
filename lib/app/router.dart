import 'package:flutter/material.dart';
import '../features/quran/presentation/pages/reader_page.dart';

class AppRouter {
  static const String surahDetail = '/surah-detail';
  static const String reader = '/reader';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case surahDetail:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ReaderPage(
            surahId: args['surahId'] as int,
            surahName: args['surahName'] as String,
          ),
        );
      case reader:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ReaderPage(
            surahId: args['surahId'] as int,
            surahName: args['surahName'] as String,
            initialAyah: args['initialAyah'] as int? ?? 1,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route not found: ${settings.name}')),
          ),
        );
    }
  }
}
