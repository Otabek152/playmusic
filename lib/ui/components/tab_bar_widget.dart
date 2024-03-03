
import 'package:audiobook_project/ui/components/tab_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabBarWidget extends StatelessWidget {
  const TabBarWidget({
    super.key,
    required this.screens,
  });

  final List<Widget> screens;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      // backgroundColor: CryptoColors.notblack,
      tabBar: CupertinoTabBar(
        height: 70,
        items: const [
          BottomNavigationBarItem(
            icon: NavigationTabItem(
              icon: Icons.home_filled,
              active: false,
              text: 'HomePage',
            ),
            activeIcon: NavigationTabItem(
              icon: Icons.home_filled,
              active: true,
              text: 'HomePage',
            ),
          ),
          BottomNavigationBarItem(
            icon: NavigationTabItem(
              icon: Icons.playlist_play,
              active: false,
              text: 'Playlist',
            ),
            activeIcon: NavigationTabItem(
              icon: Icons.playlist_play,
              active: true,
              text: 'Playlist',
            ),
          ),
          BottomNavigationBarItem(
            icon: NavigationTabItem(
              icon: Icons.download,
              active: false,
              text: 'Downloaded',
            ),
            activeIcon: NavigationTabItem(
              icon: Icons.download,
              active: true,
              text: 'Downloaded',
            ),
          ),
          
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            return screens[index];
          },
        );
      },
    );
  }
}
