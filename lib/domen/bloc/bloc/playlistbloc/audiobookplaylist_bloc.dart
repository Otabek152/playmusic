import 'package:audiobook_project/domen/api/api.dart';
import 'package:audiobook_project/domen/bloc/bloc/audibook_bloc.dart';
import 'package:audiobook_project/domen/model/aduio_book.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'audiobookplaylist_event.dart';
part 'audiobookplaylist_state.dart';

class AudiobookplaylistBloc extends Bloc<AudiobookplaylistEvent, AudiobookplaylistState> {
  AudiobookplaylistBloc() : super(AudiobookplaylistInitial()) {
    on<AudiobookplaylistLoad>((event, emit) async{
      try{
        int counter = 0;
        emit(AudiobookplaylistIsLoading());
        final audiobookList = await AudioBookRepository().getAudiBookList();
        print(event.index.length);
        emit(AudiobookplaylistIsLoaded(audioBook: audiobookList[event.index.elementAt(0)] ,counter: event.index.length));
      }
      catch(e){
        emit(AudiobookplaylistIsFailure(e: e));
      }
    });
  }
}
