part of 'audibook_bloc.dart';


class AudibookState {}

class AudibookInitial extends AudibookState {}
class AudibookIsLoading extends AudibookState {}

class AudibookIsLoaded extends AudibookState {
  AudibookIsLoaded({required this.audiobookList});
  final List<AudioBook> audiobookList;
}
class AudibookLoadingFailure extends AudibookState {
  AudibookLoadingFailure({required this.failure});
  Object failure;
}


