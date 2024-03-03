import 'package:audiobook_project/domen/bloc/bloc/audibook_bloc.dart';
import 'package:audiobook_project/domen/bloc/bloc/playlistbloc/audiobookplaylist_bloc.dart';
import 'package:audiobook_project/ui/pages/downloaded_page/downloaded_page.dart';
import 'package:audiobook_project/ui/pages/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio_background/just_audio_background.dart';

Future<void> main() async {
  GetIt.instance.registerSingleton(DatabaseHelper());
  await JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AudibookBloc()..add(AudibookLoad()),
        ),
                BlocProvider(
          create: (context) =>AudiobookplaylistBloc(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
