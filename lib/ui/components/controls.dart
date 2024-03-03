

import 'package:audiobook_project/domen/bloc/bloc/playlistbloc/audiobookplaylist_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

class Controls extends StatelessWidget {
  const Controls({super.key, required this.audioPlayer});

  final AudioPlayer audioPlayer;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        
        StreamBuilder<PlayerState>(
          stream: audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (!(playing ?? false)) {
              return IconButton(
                  onPressed: (){audioPlayer.play(); 
                  },
                  iconSize: 40,
                  color: Colors.black,
                  icon: const Icon(Icons.play_arrow_rounded));
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                  onPressed: audioPlayer.pause,
                  iconSize: 40,
                  color: Colors.black,
                  icon: Icon(Icons.pause_rounded));
            }
            return const Icon(
              Icons.play_arrow_rounded,
              size: 40,
              color: Colors.black,
            );
          },
        ),

      ],
    );
  }
}
