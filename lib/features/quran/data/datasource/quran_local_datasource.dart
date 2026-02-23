import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/storage/app_database.dart';
import '../models/surah_model.dart';
import '../models/ayah_model.dart';
import '../models/bookmark_model.dart';

class QuranLocalDatasource {
  // ── Table / column constants ──
  static const String _bookmarkTable = 'bookmarks';
  static const String _lastReadTable = 'last_read';

  List<SurahModel>? _cachedSurahList;

  QuranLocalDatasource() {
    _registerTables();
  }

  // ── Database registration ──

  void _registerTables() {
    AppDatabase.instance.addMigration(
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $_bookmarkTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            surah_id INTEGER NOT NULL,
            surah_name TEXT NOT NULL,
            ayah_number INTEGER NOT NULL,
            created_at TEXT NOT NULL,
            UNIQUE(surah_id, ayah_number)
          )
        ''');

        await db.execute('''
          CREATE TABLE $_lastReadTable (
            id INTEGER PRIMARY KEY CHECK (id = 1),
            surah_id INTEGER NOT NULL,
            surah_name TEXT NOT NULL,
            ayah_number INTEGER NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Database get _db => AppDatabase.instance.database;

  // ── Asset-based reads (unchanged) ──

  Future<List<SurahModel>> getSurahList() async {
    if (_cachedSurahList != null) return _cachedSurahList!;

    final jsonString = await rootBundle.loadString(
      'assets/surah/surah-list.json',
    );
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    _cachedSurahList = jsonList
        .map((e) => SurahModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return _cachedSurahList!;
  }

  Future<List<AyahModel>> getSurahDetail(int surahId) async {
    final jsonString = await rootBundle.loadString(
      'assets/surah/$surahId.json',
    );
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList
        .map((e) => AyahModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── Bookmark CRUD (SQLite) ──

  Future<void> insertBookmark(BookmarkModel bookmark) async {
    await _db.insert(_bookmarkTable, {
      'surah_id': bookmark.surahId,
      'surah_name': bookmark.surahName,
      'ayah_number': bookmark.ayahNumber,
      'created_at': bookmark.createdAt.toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeBookmark(int surahId, int ayahNumber) async {
    await _db.delete(
      _bookmarkTable,
      where: 'surah_id = ? AND ayah_number = ?',
      whereArgs: [surahId, ayahNumber],
    );
  }

  Future<List<BookmarkModel>> getBookmarks() async {
    final rows = await _db.query(_bookmarkTable, orderBy: 'created_at DESC');
    return rows.map((row) {
      return BookmarkModel.fromJson({
        'surah_id': row['surah_id'],
        'surah_name': row['surah_name'],
        'ayah_number': row['ayah_number'],
        'created_at': row['created_at'],
      });
    }).toList();
  }

  // ── Last-read (SQLite) ──

  Future<void> saveLastRead(BookmarkModel bookmark) async {
    await _db.insert(_lastReadTable, {
      'id': 1,
      'surah_id': bookmark.surahId,
      'surah_name': bookmark.surahName,
      'ayah_number': bookmark.ayahNumber,
      'created_at': bookmark.createdAt.toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<BookmarkModel?> getLastRead() async {
    final rows = await _db.query(_lastReadTable, where: 'id = 1');
    if (rows.isEmpty) return null;
    final row = rows.first;
    return BookmarkModel.fromJson({
      'surah_id': row['surah_id'],
      'surah_name': row['surah_name'],
      'ayah_number': row['ayah_number'],
      'created_at': row['created_at'],
    });
  }
}
