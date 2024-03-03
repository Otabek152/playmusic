part of 'audiobookplaylist_bloc.dart';


class AudiobookplaylistState {}

final class AudiobookplaylistInitial extends AudiobookplaylistState {}
final class AudiobookplaylistIsLoading extends AudiobookplaylistState {}
final class AudiobookplaylistIsLoaded extends AudiobookplaylistState {
  AudiobookplaylistIsLoaded({required this.audioBook , required this.counter});
  AudioBook audioBook;
  int counter;
}
final class AudiobookplaylistIsFailure extends AudiobookplaylistState {
  AudiobookplaylistIsFailure({required this.e});
  Object e;
}

