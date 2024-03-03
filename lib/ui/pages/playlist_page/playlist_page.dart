import 'package:audiobook_project/domen/bloc/bloc/audibook_bloc.dart';
import 'package:audiobook_project/domen/bloc/bloc/playlistbloc/audiobookplaylist_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayListPage extends StatelessWidget {
  const PlayListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<AudiobookplaylistBloc, AudiobookplaylistState>(
        builder: (context, state) {
          if(state is AudiobookplaylistIsLoaded)
          {return Container(
              child: ListView.builder(
                itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.audioBook.name),
                );
              },
              itemCount: state.counter,
              ),
            );}
            return SizedBox();
        },
      ),
    );
  }
}