import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'core/storage/app_database.dart';
import 'features/quran/data/datasource/quran_local_datasource.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  QuranLocalDatasource();
  await AppDatabase.instance.initialize();

  runApp(const ProviderScope(child: MyApp()));
}
