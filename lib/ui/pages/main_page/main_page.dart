import 'package:audiobook_project/domen/api/api.dart';
import 'package:audiobook_project/domen/bloc/bloc/audibook_bloc.dart';
import 'package:audiobook_project/domen/bloc/bloc/playlistbloc/audiobookplaylist_bloc.dart';
import 'package:audiobook_project/domen/model/aduio_book.dart';
import 'package:audiobook_project/ui/pages/audio_player_page/audio_player_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int counter = 0;

  @override
  Widget build(BuildContext context) {
    List<AudioSource> audiosourcelist = [];
    final _playlist = ConcatenatingAudioSource(children: audiosourcelist);
    return Scaffold(
      appBar: AppBar(
        
      ),
      body: BlocBuilder<AudibookBloc, AudibookState>(
        builder: (context, state) {
          if (state is AudibookIsLoaded) {
            for (int i = 0; i < state.audiobookList.length; i++) {
              audiosourcelist.add(AudioSource.uri(
                Uri.parse(state.audiobookList[i].track),
                tag: MediaItem(
                    id: i.toString(),
                    title: state.audiobookList[i].title,
                    artist: state.audiobookList[i].name,
                    artUri: Uri.parse(state.audiobookList[i].image)),
              ));
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                final Set<int> sets = {};
                final list = state.audiobookList[index];
                return ListTile(
                  onTap: () {
                    counter++;
                    for(int i=0 ;i<counter ; i++){
                      sets.add(index);
                    }
                    sets.add(index);
                    BlocProvider.of<AudiobookplaylistBloc>(context,
                            listen: false)
                        .add(AudiobookplaylistLoad(index: sets));
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => AudioPlayerPage(
                            play: _playlist,
                            i: index,
                          ),
                        ));
                  },
                  title: Text(list.title),
                  leading: Image.network(
                    list.image,
                    height: 34,
                  ),
                  subtitle: Text(list.name),
                );
              },
              itemCount: state.audiobookList.length,
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
