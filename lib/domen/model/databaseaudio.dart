import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class DataBaseAudio{
  Database? database;
  Future<void> initializeDatabase() async {
    database = await openDatabase('audio.db', version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE audios (id INTEGER PRIMARY KEY, name TEXT, title TEXT, path TEXT)');
    });
  }
    Future<void> downloadAndSaveAudio(
      String url, String name, String title) async {
    final response = await http.get(Uri.parse(url));
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$name';
    File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    await database
        ?.insert('audios', {'name': name, 'title': title, 'path': filePath});
  }
}