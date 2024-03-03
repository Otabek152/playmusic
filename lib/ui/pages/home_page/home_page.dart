
import 'package:audiobook_project/ui/components/tab_bar_widget.dart';
import 'package:audiobook_project/ui/pages/downloaded_page/downloaded_page.dart';
import 'package:audiobook_project/ui/pages/main_page/main_page.dart';
import 'package:audiobook_project/ui/pages/playlist_page/playlist_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
      static List<Widget> screens = [
    const MainPage(),
    const PlayListPage(),
    DownloadedPage(),
  ];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: TabBarWidget(screens: screens),
    );
  }
}