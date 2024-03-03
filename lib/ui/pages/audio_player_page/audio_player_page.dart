import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audiobook_project/domen/bloc/bloc/audibook_bloc.dart';
import 'package:audiobook_project/domen/model/position_data.dart';
import 'package:audiobook_project/ui/components/controls.dart';
import 'package:audiobook_project/ui/components/media_meta_data.dart';
import 'package:audiobook_project/ui/pages/downloaded_page/downloaded_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class AudioPlayerPage extends StatefulWidget {
  const AudioPlayerPage({super.key, required this.play, required this.i});
  final play;
  final i;
  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  int index = 0;
    late DatabaseHelper _databaseHelper;
  Future<void> _downloadAndSaveAudio(String url, String name, String title) async {
    final response = await http.get(Uri.parse(url));
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$name';
    File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    await _databaseHelper.insertAudio(name, title, filePath); // Use database helper for database operations
  }
  late AudioPlayer _audioPlayer;
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _audioPlayer.positionStream,
          _audioPlayer.bufferedPositionStream,
          _audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position: position,
              bufferedPosition: bufferedPosition,
              durations: duration ?? Duration.zero));

  @override
  void initState() {
    super.initState();
    index = widget.i;
    _audioPlayer = AudioPlayer();
    _init();
    _databaseHelper = GetIt.instance<DatabaseHelper>();
  }

  Future<void> _init() async {
    await _audioPlayer.setLoopMode(LoopMode.all);
    await _audioPlayer.setAudioSource(widget.play[index]);
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(25),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          StreamBuilder<SequenceState?>(
            stream: _audioPlayer.sequenceStateStream,
            builder: (context, snapshot) {
              final state = snapshot.data;
              if (state?.sequence.isEmpty ?? true) {
                return const SizedBox();
              }
              final metadata = state!.currentSource!.tag as MediaItem;
              return MediaMetadata(
                  imageUrl: metadata.artUri.toString(),
                  name: metadata.artist ?? '',
                  title: metadata.title);
            },
          ),
          StreamBuilder(
            stream: _positionDataStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return ProgressBar(
                barHeight: 8,
                baseBarColor: Colors.blueGrey,
                bufferedBarColor: Colors.grey,
                progressBarColor: Colors.red,
                thumbColor: Colors.red,
                timeLabelTextStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
                progress: positionData?.position ?? Duration.zero,
                total: positionData?.durations ?? Duration.zero,
                buffered: positionData?.bufferedPosition ?? Duration.zero,
                onSeek: _audioPlayer.seek,
              );
            },
          ),
          BlocBuilder<AudibookBloc, AudibookState>(
            builder: (context, state) {
              if (state is AudibookIsLoaded) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            if (index  > 0) {

                              index--;
                            }

                          });
                          _init();
                        },
                        iconSize: 40,
                        color: Colors.black,
                        icon: Icon(Icons.arrow_back_rounded)),
                    Controls(audioPlayer: _audioPlayer),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            if (index  < state.audiobookList.length -1) {
                              index++;
                            }
                          });
                          _init();
                        },
                        iconSize: 40,
                        color: Colors.black,
                        icon: Icon(Icons.arrow_forward)),
                    IconButton(onPressed: ()async{
                      print(state.audiobookList[widget.i].name);
                      await _downloadAndSaveAudio(state.audiobookList[widget.i].track, state.audiobookList[widget.i].name, state.audiobookList[widget.i].title);
                    }, icon: Icon(Icons.download))
                  ],
                );
              }
              return SizedBox();
            },
          ),
        ]),
      ),
    );
  }
}
