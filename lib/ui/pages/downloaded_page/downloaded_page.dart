import 'dart:io';

import 'package:audiobook_project/ui/pages/audio_player_page/audio_player_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class DownloadedPage extends StatefulWidget {
  @override
  _DownloadedPageState createState() => _DownloadedPageState();
}

class _DownloadedPageState extends State<DownloadedPage> {
  final AudioPlayer _player = AudioPlayer();
  late DatabaseHelper _databaseHelper; // Declare an instance of your database helper class

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper(); // Initialize your database helper
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    await _databaseHelper.initializeDatabase(); // Initialize the database
  }

  Future<void> _downloadAndSaveAudio(String url, String name, String title) async {
    final response = await http.get(Uri.parse(url));
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$name';
    File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    await _databaseHelper.insertAudio(name, title, filePath); // Use database helper for database operations
    setState(() {
      
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Player'),
      ),
      body: Column(
        children: [
          
          SizedBox(height: 20),
          Text(
            'Downloaded Audios:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: FutureBuilder<List<Map>>(
              future: _databaseHelper.queryAudios(), // Use database helper for querying audios
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final audios = snapshot.data;
                  return ListView.builder(
                    itemCount: audios?.length ?? 0,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Text('$index'),
                        title: Text(audios![index]['name'] ),
                        subtitle: Text(audios[index]['title']),
                        onTap: () async {
                          String path = audios[index]['path'];
                               List<AudioSource> audiosourcelist = [];

                          for (int i = 0; i < audios.length; i++) {
                            print(audios[index]);
                            audiosourcelist.add(AudioSource.uri(
                              Uri.parse(path),
                              tag: MediaItem(
                                  id: '$index',
                                  title: audios[index]['title'],
                                  artist: audios[index]['name'],
                                  artUri: Uri.parse(
                                      'https://e-cdns-images.dzcdn.net/images/artist/a3c3e1b678e9d53b776916b8a276e023/1000x1000-000000-80-0-0.jpg')),
                            ));
                          }
                          final _playlist = ConcatenatingAudioSource(
                          //   children: [
                          //   AudioSource.uri(
                          //     Uri.parse(path),
                          //     tag: MediaItem(
                          //         id: '0',
                          //         title: 'title',
                          //         artist: 'artist',
                          //         artUri: Uri.parse(
                          //             'https://e-cdns-images.dzcdn.net/images/artist/a3c3e1b678e9d53b776916b8a276e023/1000x1000-000000-80-0-0.jpg')),
                          //   ),
                          // ]
                          children: audiosourcelist
                          );
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    AudioPlayerPage(play: _playlist, i: index),
                              ));
                          // Navigator.push(context, CupertinoPageRoute(builder: (context) => AudioPlayerPage(play: _playlist, i: 2),));
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
class DatabaseHelper {
  Database? _database;

  Future<void> initializeDatabase() async {
    _database = await openDatabase('audio.db', version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE audios (id INTEGER PRIMARY KEY, name TEXT, title TEXT, path TEXT)');
    });
  }

  Future<void> insertAudio(String name, String title, String path) async {
    if (_database == null) {
      // Check if _database is null, if so, initialize it before proceeding
      await initializeDatabase();
    }
    await _database!.insert('audios', {'name': name, 'title': title, 'path': path});
  }

  Future<List<Map<String, dynamic>>> queryAudios() async {
    if (_database == null) {
      // Check if _database is null, if so, initialize it before proceeding
      await initializeDatabase();
    }
    return await _database!.query('audios');
  }
}