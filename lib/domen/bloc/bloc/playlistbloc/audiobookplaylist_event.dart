part of 'audiobookplaylist_bloc.dart';


class AudiobookplaylistEvent {}
class AudiobookplaylistLoad extends AudiobookplaylistEvent{
  AudiobookplaylistLoad({required this.index});
  final Set<int> index;
}

