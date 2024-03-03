import 'package:audiobook_project/domen/model/aduio_book.dart';
import 'package:dio/dio.dart';

class AudioBookRepository{
  Future<List<AudioBook>> getAudiBookList() async {
    final dio = Dio();
    final response =
        await dio.get('https://api.deezer.com/playlist/58286310/tracks', queryParameters: {});
    final json = response.data as Map<String, dynamic>;
    final data = json['data'] as List;
    final audiobookList = data.map((e) {
      return AudioBook(title: e['title_short'], name: e['artist']['name'], image: e['artist']['picture_xl'], track: e['preview']);
    }).toList();
    return audiobookList;
  }
}