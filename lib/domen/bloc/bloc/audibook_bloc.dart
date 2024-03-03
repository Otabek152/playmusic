import 'package:audiobook_project/domen/api/api.dart';
import 'package:audiobook_project/domen/model/aduio_book.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'audibook_event.dart';
part 'audibook_state.dart';

class AudibookBloc extends Bloc<AudibookEvent, AudibookState> {
  AudibookBloc() : super(AudibookInitial()) {
    on<AudibookLoad>((event, emit) async{
      try{
        emit(AudibookIsLoading());
        final audiobookList = await AudioBookRepository().getAudiBookList();
        emit(AudibookIsLoaded(audiobookList: audiobookList));
      }
      catch(e){
        emit(AudibookLoadingFailure(failure: e));
      }
    });
     
  }
}
